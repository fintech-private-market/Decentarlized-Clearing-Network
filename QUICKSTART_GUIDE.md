# Guia de Início Rápido - Canton DCN / Quick Start Guide - Canton DCN

## Português

Este guia fornece instruções passo a passo para começar o desenvolvimento do DCN na Canton Network.

## English

This guide provides step-by-step instructions to start developing DCN on Canton Network.

---

## 1. Pré-requisitos / Prerequisites

### Software Required

1. **Java Development Kit (JDK) 11 ou superior**
   ```bash
   # Verificar instalação
   java -version
   # Deve mostrar: java version "11.x.x" ou superior
   ```

2. **Canton SDK**
   ```bash
   # Download do Canton SDK
   # Visit: https://www.canton.io/downloads
   
   # Ou via coursier (macOS/Linux):
   curl -fL https://github.com/coursier/coursier/releases/latest/download/coursier -o coursier
   chmod +x coursier
   ./coursier install canton
   ```

3. **Daml SDK**
   ```bash
   # macOS
   curl -sSL https://get.daml.com/ | sh
   
   # Linux
   wget -qO- https://get.daml.com/ | sh
   
   # Windows
   # Download from: https://github.com/digital-asset/daml/releases
   
   # Verificar instalação
   daml version
   ```

4. **IDE Setup**
   - Visual Studio Code com extensão Daml
   - IntelliJ IDEA (opcional, para Java/Scala)

### Conhecimento Requerido / Required Knowledge

- Básico de programação funcional
- Conceitos de smart contracts
- Java ou Scala (para integração)
- Git

---

## 2. Estrutura do Novo Projeto / New Project Structure

### Criar Estrutura de Diretórios

```bash
# Criar novo projeto
mkdir canton-clearing-network
cd canton-clearing-network

# Estrutura de diretórios
mkdir -p daml/src
mkdir -p daml/tests
mkdir -p java-integration/src/main/java/io/merklex/canton/dcn
mkdir -p canton-config/{local,test,prod}
mkdir -p docs/{pt-br,en}
mkdir -p scripts
mkdir -p migration-tools

# Inicializar Git
git init
```

### Estrutura Completa

```
canton-clearing-network/
├── README.md
├── ARCHITECTURE.md
├── daml/
│   ├── daml.yaml                 # Configuração do projeto Daml
│   ├── src/
│   │   ├── User.daml            # Template de usuário
│   │   ├── Exchange.daml        # Template de exchange
│   │   ├── Asset.daml           # Template de asset
│   │   ├── Settlement.daml      # Template de settlement
│   │   ├── Session.daml         # Template de sessão
│   │   └── DCNOperator.daml     # Template do operador
│   └── tests/
│       ├── UserTests.daml
│       ├── ExchangeTests.daml
│       └── SettlementTests.daml
├── java-integration/
│   ├── build.gradle
│   └── src/main/java/io/merklex/canton/dcn/
│       ├── CantonDCNClient.java
│       ├── DCNHasher.java
│       └── SignatureHelper.java
├── canton-config/
│   ├── local/
│   │   ├── canton.conf
│   │   ├── participant1.conf
│   │   └── domain.conf
│   ├── test/
│   └── prod/
├── docs/
│   ├── pt-br/
│   │   ├── GETTING_STARTED.md
│   │   └── API.md
│   └── en/
│       ├── GETTING_STARTED.md
│       └── API.md
└── scripts/
    ├── start-local-canton.sh
    ├── deploy-daml.sh
    └── run-tests.sh
```

---

## 3. Passo 1: Inicializar Projeto Daml / Step 1: Initialize Daml Project

```bash
cd daml

# Criar daml.yaml
cat > daml.yaml << 'EOF'
sdk-version: 2.9.0
name: canton-dcn
version: 1.0.0
source: src
init-script: InitializeOperator.daml
dependencies:
  - daml-prim
  - daml-stdlib
  - daml-script
build-options:
  - --target=1.15
EOF
```

---

## 4. Passo 2: Criar Template Básico de Usuário / Step 2: Create Basic User Template

Criar arquivo `daml/src/User.daml`:

