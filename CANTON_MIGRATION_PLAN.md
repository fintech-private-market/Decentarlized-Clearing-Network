# Plano de Migração para Canton Network / Canton Network Migration Plan

## Sumário Executivo / Executive Summary

### Português
Este documento apresenta um plano abrangente para adaptar o Decentralized Clearing Network (DCN) da blockchain Ethereum para a Canton Network. A migração envolve a reconstrução da arquitetura do sistema de smart contracts Solidity para templates Daml, aproveitando as capacidades de privacidade e sincronização da Canton Network.

### English
This document presents a comprehensive plan to adapt the Decentralized Clearing Network (DCN) from Ethereum blockchain to Canton Network. The migration involves rebuilding the system architecture from Solidity smart contracts to Daml templates, leveraging Canton Network's privacy and synchronization capabilities.

---

## 1. Análise da Arquitetura Atual / Current Architecture Analysis

### Ethereum-Based DCN Architecture

**Core Components:**
- **DCN Smart Contract**: Main contract handling user accounts, exchanges, assets, settlements
- **WethDeposit Contract**: Handles WETH deposits and withdrawals
- **ERC20 Integration**: Standard token interface support
- **Java Integration Layer**: web3j-based interaction with Ethereum

**Key Features:**
- User account management (up to 2^64 users)
- Exchange registration and management (up to 2^32 exchanges)
- Asset registration (up to 2^32 assets)
- Settlement processing for decentralized exchanges
- Balance tracking and session management
- Security features (feature locks, recovery mechanisms)
- Cryptographic signature verification

**Current Technology Stack:**
- Solidity 0.5.7 (Smart Contracts)
- Java 8 (Integration Layer)
- web3j 4.2.0 (Ethereum Java library)
- Ethereum blockchain (Public/Private networks)
- Ganache (Development environment)

---

## 2. Canton Network Overview

### What is Canton Network?

Canton Network is an enterprise-grade decentralized network built on the Canton protocol, which provides:

**Key Capabilities:**
- **Privacy-Preserving**: Sub-transaction privacy with selective disclosure
- **Interoperability**: Cross-domain synchronization and atomic transfers
- **Scalability**: Horizontal scaling across multiple domains
- **Composability**: Smart contracts that can reference each other across domains
- **Deterministic Finality**: Strong consistency guarantees

**Technology Stack:**
- **Daml**: Domain-specific language for distributed applications
- **Canton Protocol**: Synchronization protocol for privacy and interoperability
- **Ledger API**: gRPC-based API for application integration
- **Participants**: Entities that host Daml applications
- **Domains**: Synchronization domains for transaction ordering

### Why Canton Network for DCN?

1. **Enhanced Privacy**: Settlements between exchanges can remain private
2. **Multi-Party Workflows**: Built-in support for complex multi-party transactions
3. **Interoperability**: Can interact with multiple financial systems
4. **Regulatory Compliance**: Better audit trails and selective disclosure
5. **Performance**: Better scalability for high-frequency settlement operations
6. **Deterministic Execution**: Strong consistency and predictable behavior

---

## 3. Arquitetura Proposta / Proposed Architecture

### Canton Network DCN Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Canton Network DCN                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐           │
│  │   User     │  │ Exchange   │  │   Asset    │           │
│  │ Participant│  │Participant │  │ Provider   │           │
│  └────────────┘  └────────────┘  └────────────┘           │
│         │                │               │                  │
│         └────────────────┴───────────────┘                  │
│                          │                                  │
│                          ▼                                  │
│              ┌─────────────────────┐                        │
│              │   Canton Domain     │                        │
│              │  (Synchronization)  │                        │
│              └─────────────────────┘                        │
│                          │                                  │
│         ┌────────────────┼────────────────┐                │
│         ▼                ▼                ▼                 │
│  ┌───────────┐    ┌───────────┐   ┌───────────┐          │
│  │   Daml    │    │   Daml    │   │   Daml    │          │
│  │ Templates │    │ Choices   │   │ Contracts │          │
│  └───────────┘    └───────────┘   └───────────┘          │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │         Canton Ledger API (gRPC)                    │  │
│  └─────────────────────────────────────────────────────┘  │
│                          │                                  │
│                          ▼                                  │
│  ┌─────────────────────────────────────────────────────┐  │
│  │    Java/Scala Integration Layer                     │  │
│  │    (Daml Java/Scala Bindings)                       │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Core Daml Templates (To Replace Solidity Contracts)

