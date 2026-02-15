# Canton DCN Deployment Guide

## Overview

This guide provides step-by-step instructions for deploying the Canton-based Decentralized Clearing Network (DCN) in various environments.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Development Setup](#local-development)
3. [Test Environment Deployment](#test-deployment)
4. [Production Deployment](#production-deployment)
5. [Monitoring and Maintenance](#monitoring)
6. [Security Considerations](#security)
7. [Troubleshooting](#troubleshooting)

## Prerequisites {#prerequisites}

### Software Requirements

- **Operating System**: Linux (Ubuntu 20.04+ recommended) or macOS
- **Canton SDK**: 2.9.0 or higher
- **Daml SDK**: 2.9.0 or higher
- **PostgreSQL**: 13.0 or higher (for test/production)
- **Java**: JDK 11 or higher
- **Docker**: Optional, for containerized deployment

### Hardware Requirements

#### Development
- CPU: 2+ cores
- RAM: 4GB minimum
- Storage: 10GB

#### Test
- CPU: 4+ cores
- RAM: 8GB minimum
- Storage: 50GB

#### Production
- CPU: 8+ cores
- RAM: 16GB minimum
- Storage: 100GB+ (depends on transaction volume)
- Network: High-bandwidth, low-latency connection

## Local Development Setup {#local-development}

### Step 1: Install Dependencies

#### Install Daml SDK

```bash
curl -sSL https://get.daml.com/ | sh
export PATH="$HOME/.daml/bin:$PATH"
daml version
```

#### Install Canton SDK

```bash
# Visit https://www.canton.io/downloads
# Or use coursier:
curl -fL https://github.com/coursier/coursier/releases/latest/download/coursier -o coursier
chmod +x coursier
./coursier install canton
```

### Step 2: Build Daml Project

```bash
cd canton-clearing-network/daml
daml build
```

This creates: `.daml/dist/canton-clearing-network-0.1.0.dar`

### Step 3: Run Tests

```bash
daml test
```

Expected output:
```
Modules loaded: 7
Test results: 
  testSetup: ok
  testUserOperations: ok
  testSettlement: ok
  testBalanceValidation: ok
  testTransferValidation: ok
  ... (10 total tests)
All tests passed
```

### Step 4: Start Local Canton

```bash
cd canton-clearing-network
./scripts/start-local.sh
```

Or manually:

```bash
canton -c canton-config/local/local.conf
```

### Step 5: Deploy DAR

Once Canton is running:

```bash
cd daml
daml ledger upload-dar \
  --host=localhost \
  --port=4002 \
  .daml/dist/canton-clearing-network-0.1.0.dar
```

### Step 6: Verify Deployment

```bash
# Check Canton is running
curl -v http://localhost:4001/health

# Check Ledger API
grpcurl -plaintext localhost:4002 list
```

### Step 7: Run Java Client Example

```bash
cd java-integration
mvn clean install
mvn exec:java -Dexec.mainClass="io.merklex.canton.dcn.DCNClientExample"
```

## Test Environment Deployment {#test-deployment}

### Step 1: Set Up PostgreSQL

```bash
# Install PostgreSQL
sudo apt-get update
sudo apt-get install postgresql-13 postgresql-client-13

# Create database
sudo -u postgres createdb canton_dcn_test

# Create user
sudo -u postgres psql -c "CREATE USER canton_user WITH PASSWORD 'secure_password';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE canton_dcn_test TO canton_user;"
```

### Step 2: Configure Canton for Test

Edit `canton-config/test/test.conf`:

```hocon
canton {
  participants {
    participant1 {
      storage {
        type = postgres
        config {
          dataSourceClass = "org.postgresql.ds.PGSimpleDataSource"
          properties = {
            serverName = "localhost"
            portNumber = "5432"
            databaseName = "canton_dcn_test"
            user = "canton_user"
            password = "secure_password"
          }
        }
      }
      ledger-api {
        address = "0.0.0.0"
        port = 5001
      }
    }
  }
  
  domains {
    dcn_domain {
      storage {
        type = postgres
        config {
          dataSourceClass = "org.postgresql.ds.PGSimpleDataSource"
          properties = {
            serverName = "localhost"
            portNumber = "5432"
            databaseName = "canton_dcn_test_domain"
            user = "canton_user"
            password = "secure_password"
          }
        }
      }
      public-api {
        address = "0.0.0.0"
        port = 5301
      }
    }
  }
}
```

### Step 3: Start Canton Test Environment

```bash
canton -c canton-config/test/test.conf
```

### Step 4: Deploy and Test

Follow steps 5-7 from local development, using test environment ports (5001, 5002).

## Production Deployment {#production-deployment}

### Step 1: Infrastructure Setup

#### Option A: VM-Based Deployment

```bash
# Provision VMs
# - 2+ VMs for Canton participants
# - 1+ VM for Canton domain
# - 1+ VM for PostgreSQL HA cluster
# - 1+ VM for load balancer

# Install required software on each VM
sudo apt-get update
sudo apt-get install -y openjdk-11-jdk postgresql-client

# Install Canton SDK
# ... (as in development setup)
```

#### Option B: Kubernetes Deployment

```yaml
# Example Kubernetes deployment (simplified)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: canton-participant
spec:
  replicas: 2
  selector:
    matchLabels:
      app: canton-participant
  template:
    metadata:
      labels:
        app: canton-participant
    spec:
      containers:
      - name: canton
        image: digitalasset/canton:2.9.0
        ports:
        - containerPort: 6001
        - containerPort: 6002
        volumeMounts:
        - name: config
          mountPath: /config
        - name: data
          mountPath: /data
      volumes:
      - name: config
        configMap:
          name: canton-config
      - name: data
        persistentVolumeClaim:
          claimName: canton-data
```

### Step 2: Database Setup

#### PostgreSQL High Availability

```bash
# Set up PostgreSQL cluster with:
# - Primary-Standby replication
# - Automatic failover (using Patroni or similar)
# - Connection pooling (using PgBouncer)

# Example connection string:
postgresql://canton_user:password@postgres-ha.internal:5432/canton_dcn_prod?sslmode=require
```

### Step 3: Configure SSL/TLS

Generate certificates:

```bash
# Generate CA certificate
openssl genrsa -out ca-key.pem 4096
openssl req -new -x509 -days 3650 -key ca-key.pem -out ca-cert.pem

# Generate server certificate
openssl genrsa -out server-key.pem 4096
openssl req -new -key server-key.pem -out server.csr
openssl x509 -req -days 730 -in server.csr -CA ca-cert.pem -CAkey ca-key.pem -out server-cert.pem
```

Update `canton-config/prod/prod.conf`:

```hocon
canton {
  participants {
    participant1 {
      ledger-api {
        address = "0.0.0.0"
        port = 6001
        tls {
          cert-chain-file = "/etc/canton/certs/server-cert.pem"
          private-key-file = "/etc/canton/certs/server-key.pem"
          trust-collection-file = "/etc/canton/certs/ca-cert.pem"
        }
      }
    }
  }
}
```

### Step 4: Configure Monitoring

Edit `canton-config/prod/prod.conf`:

```hocon
canton {
  monitoring {
    metrics {
      reporters = [{
        type = prometheus
        address = "0.0.0.0"
        port = 9090
      }]
    }
    
    logging {
      api {
        message-payloads = false  # Disable in production for performance
        max-method-length = 1000
      }
    }
  }
}
```

### Step 5: Deploy Canton Production

```bash
# Start Canton with production config
canton -c canton-config/prod/prod.conf --daemon

# Or with systemd:
sudo systemctl start canton-dcn

# Check status
sudo systemctl status canton-dcn
```

### Step 6: Deploy DAR File

```bash
# Upload to all participants
daml ledger upload-dar \
  --host=participant1.production.internal \
  --port=6002 \
  --tls \
  --cacrt=/path/to/ca-cert.pem \
  .daml/dist/canton-clearing-network-0.1.0.dar
```

### Step 7: Configure Load Balancer

#### Nginx Example

```nginx
upstream canton_participants {
    server participant1.internal:6002;
    server participant2.internal:6002;
}

server {
    listen 443 ssl http2;
    server_name dcn.production.com;
    
    ssl_certificate /etc/ssl/certs/server.crt;
    ssl_certificate_key /etc/ssl/private/server.key;
    
    location / {
        grpc_pass grpcs://canton_participants;
    }
}
```

### Step 8: Verify Production Deployment

```bash
# Health check
curl -k https://dcn.production.com/health

# Check metrics
curl http://localhost:9090/metrics

# Test connection with Java client
java -jar dcn-client.jar \
  --host=dcn.production.com \
  --port=443 \
  --tls \
  health-check
```

## Monitoring and Maintenance {#monitoring}

### Metrics Collection

Canton exposes Prometheus metrics at `/metrics` endpoint.

Key metrics to monitor:

```yaml
# Transaction metrics
canton_sequencer_events_total
canton_participant_transactions_total
canton_participant_transaction_latency_seconds

# Resource metrics
canton_database_connections_active
canton_jvm_memory_bytes_used
canton_jvm_threads_count

# Health metrics
canton_participant_health_status
canton_domain_health_status
```

### Grafana Dashboards

Import the provided Grafana dashboards:

```bash
# Located in canton-clearing-network/monitoring/grafana/
- canton-overview.json
- canton-performance.json
- canton-health.json
```

### Log Management

Configure centralized logging:

```bash
# Using ELK Stack (Elasticsearch, Logstash, Kibana)
# Or using Splunk, Datadog, etc.

# Canton logs location
/var/log/canton/
```

### Backup Strategy

```bash
# Database backup (daily)
pg_dump -h postgres-server -U canton_user canton_dcn_prod > backup-$(date +%Y%m%d).sql

# Configuration backup
tar -czf config-backup-$(date +%Y%m%d).tar.gz canton-config/

# DAR file backup
cp .daml/dist/*.dar /backup/dar-files/
```

### Update Procedure

```bash
# 1. Backup current state
./scripts/backup.sh

# 2. Build new DAR
daml build

# 3. Test in staging
daml ledger upload-dar --host=staging.internal --port=5002 .daml/dist/*.dar

# 4. Deploy to production (rolling update)
for host in participant1 participant2; do
    daml ledger upload-dar --host=$host.production.internal --port=6002 .daml/dist/*.dar
done

# 5. Verify
./scripts/verify-deployment.sh
```

## Security Considerations {#security}

### Network Security

1. **Firewall Rules**
   ```bash
   # Allow only necessary ports
   sudo ufw allow 6001/tcp  # Ledger API (TLS)
   sudo ufw allow 6002/tcp  # Admin API (TLS)
   sudo ufw deny 5432/tcp   # PostgreSQL (internal only)
   ```

2. **VPN/Private Network**
   - Deploy Canton participants in private network
   - Use VPN for administrative access

### Authentication & Authorization

1. **Ledger API Access**
   - Use JWT tokens for authentication
   - Configure in Canton:
   ```hocon
   ledger-api {
     auth-services = [{
       type = jwt-rs-256-crt
       certificate = "/path/to/jwt-public-key.crt"
     }]
   }
   ```

2. **Admin API Access**
   - Restrict to specific IPs
   - Use strong authentication

### Data Encryption

1. **In Transit**
   - Enable TLS for all connections
   - Use TLS 1.3 minimum

2. **At Rest**
   - Enable PostgreSQL encryption
   - Use encrypted storage volumes

### Audit Logging

Enable comprehensive audit logging:

```hocon
canton {
  monitoring {
    logging {
      event-details = true
      api {
        message-payloads = true  # Only in non-production
      }
    }
  }
}
```

### Key Management

1. **Certificate Rotation**
   ```bash
   # Rotate certificates every 90 days
   ./scripts/rotate-certificates.sh
   ```

2. **Secret Management**
   - Use HashiCorp Vault, AWS Secrets Manager, or similar
   - Never commit secrets to version control

## Troubleshooting {#troubleshooting}

### Canton Won't Start

**Check logs:**
```bash
tail -f /var/log/canton/canton.log
```

**Common issues:**
- Database connection failure → Check PostgreSQL status
- Port already in use → Check for other Canton instances
- Configuration error → Validate HOCON syntax

### DAR Upload Fails

**Symptoms:**
```
Error: Failed to upload DAR: Connection refused
```

**Solutions:**
1. Verify Canton is running
2. Check Ledger API port (6002)
3. Verify network connectivity
4. Check TLS configuration

### Performance Issues

**Symptoms:**
- Slow transaction processing
- High latency
- Connection timeouts

**Diagnostics:**
```bash
# Check CPU usage
top

# Check memory
free -h

# Check database performance
psql -c "SELECT * FROM pg_stat_activity;"

# Check Canton metrics
curl http://localhost:9090/metrics | grep latency
```

**Solutions:**
1. Scale participants horizontally
2. Optimize database queries
3. Increase connection pool size
4. Add caching layer

### Database Issues

**Connection Pool Exhausted:**
```hocon
storage {
  config {
    maximumPoolSize = 50  # Increase pool size
  }
}
```

**Slow Queries:**
```sql
-- Find slow queries
SELECT query, calls, total_time, mean_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;
```

## Production Checklist

Before going live, ensure:

- [ ] All components deployed and tested
- [ ] SSL/TLS enabled and verified
- [ ] Monitoring and alerting configured
- [ ] Backup and restore tested
- [ ] Security audit completed
- [ ] Performance testing done
- [ ] Disaster recovery plan documented
- [ ] Runbooks created for common operations
- [ ] Team trained on operations
- [ ] Support contacts established

## Support

### Documentation
- [Canton Documentation](https://docs.canton.io)
- [Integration Guide](INTEGRATION_GUIDE.md)
- [Project README](README.md)

### Emergency Contacts
- On-call Engineer: [contact info]
- Canton Support: support@canton.io
- Database Admin: [contact info]

---

**Last Updated:** 2026-02-15  
**Version:** 0.1.0  
**Author:** Canton DCN Operations Team
