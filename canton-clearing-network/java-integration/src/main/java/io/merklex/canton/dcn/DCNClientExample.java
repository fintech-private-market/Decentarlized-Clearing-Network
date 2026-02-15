package io.merklex.canton.dcn;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

/**
 * Example usage of the DCN Client
 * Demonstrates basic operations for the Canton DCN
 */
public class DCNClientExample {
    
    private static final Logger logger = LoggerFactory.getLogger(DCNClientExample.class);
    
    public static void main(String[] args) {
        // Configuration
        String ledgerHost = "localhost";
        int ledgerPort = 4002;
        String ledgerId = "dcn-ledger";
        String operatorParty = "DCNOperator";
        
        // Create client
        try (DCNClient client = new DCNClient(ledgerHost, ledgerPort, ledgerId, operatorParty)) {
            
            // 1. Connect to Canton
            logger.info("=== Connecting to Canton Network ===");
            boolean connected = client.connect();
            if (!connected) {
                logger.error("Failed to connect to Canton");
                return;
            }
            logger.info("Connected successfully");
            
            // 2. Register users
            logger.info("\n=== Registering Users ===");
            String user1 = client.registerUser(
                1L,
                "User1",
                "First user account"
            );
            logger.info("Registered User 1: {}", user1);
            
            String user2 = client.registerUser(
                2L,
                "User2",
                "Second user account"
            );
            logger.info("Registered User 2: {}", user2);
            
            // 3. Register exchange
            logger.info("\n=== Registering Exchange ===");
            String exchange = client.registerExchange(
                1,
                "Exchange1",
                "Primary Exchange",
                "Main trading exchange"
            );
            logger.info("Registered Exchange 1: {}", exchange);
            
            // 4. Register asset
            logger.info("\n=== Registering Asset ===");
            String asset = client.registerAsset(
                1,
                "USDC",
                "USD Coin",
                6,
                "AssetProvider"
            );
            logger.info("Registered Asset USDC: {}", asset);
            
            // 5. Create settlement
            logger.info("\n=== Creating Settlement ===");
            List<String> participants = Arrays.asList("User1", "User2");
            
            DCNClient.Transfer transfer = new DCNClient.Transfer(
                1L,                           // fromUserId
                2L,                           // toUserId
                1,                            // assetId
                new BigDecimal("100.50"),     // amount
                1L,                           // nonce
                new BigDecimal("500.00")      // maxAmount
            );
            
            String settlement = client.createSettlement(
                1,
                1,
                1,
                participants,
                Arrays.asList(transfer)
            );
            logger.info("Created Settlement 1: {}", settlement);
            
            logger.info("\n=== All operations completed successfully ===");
            
        } catch (DCNClient.DCNException e) {
            logger.error("DCN operation failed", e);
        } catch (Exception e) {
            logger.error("Unexpected error", e);
        }
    }
    
    /**
     * Run a simple health check
     */
    public static boolean healthCheck(String ledgerHost, int ledgerPort, 
                                      String ledgerId, String operatorParty) {
        try (DCNClient client = new DCNClient(ledgerHost, ledgerPort, ledgerId, operatorParty)) {
            return client.connect();
        } catch (Exception e) {
            logger.error("Health check failed", e);
            return false;
        }
    }
    
    /**
     * Batch register users
     */
    public static void batchRegisterUsers(DCNClient client, int count) 
            throws DCNClient.DCNException {
        logger.info("Batch registering {} users", count);
        
        for (int i = 1; i <= count; i++) {
            String contractId = client.registerUser(
                i,
                "User" + i,
                "Batch registered user " + i
            );
            logger.info("Registered user {} with contract ID {}", i, contractId);
        }
        
        logger.info("Batch registration complete");
    }
    
    /**
     * Create a complex settlement with multiple transfers
     */
    public static String createComplexSettlement(DCNClient client, 
                                                 int settlementId,
                                                 int exchangeId,
                                                 int sessionId) 
            throws DCNClient.DCNException {
        
        List<String> participants = Arrays.asList("User1", "User2", "User3");
        
        List<DCNClient.Transfer> transfers = Arrays.asList(
            new DCNClient.Transfer(1L, 2L, 1, new BigDecimal("50.00"), 1L, new BigDecimal("100.00")),
            new DCNClient.Transfer(1L, 3L, 1, new BigDecimal("30.00"), 2L, new BigDecimal("100.00")),
            new DCNClient.Transfer(2L, 3L, 1, new BigDecimal("20.00"), 3L, new BigDecimal("100.00"))
        );
        
        return client.createSettlement(
            settlementId,
            exchangeId,
            sessionId,
            participants,
            transfers
        );
    }
}
