# Canton DCN Integration Guide

## Overview

This guide provides comprehensive instructions for integrating applications with the Canton-based Decentralized Clearing Network (DCN). It covers setup, configuration, and usage of the Java client library.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Configuration](#configuration)
5. [API Reference](#api-reference)
6. [Examples](#examples)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)
9. [Migration from Ethereum DCN](#migration)

## Prerequisites

### Software Requirements

- **Java**: JDK 11 or higher
- **Maven**: 3.6 or higher (or Gradle)
- **Canton SDK**: 2.9.0 or higher
- **Daml SDK**: 2.9.0 or higher

### Knowledge Requirements

- Basic understanding of distributed ledger technology
- Familiarity with Java programming
- Understanding of clearing and settlement processes

## Installation

### Method 1: Maven

Add the following dependency to your `pom.xml`:

```xml
<dependency>
    <groupId>io.merklex.canton</groupId>
    <artifactId>dcn-java-integration</artifactId>
    <version>0.1.0</version>
</dependency>
```

### Method 2: Build from Source

```bash
cd canton-clearing-network/java-integration
mvn clean install
```

This will build the library and install it to your local Maven repository.

## Quick Start

### 1. Import Dependencies

```java
import io.merklex.canton.dcn.DCNClient;
import io.merklex.canton.dcn.DCNClient.Transfer;
import io.merklex.canton.dcn.DCNClient.DCNException;

import java.math.BigDecimal;
import java.util.Arrays;
```

### 2. Create and Connect Client

```java
DCNClient client = new DCNClient(
    "localhost",        // Canton ledger host
    4002,              // Canton ledger port
    "dcn-ledger",      // Ledger ID
    "DCNOperator"      // Operator party name
);

// Connect to Canton
boolean connected = client.connect();
if (!connected) {
    throw new RuntimeException("Failed to connect to Canton");
}
```

### 3. Register Entities

```java
// Register a user
String userContractId = client.registerUser(
    1L,                    // User ID
    "User1",              // Party name
    "First user account"  // Metadata
);

// Register an exchange
String exchangeContractId = client.registerExchange(
    1,                        // Exchange ID
    "Exchange1",              // Party name
    "Primary Exchange",       // Name
    "Main trading exchange"   // Metadata
);

// Register an asset
String assetContractId = client.registerAsset(
    1,                   // Asset ID
    "USDC",             // Symbol
    "USD Coin",         // Name
    6,                  // Decimals
    "AssetProvider"     // Provider party
);
```

### 4. Create Settlement

```java
// Define participants
List<String> participants = Arrays.asList("User1", "User2");

// Create transfer
Transfer transfer = new Transfer(
    1L,                           // From user ID
    2L,                           // To user ID
    1,                            // Asset ID
    new BigDecimal("100.50"),     // Amount
    1L,                           // Nonce (replay protection)
    new BigDecimal("500.00")      // Max amount
);

// Create settlement
String settlementContractId = client.createSettlement(
    1,                    // Settlement ID
    1,                    // Exchange ID
    1,                    // Session ID
    participants,         // Participants
    Arrays.asList(transfer)  // Transfers
);
```

### 5. Close Connection

```java
// The client implements AutoCloseable
client.close();

// Or use try-with-resources:
try (DCNClient client = new DCNClient(...)) {
    // Your code here
}
```

## Configuration

### Canton Network Configuration

The client connects to Canton via the Ledger API. Ensure Canton is running and accessible:

```bash
# Local development
canton -c canton-config/local.conf

# Test environment
canton -c canton-config/test.conf

# Production
canton -c canton-config/prod.conf
```

### Connection Parameters

| Parameter | Description | Default | Environment Variable |
|-----------|-------------|---------|---------------------|
| `ledgerHost` | Canton ledger API host | localhost | `CANTON_LEDGER_HOST` |
| `ledgerPort` | Canton ledger API port | 4002 | `CANTON_LEDGER_PORT` |
| `ledgerId` | Ledger identifier | dcn-ledger | `CANTON_LEDGER_ID` |
| `operatorParty` | Operator party name | DCNOperator | `CANTON_OPERATOR_PARTY` |

### Advanced Configuration

```java
// Configure client with custom settings
DCNClient client = new DCNClient(
    System.getenv("CANTON_LEDGER_HOST"),
    Integer.parseInt(System.getenv("CANTON_LEDGER_PORT")),
    System.getenv("CANTON_LEDGER_ID"),
    System.getenv("CANTON_OPERATOR_PARTY")
);

// The client automatically:
// - Uses 10MB max inbound message size
// - Sets 30 second connection timeout
// - Retries failed operations up to 3 times with exponential backoff
```

## API Reference

### DCNClient

Main client class for interacting with Canton DCN.

#### Constructor

```java
public DCNClient(String ledgerHost, int ledgerPort, 
                 String ledgerId, String operatorParty)
```

Creates a new DCN client instance.

#### Methods

##### connect()

```java
public boolean connect() throws DCNException
```

Establishes connection to Canton network.

**Returns:** `true` if connection successful

**Throws:** `DCNException` if connection fails

##### isConnected()

```java
public boolean isConnected()
```

Checks if client is currently connected.

**Returns:** `true` if connected

##### registerUser()

```java
public String registerUser(long userId, String ownerParty, 
                          String metadata) throws DCNException
```

Registers a new user account.

**Parameters:**
- `userId`: Unique user identifier (up to 2^64)
- `ownerParty`: Party name owning the account
- `metadata`: Additional user metadata

**Returns:** Contract ID of created UserAccount

**Throws:** `DCNException` if registration fails

##### registerExchange()

```java
public String registerExchange(int exchangeId, String exchangeParty,
                              String name, String metadata) throws DCNException
```

Registers a new exchange.

**Parameters:**
- `exchangeId`: Unique exchange identifier (up to 2^32)
- `exchangeParty`: Party name representing the exchange
- `name`: Exchange name
- `metadata`: Additional exchange metadata

**Returns:** Contract ID of created RegisteredExchange

**Throws:** `DCNException` if registration fails

##### registerAsset()

```java
public String registerAsset(int assetId, String symbol, String name,
                           int decimals, String providerParty) throws DCNException
```

Registers a new asset.

**Parameters:**
- `assetId`: Unique asset identifier (up to 2^32)
- `symbol`: Asset symbol (e.g., "USDC")
- `name`: Asset full name (e.g., "USD Coin")
- `decimals`: Number of decimal places
- `providerParty`: Party name of asset provider

**Returns:** Contract ID of created RegisteredAsset

**Throws:** `DCNException` if registration fails

##### createSettlement()

```java
public String createSettlement(int settlementId, int exchangeId, 
                              int sessionId, List<String> participants,
                              List<Transfer> transfers) throws DCNException
```

Creates a new settlement request.

**Parameters:**
- `settlementId`: Unique settlement identifier
- `exchangeId`: Exchange ID
- `sessionId`: Session ID
- `participants`: List of participant party names
- `transfers`: List of transfers to execute

**Returns:** Contract ID of created SettlementRequest

**Throws:** `DCNException` if creation fails

##### close()

```java
public void close()
```

Closes connection to Canton network and releases resources.

### Transfer Class

Represents a transfer in a settlement.

```java
public static class Transfer {
    public final long fromUserId;
    public final long toUserId;
    public final int assetId;
    public final BigDecimal amount;
    public final long nonce;
    public final BigDecimal maxAmount;
    
    public Transfer(long fromUserId, long toUserId, int assetId,
                   BigDecimal amount, long nonce, BigDecimal maxAmount)
}
```

**Fields:**
- `fromUserId`: Source user ID
- `toUserId`: Destination user ID
- `assetId`: Asset ID to transfer
- `amount`: Transfer amount
- `nonce`: Unique nonce for replay protection
- `maxAmount`: Maximum allowed transfer amount (optional, can be null)

### DCNException Class

Exception thrown for DCN-related errors.

```java
public static class DCNException extends Exception {
    public DCNException(String message)
    public DCNException(String message, Throwable cause)
}
```

## Examples

### Example 1: Simple User Registration

```java
try (DCNClient client = new DCNClient("localhost", 4002, 
                                      "dcn-ledger", "DCNOperator")) {
    client.connect();
    
    for (int i = 1; i <= 10; i++) {
        String contractId = client.registerUser(
            i,
            "User" + i,
            "Batch registered user " + i
        );
        System.out.println("Registered User" + i + ": " + contractId);
    }
}
```

### Example 2: Multi-Transfer Settlement

```java
try (DCNClient client = new DCNClient("localhost", 4002, 
                                      "dcn-ledger", "DCNOperator")) {
    client.connect();
    
    // Create multiple transfers in one settlement
    List<Transfer> transfers = Arrays.asList(
        new Transfer(1L, 2L, 1, new BigDecimal("50"), 1L, null),
        new Transfer(1L, 3L, 1, new BigDecimal("30"), 2L, null),
        new Transfer(2L, 3L, 1, new BigDecimal("20"), 3L, null)
    );
    
    List<String> participants = Arrays.asList("User1", "User2", "User3");
    
    String settlement = client.createSettlement(
        1, 1, 1, participants, transfers
    );
    
    System.out.println("Settlement created: " + settlement);
}
```

### Example 3: Error Handling

```java
try (DCNClient client = new DCNClient("localhost", 4002, 
                                      "dcn-ledger", "DCNOperator")) {
    
    if (!client.connect()) {
        System.err.println("Failed to connect");
        return;
    }
    
    try {
        String user = client.registerUser(1L, "User1", "Test user");
        System.out.println("User registered: " + user);
        
    } catch (DCNException e) {
        System.err.println("Registration failed: " + e.getMessage());
        // Log error, retry, or handle appropriately
    }
    
} catch (Exception e) {
    System.err.println("Unexpected error: " + e.getMessage());
}
```

### Example 4: Health Check

```java
public boolean checkSystemHealth() {
    try (DCNClient client = new DCNClient("localhost", 4002, 
                                          "dcn-ledger", "DCNOperator")) {
        return client.connect();
    } catch (Exception e) {
        logger.error("Health check failed", e);
        return false;
    }
}
```

## Best Practices

### 1. Resource Management

Always use try-with-resources for automatic connection cleanup:

```java
try (DCNClient client = new DCNClient(...)) {
    // Your code
}
```

### 2. Error Handling

Implement comprehensive error handling:

```java
try {
    client.registerUser(...);
} catch (DCNException e) {
    logger.error("Operation failed", e);
    // Implement retry logic or fallback
}
```

### 3. Nonce Management

Use unique, incrementing nonces for replay protection:

```java
AtomicLong nonceCounter = new AtomicLong(1);

Transfer transfer = new Transfer(
    fromUser, toUser, assetId, amount,
    nonceCounter.getAndIncrement(),  // Atomic increment
    maxAmount
);
```

### 4. Connection Pooling

For high-throughput applications, maintain a pool of clients:

```java
// Implement connection pool pattern
public class DCNClientPool {
    private final Queue<DCNClient> pool = new ConcurrentLinkedQueue<>();
    
    public DCNClient acquire() { /* ... */ }
    public void release(DCNClient client) { /* ... */ }
}
```

### 5. Monitoring

Implement logging and metrics:

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

private static final Logger logger = LoggerFactory.getLogger(YourClass.class);

logger.info("Registering user {}", userId);
logger.error("Failed to create settlement", exception);
```

## Troubleshooting

### Connection Issues

**Problem:** Cannot connect to Canton

**Solutions:**
1. Verify Canton is running: `canton --version`
2. Check network connectivity: `nc -zv localhost 4002`
3. Verify ledger ID matches Canton configuration
4. Check firewall settings

### Registration Failures

**Problem:** User/Exchange/Asset registration fails

**Solutions:**
1. Ensure unique IDs (no duplicates)
2. Verify party names are valid
3. Check operator permissions
4. Review Canton logs for errors

### Settlement Errors

**Problem:** Settlement creation fails

**Solutions:**
1. Verify all participants exist
2. Check transfer amounts are positive
3. Ensure unique nonces
4. Validate asset IDs exist
5. Check balance constraints

### Performance Issues

**Problem:** Slow operations

**Solutions:**
1. Use connection pooling
2. Batch operations when possible
3. Optimize network latency
4. Monitor Canton performance
5. Check database performance (PostgreSQL)

## Migration from Ethereum DCN {#migration}

### Overview

The Canton DCN provides a migration tool to move data from Ethereum-based DCN to Canton.

### Using the Migration Tool

```java
import io.merklex.canton.dcn.migration.EthereumToCantonMigration;

// Configure migration
EthereumToCantonMigration migration = new EthereumToCantonMigration(
    "http://localhost:8545",           // Ethereum RPC URL
    "0x1234...",                       // DCN contract address
    cantonClient                        // Canton client
);

// Execute migration
MigrationResult result = migration.executeMigration();

if (result.isSuccess()) {
    System.out.println("Migration completed successfully");
    System.out.println("Users migrated: " + result.getUserContractIds().size());
    System.out.println("Balances migrated: " + result.getBalancesMigrated());
} else {
    System.err.println("Migration failed: " + result.getError());
}
```

### Migration Steps

1. **Export**: Extract all data from Ethereum DCN
2. **Validate**: Verify data integrity
3. **Connect**: Establish Canton connection
4. **Import Users**: Migrate user accounts
5. **Import Exchanges**: Migrate exchanges
6. **Import Assets**: Migrate assets
7. **Migrate Balances**: Transfer balance data
8. **Verify**: Reconcile and verify migration

### Migration Best Practices

1. **Test First**: Run migration on test environment
2. **Backup**: Backup Ethereum data before migration
3. **Verify**: Always verify migration results
4. **Gradual Rollout**: Migrate in phases if needed
5. **Monitor**: Watch for issues during migration

## Support

### Documentation

- [Canton Documentation](https://docs.canton.io)
- [Daml Documentation](https://docs.daml.com)
- [Project README](../README.md)

### Community

- [GitHub Issues](https://github.com/fintech-private-market/Decentarlized-Clearing-Network/issues)
- [Canton Forum](https://discuss.canton.io)

## Version History

- **0.1.0** (2026-02-15): Initial Phase 3 release
  - Full Java client implementation
  - Migration tools framework
  - Comprehensive examples and documentation

---

**Last Updated:** 2026-02-15  
**Version:** 0.1.0  
**Author:** Canton DCN Development Team
