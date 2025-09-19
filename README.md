# ERC20 Token with Foundry

A simple ERC20 token built using **OpenZeppelin** and **Foundry**, with deployment scripts and a comprehensive test suite.  
This project is great as a learning resource for understanding ERC20 tokens, Foundry scripting, and Solidity testing.

---

## 📦 Features
- **ERC20 implementation** using OpenZeppelin (`OurToken.sol`)
- **Manual token example** (`ManualToken.sol`) showing how an ERC20 could be implemented from scratch
- **Deployment script** (`DeployOurToken.s.sol`)
- **Comprehensive test suite**:
  - Initial supply checks
  - Transfers & events
  - Allowances & `transferFrom`
  - Edge cases (zero address, insufficient balance, etc.)

---

## 🚀 Getting Started

### Prerequisites
- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Git](https://git-scm.com/)

Install Foundry if not installed:
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

## Installation
Clone this repository and install dependencies:

```bash
git clone https://github.com/BELALZEDAN/erc20-token-foundry.git
cd erc20-token-foundry
forge install
```

## ⚡ Usage
Build Contracts
```bash
forge build
```

Run Tests
```bash
forge test
```

Coverage
```bash
forge coverage
```

Local Blockchain
You can start a local blockchain with Anvil:

```bash
anvil
```

## 📂 Project Structure
```
├── src
│   ├── OurToken.sol         # ERC20 implementation using OpenZeppelin
│   └── ManualToken.sol      # Manual ERC20-like implementation
├── script
│   └── DeployOurToken.s.sol # Deployment script
├── test
│   └── OurTokenTest.t.sol   # Comprehensive ERC20 tests
├── foundry.toml             # Foundry configuration
└── Makefile                 # Build/test shortcuts
```

## 🧪 Example Test (from OurTokenTest)
```solidity
function testTransferUpdatesBalances() public {
    vm.prank(user1);
    ourToken.transfer(user2, 50 ether);

    assertEq(ourToken.balanceOf(user1), 50 ether);
    assertEq(ourToken.balanceOf(user2), 50 ether);
}
```

## 🌐 Deploy to Testnet (Sepolia)

### Environment Setup
1. Create a `.env` file:
```bash
cp .env.example .env
```

2. Add your environment variables:
```
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/your-project-id
PRIVATE_KEY=your_wallet_private_key
ETHERSCAN_API_KEY=your_etherscan_api_key
```

### Deployment Command
```bash
forge script script/DeployOurToken.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY -vvvv
```

### Verify Contract
```bash
forge verify-contract --chain-id 11155111 --etherscan-api-key $ETHERSCAN_API_KEY <DEPLOYED_ADDRESS> src/OurToken.sol:OurToken --constructor-args $(cast abi-encode "constructor(string,string)" "OurToken" "OTK")
```

