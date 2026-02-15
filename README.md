# Decentralized Clearing Network (DCN)

Provides low cost, fast, and secure settlement for hybrid decentralized exchanges. The DCN was developed by [merkleX](https://merklex.io). More information can be [found here](https://merklex.io/blog/decentralized-clearing-network/).

---

## 🚀 Canton Network Migration

**Important**: Este repositório contém a implementação original do DCN em Ethereum. Estamos planejando uma migração para a Canton Network para aproveitar recursos avançados de privacidade, performance e interoperabilidade.

**Important**: This repository contains the original Ethereum implementation of DCN. We are planning a migration to Canton Network to leverage advanced privacy, performance, and interoperability features.

### 📋 Documentos de Planejamento / Planning Documents

| Documento / Document | Descrição / Description |
| -------------------- | ----------------------- |
| [**EXECUTIVE_RECOMMENDATION.md**](EXECUTIVE_RECOMMENDATION.md) | 🎯 **Recomendação executiva e decisão estratégica** / Executive recommendation and strategic decision |
| [**CANTON_MIGRATION_PLAN.md**](CANTON_MIGRATION_PLAN.md) | 📖 **Plano completo de migração (15-20 semanas)** / Complete migration plan (15-20 weeks) |
| [**ARCHITECTURE_COMPARISON.md**](ARCHITECTURE_COMPARISON.md) | ⚖️ **Comparação detalhada Ethereum vs Canton** / Detailed Ethereum vs Canton comparison |
| [**QUICKSTART_GUIDE.md**](QUICKSTART_GUIDE.md) | 🚀 **Guia rápido para começar desenvolvimento** / Quick start guide for development |
| [**FAQ.md**](FAQ.md) | ❓ **Perguntas frequentes** / Frequently Asked Questions |

### 📌 Recomendação Principal / Main Recommendation

**✅ Criar um novo projeto Canton-native** ao invés de adaptar o código Ethereum existente.

**✅ Create a new Canton-native project** instead of adapting the existing Ethereum code.

**Razão / Reason**: Arquiteturas fundamentalmente diferentes requerem designs distintos para melhor aproveitamento das capacidades de cada plataforma.

**Próximos Passos / Next Steps**:
1. Revisar documentos de planejamento
2. Aprovar estratégia de migração
3. Alocar recursos e equipe
4. Iniciar desenvolvimento de PoC Canton

---

## 📚 Ethereum DCN (Current Implementation)

### Deployed Contracts

| Contract | Contract Address |
| -- | -- |
| DCN | [0x84f6451efe944ba67bedb8e0cf996fa1feb4031d](https://etherscan.io/address/0x84f6451efe944ba67bedb8e0cf996fa1feb4031d) |
| WethDeposit | [0xe354411f327ddd8b3e776b2e3028c523d1618825](https://etherscan.io/address/0xe354411f327ddd8b3e776b2e3028c523d1618825) |

### Noteworthy Files

| Description | Location |
| -- | -- |
| DCN source | [src/main/resources/contracts/DCN.sol](src/main/resources/contracts/DCN.sol) |
| DCN transpiled | [contracts-compiled/DCN/DCN.sol](contracts-compiled/DCN/DCN.sol) |
| WethDeposit source | [src/main/resources/contracts/WethDeposit.sol](src/main/resources/contracts/WethDeposit.sol) |
| WethDeposit transpiled | [contracts-compiled/WethDeposit/WethDeposit.sol](contracts-compiled/WethDeposit/WethDeposit.sol) |

### Key Features

- User account management (up to 2^64 users)
- Exchange registration and management (up to 2^32 exchanges)  
- Asset registration (up to 2^32 assets)
- Multi-party settlement processing
- Balance tracking and session management
- Security features (feature locks, recovery mechanisms)
- Cryptographic signature verification
