# Canton Clearing Network (CCN)

## Overview

This is the Canton Network implementation of the Decentralized Clearing Network (DCN). This project represents a complete re-architecture of the original Ethereum-based DCN to leverage Canton Network's advanced privacy, interoperability, and performance features.

## 🚀 Quick Start

### Prerequisites

- Java Development Kit (JDK) 11 or higher
- Daml SDK 2.9.0 or higher
- Canton SDK

### Installation

1. Install Daml SDK:
```bash
curl -sSL https://get.daml.com/ | sh
```

2. Verify installation:
```bash
daml version
```

### Building the Project

1. Navigate to the daml directory:
```bash
cd canton-clearing-network/daml
```

2. Build the project:
```bash
daml build
```

Or use the provided script (already executable):
```bash
cd canton-clearing-network
./scripts/build.sh
```

3. Run tests:
```bash
daml test
```

Or use the provided script:
```bash
./scripts/test.sh
```

### Running Canton Locally

1. Start Canton with local configuration:
```bash
cd canton-clearing-network
canton -c canton-config/local/local.conf
```

Or use the provided script (already executable):
```bash
./scripts/start-local.sh
```

2. Deploy DAR file:
```bash
daml ledger upload-dar .daml/dist/canton-clearing-network-0.1.0.dar --host localhost --port 4002
```

**Note**: All scripts in the `scripts/` directory are already marked as executable.

## 📁 Project Structure

```
canton-clearing-network/
├── daml/                          # Daml smart contracts
│   ├── src/                       # Source templates
│   │   ├── User.daml             # User account templates
│   │   ├── Exchange.daml         # Exchange templates
│   │   ├── Asset.daml            # Asset templates
│   │   ├── Settlement.daml       # Settlement templates
│   │   ├── Session.daml          # Session templates
│   │   └── DCNOperator.daml      # Operator templates
│   ├── tests/                     # Test scripts
│   └── daml.yaml                  # Project configuration
├── java-integration/              # Java integration layer
│   └── src/main/java/io/merklex/canton/dcn/
│       └── DCNClient.java        # Java client for Canton DCN
├── canton-config/                 # Canton configurations
│   ├── local/                     # Local development config
│   ├── test/                      # Test environment config
│   └── prod/                      # Production config
├── docs/                          # Documentation
│   ├── pt-br/                     # Portuguese documentation
│   └── en/                        # English documentation
├── scripts/                       # Utility scripts
└── migration-tools/               # Tools for migrating from Ethereum
```

## 🔑 Key Features

- **Privacy**: Sub-transaction privacy for settlements
- **Multi-party Workflows**: Native support for complex clearing operations
- **Interoperability**: Can interact with multiple financial systems
- **Scalability**: Horizontal scaling across multiple Canton domains
- **Regulatory Compliance**: Better audit trails and selective disclosure

## 📚 Core Templates

### User.daml
- `UserAccount`: Represents user accounts in the network
- `UserBalance`: Tracks user balances for each asset

### Exchange.daml
- `RegisteredExchange`: Registered exchanges in the network
- `ExchangeSession`: Trading sessions for exchanges

### Asset.daml
- `RegisteredAsset`: Registered assets in the network
- `AssetSupply`: Asset supply information

### Settlement.daml
- `SettlementRequest`: Settlement requests
- `MultiPartySettlement`: Multi-party settlement operations

### Session.daml
- `TradingSession`: Trading sessions
- `SettlementSession`: Settlement sessions

### DCNOperator.daml
- `DCNOperatorRole`: Operator role and permissions
- `NetworkConfiguration`: Network-wide configuration
- `OperatorActionLog`: Audit log of operator actions

## 🔗 Integration

The Java integration layer provides a client library for interacting with the Canton DCN from Java applications. See `java-integration/` for details.

## 📖 Documentation

- [Architecture Documentation (English)](docs/en/ARCHITECTURE.md)
- [Documentação de Arquitetura (Português)](docs/pt-br/ARQUITETURA.md)
- [Project Summary](PROJECT_SUMMARY.md)
- Migration Guide - See [migration-tools/README.md](migration-tools/README.md)

## 🤝 Contributing

This is a private project for fintech-private-market. Please follow internal contribution guidelines.

## 📄 License

See LICENSE file for details.

## 🔗 Related Projects

- [Original Ethereum DCN](../) - The original Ethereum-based implementation
- [Canton Network](https://www.canton.io/) - The underlying Canton platform

## ⚠️ Status

This project is in active development. It represents the Canton Network implementation phase of the DCN migration plan.

For more information about the migration strategy, see:
- [EXECUTIVE_RECOMMENDATION.md](../EXECUTIVE_RECOMMENDATION.md)
- [CANTON_MIGRATION_PLAN.md](../CANTON_MIGRATION_PLAN.md)
- [QUICKSTART_GUIDE.md](../QUICKSTART_GUIDE.md)
