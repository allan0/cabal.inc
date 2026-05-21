import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import '../config.dart';

class Web3Service {
  late Web3Client _client;
  final bool _isTestnet = kDebugMode;

  // Standard ABIs for interacting with the Cabal Economy
  final String _erc20Abi = '[{"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"}]';
  final String _marketplaceAbi = '[{"inputs":[{"internalType":"address","name":"nftAddress","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"buyItem","outputs":[],"stateMutability":"payable","type":"function"}]';

  void initialize() {
    final rpcUrl = _isTestnet ? AppConfig.sepoliaRpcUrl : "https://mainnet.infura.io/v3/your-key";
    _client = Web3Client(rpcUrl, Client());
    debugPrint("Web3Service: Composition layer active on ${_isTestnet ? 'Sepolia' : 'Mainnet'}");
  }

  /// Builds a transaction to tip a creator in $CBL (ERC20)
  Transaction buildTipTransaction({
    required String senderAddress,
    required String recipientAddress,
    required double amountCbl,
  }) {
    final contract = DeployedContract(
      ContractAbi.fromJson(_erc20Abi, 'CabalToken'),
      EthereumAddress.fromHex(AppConfig.sepoliaCabalTokenAddress),
    );

    final amountWei = BigInt.from(amountCbl * pow(10, 18));

    return Transaction.callContract(
      contract: contract,
      function: contract.function('transfer'),
      parameters: [EthereumAddress.fromHex(recipientAddress), amountWei],
      from: EthereumAddress.fromHex(senderAddress),
    );
  }

  /// Builds a transaction to purchase an NFT from the Marketplace
  Transaction buildBuyItemTransaction({
    required String senderAddress,
    required String nftContractAddress,
    required int tokenId,
    required BigInt priceWei,
  }) {
    final contract = DeployedContract(
      ContractAbi.fromJson(_marketplaceAbi, 'CabalMarketplace'),
      EthereumAddress.fromHex(AppConfig.sepoliaNftMarketplaceAddress),
    );

    return Transaction.callContract(
      contract: contract,
      function: contract.function('buyItem'),
      parameters: [EthereumAddress.fromHex(nftContractAddress), BigInt.from(tokenId)],
      from: EthereumAddress.fromHex(senderAddress),
      value: EtherAmount.inWei(priceWei),
    );
  }

  Future<EtherAmount> getEthBalance(String address) async {
    return await _client.getBalance(EthereumAddress.fromHex(address));
  }
}
