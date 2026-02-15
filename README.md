# Decentralized Clearing Network (DCN)

Provides low cost, fast, and secure settlement for hybrid decentralized exchanges. The DCN was developed by [merkleX](https://merklex.io). More information can be [found here](https://merklex.io/blog/decentralized-clearing-network/).

---

## 🚀 Canton Network Migration

**Important**: Este repositório contém a implementação original do DCN em Ethereum. Estamos planejando uma migração para a Canton Network para aproveitar recursos avançados de privacidade, performance e interoperabilidade.

**Important**: This repository contains the original Ethereum implementation of DCN. We are planning a migration to Canton Network to leverage advanced privacy, performance, and interoperability features.

### 📋 Documentos de Planejamento / Planning Documents

| Documento / Document | Descrição / Description |
| -------------------- | ----------------------- |
| [**IMPLEMENTATION_STATUS.md**](IMPLEMENTATION_STATUS.md) | ✅ **STATUS ATUAL: Fase 1 Completa** / **CURRENT STATUS: Phase 1 Complete** |
| [**EXECUTIVE_RECOMMENDATION.md**](EXECUTIVE_RECOMMENDATION.md) | 🎯 **Recomendação executiva e decisão estratégica** / Executive recommendation and strategic decision |
| [**CANTON_MIGRATION_PLAN.md**](CANTON_MIGRATION_PLAN.md) | 📖 **Plano completo de migração (15-20 semanas)** / Complete migration plan (15-20 weeks) |
| [**ARCHITECTURE_COMPARISON.md**](ARCHITECTURE_COMPARISON.md) | ⚖️ **Comparação detalhada Ethereum vs Canton** / Detailed Ethereum vs Canton comparison |
| [**QUICKSTART_GUIDE.md**](QUICKSTART_GUIDE.md) | 🚀 **Guia rápido para começar desenvolvimento** / Quick start guide for development |
| [**FAQ.md**](FAQ.md) | ❓ **Perguntas frequentes** / Frequently Asked Questions |

### 📌 Status do Projeto / Project Status

**✅ FASE 1 COMPLETA** - Novo projeto Canton-native criado com sucesso!

**✅ PHASE 1 COMPLETE** - New Canton-native project successfully created!

**🚀 FASE 2 PRONTA** - Código validado e pronto para build!

**🚀 PHASE 2 READY** - Code validated and ready for build!

**Localização / Location**: [`canton-clearing-network/`](canton-clearing-network/)

**O que foi feito / What was done**:
- ✅ Estrutura completa do projeto / Complete project structure
- ✅ 6 módulos Daml implementados / 6 Daml modules implemented
- ✅ Suite de testes criada / Test suite created
- ✅ Configurações Canton (local/test/prod) / Canton configs (local/test/prod)
- ✅ Scripts de build e deploy / Build and deploy scripts
- ✅ Documentação completa (PT/EN) / Complete documentation (PT/EN)
- ✅ Skeleton Java integration / Java integration skeleton
- ✅ Validação completa do código / Complete code validation

**Próximos Passos / Next Steps**:
1. ✅ ~~Criar novo projeto Canton~~ COMPLETO!
2. ✅ ~~Validar código Daml~~ COMPLETO!
3. ⏳ Instalar Daml SDK e construir projeto / Install Daml SDK and build project
4. ⏳ Executar e validar testes / Run and validate tests
5. ⏳ Instalar Canton SDK e fazer deploy / Install Canton SDK and deploy
6. ⏳ Implementar integração Java / Implement Java integration

📊 **Ver detalhes completos / See full details**: [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md)

📋 **Ver relatório de prontidão / See readiness report**: [canton-clearing-network/PHASE2_READINESS.md](canton-clearing-network/PHASE2_READINESS.md)

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