1. **UserAccount Template**
   - Replaces: User struct in DCN.sol
   - Fields: userId, tradeAddress, balances, limits
   - Signatories: User, DCN Operator
   - Observers: Exchanges (with permissions)

2. **Exchange Template**
   - Replaces: Exchange struct in DCN.sol
   - Fields: exchangeId, name, owner, balances, locked status
   - Signatories: Exchange owner, DCN Operator
   - Observers: Users (with active sessions)

3. **Asset Template**
   - Replaces: Asset struct in DCN.sol
   - Fields: assetId, symbol, unitScale, contractAddress
   - Signatories: DCN Operator, Asset Provider
   - Observers: All participants

4. **Session Template**
   - Replaces: Session management in DCN.sol
   - Fields: userId, exchangeId, balances, nonce, expiry
   - Signatories: User, Exchange
   - Observers: DCN Operator

5. **Settlement Template**
   - Replaces: Settlement processing in DCN.sol
   - Fields: settlementGroup, participants, amounts, signatures
   - Signatories: Exchange, DCN Operator
   - Observers: Participating users

6. **DCNOperator Template**
   - Replaces: Creator/admin functions in DCN.sol
   - Fields: operator address, security settings, feature locks
   - Signatories: DCN Operator
   - Choices: Lock features, manage exchanges, manage assets

---

## 4. Mapeamento de Funcionalidades / Feature Mapping

### User Management
| Ethereum DCN | Canton DCN | Implementation |
|--------------|------------|----------------|
| `create_user()` | UserAccount.Create choice | Daml choice on DCN Operator |
| `user_update_trade_address()` | UserAccount.UpdateTradeAddress | Daml choice on UserAccount |
| `get_user()` | Query UserAccount template | Ledger API query |
| `get_balance()` | Query UserAccount.balances | Ledger API query |

### Asset Management
| Ethereum DCN | Canton DCN | Implementation |
|--------------|------------|----------------|
| `asset_create()` | Asset.Create choice | Daml choice on DCN Operator |
| `get_asset()` | Query Asset template | Ledger API query |
| `get_asset_count()` | Count Asset contracts | Ledger API query with filter |

### Exchange Management
| Ethereum DCN | Canton DCN | Implementation |
|--------------|------------|----------------|
| `exchange_create()` | Exchange.Create choice | Daml choice on DCN Operator |
| `exchange_update_owner()` | Exchange.UpdateOwner | Daml choice on Exchange |
| `set_exchange_locked()` | Exchange.SetLocked | Daml choice on Exchange |
| `get_exchange_balance()` | Query Exchange.balances | Ledger API query |

### Settlement Processing
| Ethereum DCN | Canton DCN | Implementation |
|--------------|------------|----------------|
| `apply_settlements()` | Settlement.Apply choice | Multi-party Daml workflow |
| Merkle tree verification | Daml assertions | Native Daml validation |
| Signature verification | Canton signatures | Canton cryptographic verification |

### Deposit/Withdrawal
| Ethereum DCN | Canton DCN | Implementation |
|--------------|------------|----------------|
| `deposit_to_user()` | UserAccount.Deposit | Daml choice with external asset integration |
| `withdraw_from_user()` | UserAccount.Withdraw | Daml choice with external asset integration |
| `deposit_to_exchange()` | Session.Deposit | Daml choice on Session |
| `withdraw_from_exchange()` | Session.Withdraw | Daml choice on Session |

### Security Features
| Ethereum DCN | Canton DCN | Implementation |
|--------------|------------|----------------|
| `security_lock()` | DCNOperator.LockFeatures | Daml choice with immediate effect |
| Feature flag checks | Template preconditions | Daml ensure clauses |
| Recovery mechanisms | Multi-sig workflows | Canton multi-party authorization |

