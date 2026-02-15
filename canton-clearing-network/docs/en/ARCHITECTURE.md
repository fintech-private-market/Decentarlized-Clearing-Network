# Canton Clearing Network Architecture

## Overview

The Canton Clearing Network (CCN) is a complete reimplementation of the original Ethereum-based Decentralized Clearing Network (DCN), now built on Canton Network. This migration leverages Canton Network's advanced capabilities for privacy, interoperability, and scalability.

## Core Components

### 1. Daml Templates

#### UserAccount
- Represents user accounts in the network
- Supports up to 2^64 users
- Manages account status (active/inactive)
- Stores user metadata

#### RegisteredExchange
- Represents registered exchanges
- Supports up to 2^32 exchanges
- Manages settlement fees
- Controls exchange status

#### RegisteredAsset
- Represents registered assets
- Supports up to 2^32 assets
- Manages asset information (symbol, name, decimals)
- Tracks asset provider

#### SettlementRequest
- Manages settlement requests
- Supports multi-party transfers
- Implements approval workflow
- Tracks settlement status

#### TradingSession
- Manages trading sessions
- Tracks participants and active assets
- Controls session lifecycle

#### DCNOperatorRole
- Defines operator role and permissions
- Manages network configuration
- Maintains audit logs

## Privacy Model

Canton Network provides sub-transaction level privacy:

1. **Data Privacy**: Only parties involved in a transaction see the details
2. **Selective Disclosure**: Operator can reveal data for audit when needed
3. **End-to-End Encryption**: Secure communication between participants

## Synchronization Model

### Participants
- **DCN Operator**: Manages the network
- **Exchanges**: Entities that facilitate trades
- **Users**: End users who trade assets
- **Asset Providers**: Asset providers

### Domains
- **DCN Domain**: Main synchronization domain for settlement
- Possibility of multiple domains for scalability

## Comparison with Ethereum DCN

| Aspect | Ethereum DCN | Canton DCN |
|--------|-------------|------------|
| Language | Solidity | Daml |
| Privacy | Public | Sub-transaction private |
| Data Model | Mutable storage | Immutable contracts |
| Scalability | Limited | Horizontal |
| Interoperability | Limited to EVM | Multi-domain |
| Costs | Gas fees | Configurable fees |

## Settlement Flow

1. **Session Creation**: Operator creates a trading session
2. **Trade Registration**: Exchanges register trades
3. **Settlement Request**: System creates settlement requests
4. **Multi-Party Approval**: Parties approve settlement
5. **Execution**: Operator executes settlement
6. **Finalization**: Balances are atomically updated

## Security

- **Signatories**: Each template requires appropriate signatories
- **Observers**: Parties that can see but not modify contracts
- **Keys**: Unique identifiers for contracts
- **Permissions**: Role-based permission system

## Integration

### Ledger API
- gRPC API for application integration
- Support for Java, JavaScript, Python

### Java Client
- Java client provided in `java-integration/`
- Abstraction over Canton Ledger API
- Methods for common operations (register user, create settlement, etc.)

## Configuration

### Local (Development)
- In-memory storage
- Multiple local participants
- Simplified configuration

### Test
- PostgreSQL for persistence
- Production-like configuration
- Multiple participants

### Production
- PostgreSQL with HA
- Multiple domains
- Monitoring and metrics
- SSL/TLS enabled

## Next Steps

1. Implement additional business logic
2. Add more test cases
3. Implement complete Java integration
4. Develop migration tools
5. Setup CI/CD
6. API documentation
7. Performance testing
