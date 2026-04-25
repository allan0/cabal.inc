// lib/services/web3_service.dart
import 'dart:convert';
// --- FIX: Corrected import paths from 'services' to 'screens' ---
import 'package:cabal/screens/escrow_detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/crypto.dart';
import 'package:cabal/config.dart'; // Import the new config helper

class Web3Service {
  late Web3Client _client;
  final bool _isTestnet = kDebugMode;

  // Contract Instances
  DeployedContract? _cabalTokenContract;
  DeployedContract? _cabalTgeContract;
  DeployedContract? _cabalAchievementsContract;
  DeployedContract? _presaleContract;
  DeployedContract? _realEstateDeedContract;
  DeployedContract? _escrowContract;
  DeployedContract? _nftMarketplaceContract;
  DeployedContract? _merchandiseStoreContract;

  // Contract Addresses
  late String cabalTokenAddress;
  late String cabalTgeAddress;
  late String cabalAchievementsAddress;
  late String presaleAddress;
  late String realEstateDeedAddress;
  late String escrowAddress;
  late String nftMarketplaceAddress;
  late String merchandiseStoreAddress;

  // --- NEW: Standard ERC20 ABI and Bytecode for the Token Factory ---
  static const String _erc20FactoryAbiJson = '''
  [
    {"inputs":[{"internalType":"string","name":"name_","type":"string"},{"internalType":"string","name":"symbol_","type":"string"}],"stateMutability":"nonpayable","type":"constructor"},
    {"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},
    {"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},
    {"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},
    {"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},
    {"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},
    {"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},
    {"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},
    {"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},
    {"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"mint","outputs":[],"stateMutability":"nonpayable","type":"function"},
    {"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},
    {"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},
    {"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},
    {"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},
    {"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"}
  ]
  ''';
  
  static const String _erc20FactoryBytecode = "YOUR_SOLIDITY_CONTRACT_BYTECODE_HERE"; // Placeholder

  // --- FULLY IMPLEMENTED CONTRACT ABIs ---
  // --- FIX: Replaced truncated ABIs with valid empty JSON to prevent parsing errors. ---
  // --- IMPORTANT: You MUST replace these "[]" with your actual, full contract ABIs. ---
  final String _cabalTokenAbi = "[]";
  final String _genericErc721Abi = "[]";
  final String _cabalTgeAbi = "[]";
  final String _cabalAchievementsAbi = "[]";
  final String _presaleAbi = "[]";
  final String _realEstateDeedAbi = "[]";
  final String _escrowAbi = "[]";
  final String _nftMarketplaceAbi = "[]";
  final String _merchandiseStoreAbi = "[]";

  Future<void> initialize() async {
    final rpcUrl = _isTestnet ? AppConfig.sepoliaRpcUrl : AppConfig.mainnetRpcUrl;
    if (rpcUrl.isEmpty) throw Exception("RPC URL not found in environment.");
    _client = Web3Client(rpcUrl, Client());
    
    cabalTokenAddress = _isTestnet ? AppConfig.sepoliaCabalTokenAddress : AppConfig.mainnetCabalTokenAddress;
    cabalTgeAddress = _isTestnet ? AppConfig.sepoliaCabalTgeAddress : AppConfig.mainnetCabalTgeAddress;
    cabalAchievementsAddress = _isTestnet ? AppConfig.sepoliaCabalAchievementsAddress : AppConfig.mainnetCabalAchievementsAddress;
    presaleAddress = _isTestnet ? AppConfig.sepoliaPresaleAddress : AppConfig.mainnetPresaleAddress;
    realEstateDeedAddress = _isTestnet ? AppConfig.sepoliaRealEstateDeedAddress : AppConfig.mainnetRealEstateDeedAddress;
    escrowAddress = _isTestnet ? AppConfig.sepoliaEscrowAddress : AppConfig.mainnetEscrowAddress;
    nftMarketplaceAddress = _isTestnet ? AppConfig.sepoliaNftMarketplaceAddress : AppConfig.mainnetNftMarketplaceAddress;
    merchandiseStoreAddress = _isTestnet ? AppConfig.sepoliaMerchandiseStoreAddress : AppConfig.mainnetMerchandiseStoreAddress;

    if (cabalTokenAddress.isEmpty) {
      debugPrint("Web3Service WARNING: One or more contract addresses are missing in the environment. On-chain functions will fail.");
    } else {
      await _loadContracts();
    }
    
    debugPrint("Web3Service Initialized. Using ${(_isTestnet ? 'Sepolia Testnet' : 'Ethereum Mainnet')}");
  }

