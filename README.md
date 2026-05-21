# Cabal.inc | The Web3 Growth Engine

Cabal is a premium, wallet-first engagement platform built with **Flutter**, **Supabase**, and **TON/EVM** blockchain integration.

## 🚀 Key Features
- **Wallet-First Auth:** Instant profile provisioning via TON Connect or MetaMask.
- **Quest Engine:** Complex mission logic with cooldowns and manual verification.
- **On-Chain Economy:** Integrated NFT Marketplace for tokenized Real Estate and native $CBL tipping.
- **Creator Tools:** Self-service ERC20 Token Factory and community management dashboard.

## 🛠 Tech Stack
- **Frontend:** Flutter (Web & Mobile)
- **Backend:** Supabase (Auth, Postgres, Edge Functions)
- **Blockchain:** TON, Ethereum (Sepolia), and Base.
- **Infrastructure:** Firebase Hosting & GitHub Actions.

## 📦 Deployment
This repository is configured for automatic deployment to Firebase Hosting via GitHub Actions. 
Ensure the following secrets are set in GitHub:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `WALLET_CONNECT_PROJECT_ID`
- `FIREBASE_SERVICE_ACCOUNT_CABAL`
