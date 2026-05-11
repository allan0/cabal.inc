// web/ton_bridge.js

// This handles the low-level communication with the TON Blockchain providers.
window.tonBridge = {
    connect: async function(manifestUrl) {
        try {
            // Check if TonConnect is already in the window (injected by script tag)
            if (typeof TonConnectUI === 'undefined') {
                throw new Error("TonConnect SDK not loaded");
            }

            const tonConnectUI = new TonConnectUI.TonConnectUI({
                manifestUrl: manifestUrl,
                buttonRootId: null // We handle the UI in Flutter
            });

            const connectedWallet = await tonConnectUI.connectWallet();
            // Return the raw address to Flutter
            return connectedWallet.account.address;
        } catch (error) {
            console.error("TON Bridge Error:", error);
            return null;
        }
    },

    sendTransaction: async function(address, amount, payload) {
        // Logic to trigger the wallet approval popup
        const transaction = {
            validUntil: Math.floor(Date.now() / 1000) + 60,
            messages: [
                {
                    address: address,
                    amount: amount.toString(),
                    payload: payload || ""
                }
            ]
        };
        return await tonConnectUI.sendTransaction(transaction);
    }
};