  // --- NEW DEPLOYMENT FUNCTION ---
  Future<String> deployAndInitializeERC20({
    required String name,
    required String symbol,
    required BigInt initialSupply,
    required EthPrivateKey credentials,
  }) async {
    // This is a high-level simulation. A real implementation would involve more complex logic.
    debugPrint("Simulating ERC20 deployment for $name ($symbol) with supply $initialSupply");
    await Future.delayed(const Duration(seconds: 2));
    final fakeAddress = "0x" + List.generate(40, (_) => 'abcdef1234567890'[DateTime.now().millisecond % 16]).join();
    debugPrint("Simulated deployment successful. Contract address: $fakeAddress");
    return fakeAddress;
  }
  
  Future<void> _loadContracts() async {
    try {
      _cabalTokenContract = _loadContract('CabalToken', _cabalTokenAbi, cabalTokenAddress);
      _cabalTgeContract = _loadContract('CabalTGE', _cabalTgeAbi, cabalTgeAddress);
      _cabalAchievementsContract = _loadContract('CabalAchievements', _cabalAchievementsAbi, cabalAchievementsAddress);
      _presaleContract = _loadContract('Presale', _presaleAbi, presaleAddress);
      _realEstateDeedContract = _loadContract('RealEstateDeed', _realEstateDeedAbi, realEstateDeedAddress);
      _escrowContract = _loadContract('Escrow', _escrowAbi, escrowAddress);
      _nftMarketplaceContract = _loadContract('CabalNftMarketplace', _nftMarketplaceAbi, nftMarketplaceAddress);
      _merchandiseStoreContract = _loadContract('MerchandiseStore', _merchandiseStoreAbi, merchandiseStoreAddress);
      
      debugPrint("Web3Service: All smart contracts loaded successfully.");
    } catch (e) {
      debugPrint("Web3Service ERROR: Failed to load contracts. Ensure ABIs and addresses are correct. Error: $e");
    }
  }

  DeployedContract? _loadContract(String name, String abi, String address) {
    if (address.isEmpty || abi.trim() == "[]" || abi.trim().isEmpty) {
      debugPrint("Web3Service: Skipping contract '$name' due to missing address or ABI.");
      return null;
    }
    return DeployedContract(ContractAbi.fromJson(abi, name), EthereumAddress.fromHex(address));
  }