```daml
module User where

import DA.Map (Map)
import qualified DA.Map as M

-- Tipo para identificar assets
type AssetId = Int

-- Tipo para representar balances
type Balance = Int

-- Template principal do usuário
template UserAccount
  with
    userId: Int
    operator: Party         -- Operador do DCN
    userParty: Party       -- Party do usuário
    tradeAddress: Text     -- Endereço para trading
    balances: Map AssetId Balance
  where
    signatory operator, userParty
    
    -- Observadores podem incluir exchanges autorizados
    observer []
    
    -- Garantir que balances não sejam negativos
    ensure all (>= 0) (M.values balances)
    
    -- Choice para depositar fundos
    choice Deposit : ContractId UserAccount
      with
        assetId: AssetId
        amount: Balance
      controller userParty
      do
        let currentBalance = M.findWithDefault 0 assetId balances
        let newBalance = currentBalance + amount
        assertMsg "Amount must be positive" (amount > 0)
        create this with 
          balances = M.insert assetId newBalance balances
    
    -- Choice para retirar fundos
    choice Withdraw : ContractId UserAccount
      with
        assetId: AssetId
        amount: Balance
      controller userParty
      do
        let currentBalance = M.findWithDefault 0 assetId balances
        assertMsg "Insufficient balance" (currentBalance >= amount)
        assertMsg "Amount must be positive" (amount > 0)
        create this with 
          balances = M.insert assetId (currentBalance - amount) balances
    
    -- Choice para atualizar endereço de trading
    choice UpdateTradeAddress : ContractId UserAccount
      with
        newTradeAddress: Text
      controller userParty
      do
        create this with tradeAddress = newTradeAddress
    
    -- Choice para obter balance de um asset específico
    nonconsuming choice GetBalance : Balance
      with
        assetId: AssetId
      controller userParty
      do
        return $ M.findWithDefault 0 assetId balances

-- Template para o operador criar novos usuários
template DCNOperator
  with
    operator: Party
  where
    signatory operator
    
    -- Choice para criar novo usuário
    choice CreateUser : ContractId UserAccount
      with
        userId: Int
        userParty: Party
        tradeAddress: Text
      controller operator
      do
        create UserAccount with
          userId
          operator
          userParty
          tradeAddress
          balances = M.empty
```

---

## 5. Passo 3: Criar Script de Teste / Step 3: Create Test Script

Criar arquivo `daml/tests/UserTests.daml`:

```daml
module UserTests where

import Daml.Script
import User
import DA.Map qualified as M

-- Test: Criar usuário e fazer depósito
testUserCreationAndDeposit : Script ()
testUserCreationAndDeposit = do
  -- Alocar parties
  operator <- allocateParty "DCNOperator"
  alice <- allocateParty "Alice"
  
  -- Criar operador
  operatorCid <- submit operator do
    createCmd DCNOperator with operator
  
  -- Criar usuário Alice
  aliceAccountCid <- submit operator do
    exerciseCmd operatorCid CreateUser with
      userId = 1
      userParty = alice
      tradeAddress = "0xAlice123"
  
  -- Alice deposita 1000 unidades do asset 1
  aliceAccountCid2 <- submit alice do
    exerciseCmd aliceAccountCid Deposit with
      assetId = 1
      amount = 1000
  
  -- Verificar balance
  balance <- submit alice do
    exerciseCmd aliceAccountCid2 GetBalance with assetId = 1
  
  assert (balance == 1000)
  
  return ()

-- Test: Withdraw com balance insuficiente deve falhar
testInsufficientBalance : Script ()
testInsufficientBalance = do
  operator <- allocateParty "DCNOperator"
  bob <- allocateParty "Bob"
  
  -- Criar operador e usuário
  operatorCid <- submit operator do
    createCmd DCNOperator with operator
  
  bobAccountCid <- submit operator do
    exerciseCmd operatorCid CreateUser with
      userId = 2
      userParty = bob
      tradeAddress = "0xBob456"
  
  -- Depositar 100
  bobAccountCid2 <- submit bob do
    exerciseCmd bobAccountCid Deposit with
      assetId = 1
      amount = 100
  
  -- Tentar retirar 200 (deve falhar)
  submitMustFail bob do
    exerciseCmd bobAccountCid2 Withdraw with
      assetId = 1
      amount = 200
  
  return ()

-- Test: Múltiplos assets
testMultipleAssets : Script ()
testMultipleAssets = do
  operator <- allocateParty "DCNOperator"
  charlie <- allocateParty "Charlie"
  
  -- Setup
  operatorCid <- submit operator do
    createCmd DCNOperator with operator
  
  charlieCid <- submit operator do
    exerciseCmd operatorCid CreateUser with
      userId = 3
      userParty = charlie
      tradeAddress = "0xCharlie789"
  
  -- Depositar em múltiplos assets
  charlieCid2 <- submit charlie do
    exerciseCmd charlieCid Deposit with
      assetId = 1  -- ETH
      amount = 1000
  
  charlieCid3 <- submit charlie do
    exerciseCmd charlieCid2 Deposit with
      assetId = 2  -- USDC
      amount = 5000
  
  -- Verificar balances
  ethBalance <- submit charlie do
    exerciseCmd charlieCid3 GetBalance with assetId = 1
  usdcBalance <- submit charlie do
    exerciseCmd charlieCid3 GetBalance with assetId = 2
  
  assert (ethBalance == 1000)
  assert (usdcBalance == 5000)
  
  return ()
```