---

## 5. Plano de Implementação / Implementation Plan

### Phase 1: Setup & Preparation (2-3 weeks)

**Deliverables:**
- [ ] Canton SDK installation and configuration
- [ ] Project structure setup (Daml + Java/Scala)
- [ ] Development environment (Canton local deployment)
- [ ] CI/CD pipeline configuration
- [ ] Documentation framework

**Tasks:**
1. Install Canton SDK and Daml SDK
2. Create new project structure:
   ```
   dcn-canton/
   ├── daml/
   │   ├── src/
   │   │   ├── User.daml
   │   │   ├── Exchange.daml
   │   │   ├── Asset.daml
   │   │   ├── Settlement.daml
   │   │   ├── Session.daml
   │   │   └── DCNOperator.daml
   │   └── tests/
   ├── java-bindings/
   │   └── src/main/java/
   ├── canton-config/
   │   ├── participant1.conf
   │   ├── participant2.conf
   │   └── domain.conf
   └── build.sbt (or build.gradle)
   ```
3. Set up Canton local network with multiple participants
4. Configure build system (SBT for Scala or Gradle for Java)

### Phase 2: Core Daml Templates (3-4 weeks)

**Deliverables:**
- [ ] UserAccount template with all choices
- [ ] Exchange template with management choices
- [ ] Asset template with registration
- [ ] Session template for exchange interactions
- [ ] Basic unit tests (Daml scenarios)

**Tasks:**
1. Implement UserAccount.daml:
   ```daml
   template UserAccount
     with
       userId: Int
       operator: Party
       userParty: Party
       tradeAddress: Text
       balances: Map AssetId Int
       limits: Map AssetId Limit
     where
       signatory operator, userParty
       
       choice Deposit : ContractId UserAccount
         with
           assetId: AssetId
           amount: Int
         controller userParty
         do
           -- Implementation
       
       choice Withdraw : ContractId UserAccount
         with
           assetId: AssetId
           amount: Int
         controller userParty
         do
           -- Implementation
   ```

2. Implement Exchange.daml
3. Implement Asset.daml
4. Implement Session.daml
5. Create Daml test scenarios for each template

### Phase 3: Settlement Logic (3-4 weeks)

**Deliverables:**
- [ ] Settlement template with multi-party workflow
- [ ] Settlement validation logic
- [ ] Netting and balance updates
- [ ] Integration tests

**Tasks:**
1. Implement Settlement.daml:
   ```daml
   template Settlement
     with
       settlementId: Text
       operator: Party
       exchange: Party
       groups: [SettlementGroup]
       status: SettlementStatus
     where
       signatory operator, exchange
       observer [user | group <- groups, user <- group.users]
       
       choice ApplySettlement : [ContractId UserAccount]
         controller exchange
         do
           -- Validation and application logic
   ```

2. Implement settlement group processing
3. Implement balance netting logic
4. Add validation for settlement constraints
5. Create comprehensive test scenarios

### Phase 4: Java/Scala Integration Layer (3-4 weeks)

**Deliverables:**
- [ ] Canton Ledger API client wrapper
- [ ] Java bindings for Daml templates
- [ ] Helper classes (hashing, signatures)
- [ ] Integration with existing DCN Java code
- [ ] Migration utilities

**Tasks:**
1. Generate Java bindings from Daml:
   ```bash
   daml codegen java
   ```

2. Create Canton client wrapper:
   ```java
   public class CantonDCNClient {
       private final DamlLedgerClient ledgerClient;
       
       public CompletableFuture<UserAccount.ContractId> createUser(
           String tradeAddress) {
           // Implementation using Ledger API
       }
       
       public CompletableFuture<List<UserAccount>> getUserAccounts() {
           // Query implementation
       }
   }
   ```

3. Port existing helper classes:
   - DCNHasher.java → Canton-compatible hashing
   - SignatureHelper.java → Canton signature verification
   - Settlements.java → Canton settlement processing

4. Create compatibility layer for existing interfaces

### Phase 5: Testing & Validation (2-3 weeks)