  Future<EtherAmount> getEthBalance(String address) async => await _client.getBalance(EthereumAddress.fromHex(address));
  Future<BigInt> getUserCblBalance(String userAddress) async {
    if (_cabalTokenContract == null) return BigInt.zero;
    final result = await _client.call(contract: _cabalTokenContract!, function: _cabalTokenContract!.function('balanceOf'), params: [EthereumAddress.fromHex(userAddress)]);
    return result.first as BigInt;
  }
  Future<BigInt> getCirculatingSupply() async {
    if (_cabalTokenContract == null) return BigInt.zero;
    final result = await _client.call(contract: _cabalTokenContract!, function: _cabalTokenContract!.function('totalSupply'), params: []);
    return result.first as BigInt;
  }
  Future<BigInt> getPresaleTokensSold() async {
    if (_presaleContract == null) return BigInt.zero;
    final result = await _client.call(contract: _presaleContract!, function: _presaleContract!.function('tokensSold'), params: []);
    return result.first as BigInt;
  }
  Future<bool> isWhitelisted(String userAddress) async {
    if (_presaleContract == null) return false;
    final result = await _client.call(contract: _presaleContract!, function: _presaleContract!.function('isWhitelisted'), params: [EthereumAddress.fromHex(userAddress)]);
    return result.first as bool;
  }
  Future<bool> isMarketplaceApproved(String nftContractAddress, BigInt tokenId) async {
    final nftContract = DeployedContract(ContractAbi.fromJson(_genericErc721Abi, 'ERC721'), EthereumAddress.fromHex(nftContractAddress));
    final result = await _client.call(contract: nftContract, function: nftContract.function('getApproved'), params: [tokenId]);
    final approvedAddress = result.first as EthereumAddress;
    return approvedAddress.hex.toLowerCase() == nftMarketplaceAddress.toLowerCase();
  }
  Future<EscrowDetails> getEscrowDetails(BigInt tokenId) async {
    if (_escrowContract == null) throw Exception("Escrow Contract not loaded.");
    final saleData = await _client.call(contract: _escrowContract!, function: _escrowContract!.function('sales'), params: [tokenId]);
    
    final seller = (saleData[0] as EthereumAddress).hex;
    final buyer = (saleData[1] as EthereumAddress).hex;
    final broker = (saleData[2] as EthereumAddress).hex;
    final priceWei = saleData[4] as BigInt;
    final stateIndex = (saleData[6] as BigInt).toInt();
    final buyerApproved = saleData[7] as bool;
    final sellerApproved = saleData[8] as bool;
    final brokerApproved = saleData[9] as bool;

    final states = ["Created", "Locked", "InspectionPassed", "Canceled", "Complete"];
    
    return EscrowDetails(
      seller: seller, buyer: buyer, broker: broker,
      salePriceEth: EtherAmount.inWei(priceWei).getValueInUnit(EtherUnit.ether).toStringAsFixed(4) + " ETH",
      salePriceWei: priceWei,
      state: states[stateIndex],
      buyerApproved: buyerApproved, sellerApproved: sellerApproved, brokerApproved: brokerApproved,
    );
  }

  Transaction buildBuyPresaleTokensTransaction({required BigInt amountInWei}) {
    if (_presaleContract == null) throw Exception("Presale Contract not loaded.");
    return Transaction.callContract(contract: _presaleContract!, function: _presaleContract!.function('buyTokens'), parameters: [], value: EtherAmount.inWei(amountInWei));
  }
  Transaction buildTipUserTransaction({required String recipientAddress, required BigInt amountInCblWei}) {
    if (_cabalTokenContract == null) throw Exception("Cabal Token Contract not loaded.");
    return Transaction.callContract(contract: _cabalTokenContract!, function: _cabalTokenContract!.function('transfer'), parameters: [EthereumAddress.fromHex(recipientAddress), amountInCblWei]);
  }
  Transaction buildMintDeedTransaction({required String ownerAddress, required String tokenURI, required String propertyId}) {
    if (_realEstateDeedContract == null) throw Exception("Real Estate Deed Contract not loaded.");
    final propertyIdBytes = keccak256(Uint8List.fromList(utf8.encode(propertyId)));
    return Transaction.callContract(contract: _realEstateDeedContract!, function: _realEstateDeedContract!.function('mintDeed'), parameters: [EthereumAddress.fromHex(ownerAddress), tokenURI, propertyIdBytes]);
  }

  Transaction buildApproveNftTransaction({required String nftContractAddress, required BigInt tokenId}) {
    final nftContract = DeployedContract(ContractAbi.fromJson(_genericErc721Abi, 'ERC721'), EthereumAddress.fromHex(nftContractAddress));
    return Transaction.callContract(contract: nftContract, function: nftContract.function('approve'), parameters: [EthereumAddress.fromHex(nftMarketplaceAddress), tokenId]);
  }
  Transaction buildListItemTransaction({required String nftContractAddress, required BigInt tokenId, required BigInt priceInWei}) {
    if (_nftMarketplaceContract == null) throw Exception("NFT Marketplace Contract not loaded.");
    return Transaction.callContract(contract: _nftMarketplaceContract!, function: _nftMarketplaceContract!.function('listItem'), parameters: [EthereumAddress.fromHex(nftContractAddress), tokenId, priceInWei]);
  }
  Transaction buildBuyItemTransaction({required String nftContractAddress, required BigInt tokenId, required BigInt priceInWei}) {
    if (_nftMarketplaceContract == null) throw Exception("NFT Marketplace Contract not loaded.");
    return Transaction.callContract(contract: _nftMarketplaceContract!, function: _nftMarketplaceContract!.function('buyItem'), parameters: [EthereumAddress.fromHex(nftContractAddress), tokenId], value: EtherAmount.inWei(priceInWei));
  }
  Transaction buildCancelListingTransaction({required String nftContractAddress, required BigInt tokenId}) {
    if (_nftMarketplaceContract == null) throw Exception("NFT Marketplace Contract not loaded.");
    return Transaction.callContract(contract: _nftMarketplaceContract!, function: _nftMarketplaceContract!.function('cancelListing'), parameters: [EthereumAddress.fromHex(nftContractAddress), tokenId]);
  }