---

## 6. Passo 4: Executar Testes / Step 4: Run Tests

```bash
# Navegar para o diretório daml
cd daml

# Compilar o projeto Daml
daml build

# Executar testes
daml test --show-coverage

# Output esperado:
# UserTests:testUserCreationAndDeposit: ok
# UserTests:testInsufficientBalance: ok
# UserTests:testMultipleAssets: ok
```

---

## 7. Passo 5: Configurar Canton Local / Step 5: Setup Local Canton

Criar `canton-config/local/canton.conf`:

```hocon
canton {
  domains {
    local {
      storage.type = memory
      public-api.port = 4011
      admin-api.port = 4012
    }
  }
  
  participants {
    participant1 {
      storage.type = memory
      admin-api.port = 4021
      ledger-api.port = 4022
    }
    
    participant2 {
      storage.type = memory
      admin-api.port = 4031
      ledger-api.port = 4032
    }
  }
}
```

Criar script `scripts/start-local-canton.sh`:

```bash
#!/bin/bash

# Start Canton with local configuration
canton -c canton-config/local/canton.conf daemon \
  --bootstrap scripts/bootstrap.canton
```

Criar `scripts/bootstrap.canton`:

```scala
// Bootstrap script for local Canton network

// Start domain
local.start()

// Start participants
participant1.start()
participant2.start()

// Connect participants to domain
participant1.domains.connect_local(local, "participant1")
participant2.domains.connect_local(local, "participant2")

println("Canton network is ready!")
println("Participant 1 Ledger API: localhost:4022")
println("Participant 2 Ledger API: localhost:4032")
```

---

## 8. Passo 6: Deploy no Canton / Step 6: Deploy to Canton

Criar script `scripts/deploy-daml.sh`:

```bash
#!/bin/bash

# Compilar projeto Daml
cd daml
daml build -o target/canton-dcn.dar

# Upload para Canton participant
daml ledger upload-dar \
  --host=localhost \
  --port=4022 \
  target/canton-dcn.dar

echo "DAR deployed to Canton participant!"
```

Executar:

```bash
# Terminal 1: Iniciar Canton
./scripts/start-local-canton.sh

# Terminal 2: Deploy Daml
./scripts/deploy-daml.sh
```

---

## 9. Passo 7: Integração Java / Step 7: Java Integration

Criar `java-integration/build.gradle`:

```gradle
plugins {
    id 'java'
    id 'application'
}

group = 'io.merklex.canton'
version = '1.0.0'

sourceCompatibility = '11'
targetCompatibility = '11'

repositories {
    mavenCentral()
}

dependencies {
    // Daml Java bindings
    implementation 'com.daml:bindings-java:2.9.0'
    
    // Canton/Daml Ledger API
    implementation 'com.daml:bindings-rxjava:2.9.0'
    
    // Logging
    implementation 'org.slf4j:slf4j-api:2.0.9'
    implementation 'ch.qos.logback:logback-classic:1.4.11'
    
    // Testing
    testImplementation 'junit:junit:4.13.2'
    testImplementation 'org.mockito:mockito-core:5.7.0'
}

// Gerar Java bindings a partir do DAR
task generateJavaBindings(type: Exec) {
    commandLine 'daml', 'codegen', 'java',
        '../daml/target/canton-dcn.dar',
        '-o', 'src/main/java'
}

compileJava.dependsOn generateJavaBindings
```

Criar cliente básico `java-integration/src/main/java/io/merklex/canton/dcn/CantonDCNClient.java`:

```java
package io.merklex.canton.dcn;

import com.daml.ledger.javaapi.data.*;
import com.daml.ledger.rxjava.DamlLedgerClient;
import com.daml.ledger.rxjava.LedgerClient;

import java.time.Duration;
import java.util.concurrent.CompletableFuture;

public class CantonDCNClient {
    private final DamlLedgerClient client;
    private final String applicationId;
    
    public CantonDCNClient(String host, int port, String applicationId) {
        this.applicationId = applicationId;
        this.client = DamlLedgerClient.newBuilder(host, port)
                .build();
    }
    
    public void connect() {
        client.connect();
    }
    
    public void close() {
        client.close();
    }
    
    // Exemplo: Criar usuário
    public CompletableFuture<String> createUser(
            String operatorParty,
            int userId,
            String userParty,
            String tradeAddress) {
        
        // Implementação usando Ledger API
        // Este é um exemplo simplificado
        
        return CompletableFuture.completedFuture("user-contract-id");
    }
    
    // Exemplo: Fazer depósito
    public CompletableFuture<String> deposit(
            String contractId,
            String userParty,
            int assetId,
            int amount) {
        
        // Implementação usando Ledger API
        
        return CompletableFuture.completedFuture("new-contract-id");
    }
}
```

---

## 10. Próximos Passos / Next Steps

### Desenvolvimento Imediato / Immediate Development

1. **Completar Templates Base**:
   - [ ] Implementar `Exchange.daml`
   - [ ] Implementar `Asset.daml`
   - [ ] Implementar `Session.daml`
   - [ ] Implementar `Settlement.daml`

2. **Testes**:
   - [ ] Adicionar mais testes unitários
   - [ ] Criar testes de integração
   - [ ] Testar cenários de erro

3. **Integração Java**:
   - [ ] Gerar bindings Java completos
   - [ ] Implementar CantonDCNClient completo
   - [ ] Criar exemplos de uso

### Desenvolvimento de Médio Prazo / Medium-term Development

1. **Features Avançadas**:
   - [ ] Multi-party settlements
   - [ ] Privacy controls
   - [ ] Recovery mechanisms
   - [ ] Audit trails

2. **Ferramentas**:
   - [ ] CLI para operações administrativas
   - [ ] Dashboard web para monitoramento
   - [ ] Ferramentas de migração

3. **Documentação**:
   - [ ] API documentation
   - [ ] Guias de operação
   - [ ] Tutoriais avançados

---

## 11. Recursos Úteis / Useful Resources

### Documentação Oficial

- **Canton Documentation**: https://docs.canton.io
- **Daml Documentation**: https://docs.daml.com
- **Daml Java Bindings**: https://docs.daml.com/app-dev/bindings-java/

### Tutoriais e Exemplos

- **Daml Examples**: https://github.com/digital-asset/daml/tree/main/docs/source/daml/code-snippets
- **Canton Examples**: https://github.com/digital-asset/canton/tree/main/community/demo

### Comunidade

- **Daml Forum**: https://discuss.daml.com
- **Canton Slack**: https://www.canton.io/community

### Ferramentas

- **Daml Hub**: https://hub.daml.com (Cloud development platform)
- **Canton Console**: Interactive REPL para Canton

---

## 12. Solução de Problemas / Troubleshooting

### Problema: Daml SDK não instala

**Solução**:
```bash
# Verificar PATH
echo $PATH

# Adicionar ao PATH (Linux/macOS)
export PATH="$HOME/.daml/bin:$PATH"

# Adicionar permanentemente ao ~/.bashrc ou ~/.zshrc
echo 'export PATH="$HOME/.daml/bin:$PATH"' >> ~/.bashrc
```

### Problema: Canton não inicia

**Solução**:
```bash
# Verificar portas em uso
lsof -i :4011
lsof -i :4022

# Matar processos se necessário
kill -9 <PID>

# Limpar dados temporários
rm -rf /tmp/canton-*
```

### Problema: Daml tests falham

**Solução**:
```bash
# Limpar e reconstruir
daml clean
daml build

# Verificar sintaxe
daml damlc -- check src/User.daml

# Executar com verbose
daml test --verbose
```

---

## 13. Checklist de Configuração / Setup Checklist

- [ ] JDK 11+ instalado
- [ ] Daml SDK instalado e no PATH
- [ ] Canton SDK instalado
- [ ] VS Code com extensão Daml instalado
- [ ] Estrutura de projeto criada
- [ ] User.daml implementado
- [ ] Testes básicos criados
- [ ] Testes executando com sucesso
- [ ] Canton local configurado
- [ ] Canton local iniciando corretamente
- [ ] DAR deployado no Canton
- [ ] Java integration projeto configurado

---

**Versão**: 1.0  
**Última Atualização**: 2026-02-15  
**Autor**: DCN Development Team  
**Licença**: MIT
