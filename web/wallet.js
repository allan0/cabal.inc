// web/wallet.js

// This file acts as a bridge between Flutter and the Web3Modal JavaScript library.

let web3modal;
let ethersProvider;
let signer;

// This function is called by Flutter to initialize everything.
async function initializeWalletConnect(projectId) {
    if (web3modal) return; // Already initialized

    const { W3mCore, W3mEthers } = await import("https://unpkg.com/@web3modal/ethers5@3.1.0/dist/ethers5-3.1.0.js");

    const modal = new W3mCore({ projectId });
    
    web3modal = new W3mEthers({
        w3mCore: modal,
        ethersConfig: {
            metadata: {
                name: 'Cabal',
                description: 'Cabal App',
                url: 'https://cabal-001.web.app',
                icons: ['https://cabal-001.web.app/icons/Icon-512.png']
            }
        }
    });

    console.log("Web3Modal Initialized");
}

// Function to connect the wallet
async function connectWallet() {
    if (!web3modal) {
        throw new Error("Web3Modal not initialized. Call initializeWalletConnect first.");
    }
    try {
        await web3modal.open();
        // After the modal closes, we can get the address.
        const address = await web3modal.getAddress();
        return address;
    } catch (e) {
        console.error("Could not connect wallet.", e);
        return null;
    }
}

// Function to disconnect the wallet
async function disconnectWallet() {
    if (!web3modal) return;
    await web3modal.disconnect();
    return null; // Return null to confirm disconnection
}

// Function to get the current chain ID
async function getChainId() {
    if (!web3modal) return null;
    return await web3modal.getChainId();
}