**Deliverables:**
- [ ] Complete test suite for Daml templates
- [ ] Integration tests with Canton
- [ ] Performance benchmarks
- [ ] Migration test scenarios
- [ ] Test documentation

**Tasks:**
1. Port existing Java tests to Canton environment
2. Create Daml scenario tests for all workflows
3. Integration tests with multiple participants
4. Load testing and performance optimization
5. Security testing (access control, privacy)

### Phase 6: Documentation & Deployment (2-3 weeks)

**Deliverables:**
- [ ] Complete API documentation
- [ ] Deployment guides
- [ ] Migration guide from Ethereum version
- [ ] Developer tutorials
- [ ] Production deployment configuration

**Tasks:**
1. Write comprehensive documentation (Portuguese & English)
2. Create deployment playbooks for Canton Network
3. Prepare production configuration files
4. Create migration guide with step-by-step instructions
5. Set up monitoring and logging

---

## 6. Desafios e Considerações / Challenges & Considerations

### Technical Challenges

1. **State Migration**
   - Challenge: Migrating existing Ethereum state to Canton
   - Solution: Create migration scripts to export Ethereum state and import into Canton

2. **Cryptographic Compatibility**
   - Challenge: Different signature schemes (ECDSA vs Canton)
   - Solution: Maintain compatibility layer or migrate signatures during transition

3. **External Asset Integration**
   - Challenge: Integrating with ERC20 tokens and external blockchains
   - Solution: Use Canton's interoperability features or create bridge contracts

4. **Performance Tuning**
   - Challenge: Ensuring Canton performance meets DCN requirements
   - Solution: Extensive benchmarking and optimization of Daml code

### Operational Considerations

1. **Participant Onboarding**
   - Exchanges need to set up Canton participants
   - Provide tooling and documentation for easy onboarding

2. **Network Governance**
   - Define governance model for Canton Network DCN
   - Establish policies for participant admission and dispute resolution

3. **Privacy Configuration**
   - Design privacy rules for different types of data
   - Balance transparency requirements with privacy needs

4. **Backup and Recovery**
   - Canton participant backup strategies
   - Disaster recovery procedures

---

## 7. Alternativa: Novo Projeto vs. Adaptação / Alternative: New Project vs. Adaptation

### Option A: Adapt Existing Project

**Pros:**
- Maintain project history and branding
- Gradual migration possible (Ethereum + Canton coexistence)
- Leverage existing test suite

**Cons:**
- More complex codebase with multiple blockchain backends
- Potential confusion between Ethereum and Canton versions
- Harder to maintain clean architecture

**Recommendation:** Suitable for gradual migration with backward compatibility.

### Option B: Create New Canton-Native Project ✅ RECOMMENDED

**Pros:**
- Clean architecture designed for Canton from ground up
- No legacy Ethereum code to maintain
- Clearer separation of concerns
- Easier to optimize for Canton features
- Better documentation and onboarding

**Cons:**
- Need to establish new project identity
- Cannot easily reuse Ethereum state
- Requires complete reimplementation

**Recommendation:** **STRONGLY RECOMMENDED** for the following reasons:
1. Canton Network architecture is fundamentally different from Ethereum
2. Daml templates vs. Solidity contracts require different design patterns
3. Clean slate allows better use of Canton's privacy features
4. Easier to maintain and evolve long-term
5. Can create explicit migration tools as separate utilities

### Recommended Approach: New Canton-Native Project

Create a new repository: `dcn-canton` or `canton-clearing-network`

**Structure:**
```
canton-clearing-network/
├── README.md (Portuguese/English)
├── ARCHITECTURE.md
├── daml/
│   ├── src/
│   ├── tests/
│   └── daml.yaml
├── java-integration/
│   ├── src/main/java/io/merklex/canton/dcn/
│   └── build.gradle
├── scala-integration/ (optional)
│   ├── src/main/scala/io/merklex/canton/dcn/
│   └── build.sbt
├── canton-config/
│   ├── local-dev/
│   ├── testing/
│   └── production/
├── migration-tools/
│   └── ethereum-to-canton/
├── docs/
│   ├── pt-br/
│   └── en/
└── docker/
    ├── Dockerfile.participant
    └── docker-compose.yml
```