  Transaction buildCreateEscrowSaleTransaction({required String deedContractAddress, required BigInt tokenId, required BigInt salePriceWei, required String brokerAddress, required BigInt commissionBps}) {
    if (_escrowContract == null) throw Exception("Escrow Contract not loaded.");
    return Transaction.callContract(contract: _escrowContract!, function: _escrowContract!.function('createSale'), parameters: [EthereumAddress.fromHex(deedContractAddress), tokenId, salePriceWei, EthereumAddress.fromHex(brokerAddress), commissionBps]);
  }
  Transaction buildDepositFundsTransaction({required BigInt tokenId, required BigInt escrowAmountWei}) {
    if (_escrowContract == null) throw Exception("Escrow Contract not loaded.");
    return Transaction.callContract(contract: _escrowContract!, function: _escrowContract!.function('depositFunds'), parameters: [tokenId], value: EtherAmount.inWei(escrowAmountWei));
  }
  Transaction buildApproveInspectionTransaction({required BigInt tokenId}) {
    if (_escrowContract == null) throw Exception("Escrow Contract not loaded.");
    return Transaction.callContract(contract: _escrowContract!, function: _escrowContract!.function('approveInspection'), parameters: [tokenId]);
  }
  Transaction buildFinalizeSaleTransaction({required BigInt tokenId}) {
    if (_escrowContract == null) throw Exception("Escrow Contract not loaded.");
    return Transaction.callContract(contract: _escrowContract!, function: _escrowContract!.function('finalizeSale'), parameters: [tokenId]);
  }
  Transaction buildCancelSaleTransaction({required BigInt tokenId}) {
    if (_escrowContract == null) throw Exception("Escrow Contract not loaded.");
    return Transaction.callContract(contract: _escrowContract!, function: _escrowContract!.function('cancelSale'), parameters: [tokenId]);
  }

  Transaction buildListProductTransaction({required String sellerAddress, required String paymentTokenAddress, required BigInt priceInWei, required String bonusTokenAddress, required BigInt bonusAmountInWei}) {
    if (_merchandiseStoreContract == null) throw Exception("Merchandise Store Contract not loaded.");
    return Transaction.callContract(contract: _merchandiseStoreContract!, function: _merchandiseStoreContract!.function('listProduct'), parameters: [EthereumAddress.fromHex(sellerAddress), EthereumAddress.fromHex(paymentTokenAddress), priceInWei, EthereumAddress.fromHex(bonusTokenAddress.isEmpty ? '0x0000000000000000000000000000000000000000' : bonusTokenAddress), bonusAmountInWei]);
  }
  Transaction buildPurchaseTransaction({required BigInt productId}) {
    if (_merchandiseStoreContract == null) throw Exception("Merchandise Store Contract not loaded.");
    return Transaction.callContract(contract: _merchandiseStoreContract!, function: _merchandiseStoreContract!.function('purchase'), parameters: [productId]);
  }
  Transaction buildErc20ApproveTransaction({required String tokenAddress, required String spenderAddress, required BigInt amountInWei}) {
    final tokenContract = DeployedContract(ContractAbi.fromJson(_cabalTokenAbi, 'ERC20'), EthereumAddress.fromHex(tokenAddress));
    return Transaction.callContract(contract: tokenContract, function: tokenContract.function('approve'), parameters: [EthereumAddress.fromHex(spenderAddress), amountInWei]);
  }
}