---

## 8. Cronograma Estimado / Estimated Timeline

### Total Duration: 15-20 weeks (3.5-5 months)

| Phase | Duration | Dependencies |
|-------|----------|-------------|
| Phase 1: Setup | 2-3 weeks | None |
| Phase 2: Core Templates | 3-4 weeks | Phase 1 |
| Phase 3: Settlement Logic | 3-4 weeks | Phase 2 |
| Phase 4: Integration Layer | 3-4 weeks | Phase 2, 3 |
| Phase 5: Testing | 2-3 weeks | Phase 2, 3, 4 |
| Phase 6: Documentation | 2-3 weeks | All phases |

**Parallel Work Opportunities:**
- Documentation can start early (Phase 1) and continue throughout
- Java integration can begin once core templates are defined (Phase 2)
- Testing should be ongoing from Phase 2 onwards

---

## 9. Recursos Necessários / Required Resources

### Human Resources
- **Daml Developer** (1-2): Core template development
- **Backend Developer (Java/Scala)** (1): Integration layer
- **DevOps Engineer** (1): Canton deployment and infrastructure
- **Documentation Writer** (0.5): Technical documentation
- **QA Engineer** (1): Testing and validation

### Infrastructure
- **Development Environment**: Canton local network, Daml IDE
- **Testing Environment**: Multi-participant Canton network
- **CI/CD**: GitHub Actions or GitLab CI for automated testing
- **Production**: Canton Network participant nodes

### Learning Resources
- Canton Documentation: https://docs.canton.io
- Daml Documentation: https://docs.daml.com
- Canton Network: https://www.canton.network
- Training: Daml fundamentals course

---

## 10. Próximos Passos / Next Steps

### Immediate Actions

1. **Decision Point**: Confirm approach (New project vs. Adaptation)
   - **Recommended**: New Canton-native project

2. **Team Assembly**: Identify team members with required skills
   - Daml development experience or willingness to learn
   - Canton Network understanding
   - Existing DCN knowledge

3. **Environment Setup**: Set up development environment
   - Install Canton SDK
   - Install Daml SDK
   - Configure local Canton network

4. **Proof of Concept**: Build minimal viable implementation
   - UserAccount template
   - Simple deposit/withdrawal
   - Basic integration with Java

5. **Stakeholder Alignment**: Present plan to stakeholders
   - Get approval for timeline and resources
   - Confirm priorities and requirements

### Success Metrics

- **Functionality**: All DCN features working on Canton
- **Performance**: Settlement processing time < Ethereum version
- **Privacy**: Proper privacy controls implemented
- **Adoption**: Exchange onboarding documentation complete
- **Testing**: >90% test coverage for Daml templates

---

## 11. Conclusão / Conclusion

### Português
A migração do DCN para a Canton Network representa uma evolução significativa em direção a uma infraestrutura de liquidação mais privada, escalável e interoperável. Embora a migração requeira esforço substancial, os benefícios de privacidade, performance e interoperabilidade da Canton Network justificam o investimento. Recomendamos fortemente a criação de um novo projeto Canton-nativo para obter os melhores resultados.

### English
The migration of DCN to Canton Network represents a significant evolution towards a more private, scalable, and interoperable clearing infrastructure. While the migration requires substantial effort, the privacy, performance, and interoperability benefits of Canton Network justify the investment. We strongly recommend creating a new Canton-native project for the best results.

---

## 12. Referências / References

- [Canton Network Official Site](https://www.canton.network)
- [Canton Documentation](https://docs.canton.io)
- [Daml Documentation](https://docs.daml.com)
- [Digital Asset (Daml Creator)](https://www.digitalasset.com)
- [Current DCN on Ethereum](https://github.com/fintech-private-market/Decentarlized-Clearing-Network)
- [MerkleX DCN Blog Post](https://merklex.io/blog/decentralized-clearing-network/)

---

**Document Version**: 1.0  
**Last Updated**: 2026-02-15  
**Authors**: DCN Development Team  
**Status**: Proposed
