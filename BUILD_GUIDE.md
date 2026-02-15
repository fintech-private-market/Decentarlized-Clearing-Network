# Building Canton Clearing Network
# Construindo Canton Clearing Network

This guide provides multiple methods to build the Canton Clearing Network Daml project.  
Este guia fornece múltiplos métodos para construir o projeto Daml Canton Clearing Network.

---

## Quick Start / Início Rápido

### Prerequisites / Pré-requisitos

- Java 11+ (Java 17 recommended / recomendado)
- Network access / Acesso à rede (for Daml SDK installation / para instalação do Daml SDK)

### Method 1: Direct Build (Fastest) / Build Direto (Mais Rápido)

```bash
# Install Daml SDK / Instalar Daml SDK
curl -sSL https://get.daml.com/ | sh
export PATH="$HOME/.daml/bin:$PATH"

# Build project / Construir projeto
cd canton-clearing-network/daml
daml build

# Run tests / Executar testes
daml test
```

**Expected Output / Saída Esperada**:
```
Building canton-clearing-network 0.1.0...
Created .daml/dist/canton-clearing-network-0.1.0.dar

Test Summary:
✅ testSetup - PASSED
✅ testUserOperations - PASSED
✅ testSettlement - PASSED
```

---

## Alternative Methods / Métodos Alternativos

### Method 2: Using Helper Script / Usando Script de Auxílio

```bash
# Run installation script / Executar script de instalação
./install-daml.sh

# Build using build script / Construir usando script de build
cd canton-clearing-network
./scripts/build.sh

# Test using test script / Testar usando script de teste
./scripts/test.sh
```

### Method 3: Using Docker Compose / Usando Docker Compose

**Build and test in one command** / **Build e teste em um comando**:

```bash
docker-compose run --rm daml-builder
```

**Run tests only** / **Executar somente testes**:

```bash
docker-compose run --rm daml-test
```

**Interactive development environment** / **Ambiente de desenvolvimento interativo**:

```bash
docker-compose run --rm daml-dev
# Now you're in a container with Daml SDK installed
# Agora você está em um container com Daml SDK instalado
cd canton-clearing-network/daml
daml build
daml test
```

### Method 4: Using GitHub Actions / Usando GitHub Actions

The project includes a GitHub Actions workflow that automatically builds and tests the project.  
O projeto inclui um workflow do GitHub Actions que automaticamente constrói e testa o projeto.

**To trigger the workflow** / **Para ativar o workflow**:

1. Push to `main`, `develop`, or `copilot/install-daml-sdk` branches
2. Create a pull request
3. Manually trigger from GitHub Actions tab

**Download built artifact** / **Baixar artefato construído**:

1. Go to Actions tab in GitHub / Vá para aba Actions no GitHub
2. Select the workflow run / Selecione a execução do workflow
3. Download `canton-clearing-network-dar` artifact / Baixe o artefato `canton-clearing-network-dar`

---

## Build Outputs / Saídas do Build

### Main Artifact / Artefato Principal

- **Location / Localização**: `canton-clearing-network/daml/.daml/dist/canton-clearing-network-0.1.0.dar`
- **Type / Tipo**: Daml Archive (DAR) file
- **Size / Tamanho**: ~50-100KB
- **Purpose / Propósito**: Deployable package for Canton network

### Contents / Conteúdo

The DAR file includes / O arquivo DAR inclui:
- 6 Daml modules / 6 módulos Daml:
  - Asset.daml
  - DCNOperator.daml
  - Exchange.daml
  - Session.daml
  - Settlement.daml
  - User.daml
- Compiled bytecode / Bytecode compilado
- Metadata and dependencies / Metadados e dependências

---

## Testing / Testes

### Test Suites / Suítes de Teste

The project includes comprehensive tests in / O projeto inclui testes abrangentes em:
- `canton-clearing-network/daml/tests/Tests.daml`
- `canton-clearing-network/daml/tests/EnhancedTests.daml`

### Test Scenarios / Cenários de Teste

1. **testSetup**: Full system setup with operator, exchanges, and users  
   Configuração completa do sistema com operador, exchanges e usuários

2. **testUserOperations**: User account lifecycle (create, deposit, withdraw)  
   Ciclo de vida da conta de usuário (criar, depositar, sacar)

3. **testSettlement**: Settlement workflow between exchanges  
   Fluxo de trabalho de liquidação entre exchanges

### Running Tests / Executando Testes

```bash
# All tests / Todos os testes
cd canton-clearing-network/daml
daml test

# Specific test file / Arquivo de teste específico
daml test --test-file tests/Tests.daml
```

---

## Verification / Verificação

### Inspect DAR File / Inspecionar Arquivo DAR

```bash
cd canton-clearing-network/daml
daml damlc inspect-dar .daml/dist/canton-clearing-network-0.1.0.dar
```

**Expected Output** / **Saída Esperada**:
```
Modules:
  Asset
  DCNOperator
  Exchange
  Session
  Settlement
  User
```

### Verify Build / Verificar Build

```bash
# Check DAR file exists / Verificar se arquivo DAR existe
ls -lh canton-clearing-network/daml/.daml/dist/canton-clearing-network-0.1.0.dar

# Check file size / Verificar tamanho do arquivo
du -h canton-clearing-network/daml/.daml/dist/canton-clearing-network-0.1.0.dar
```

---

## Troubleshooting / Solução de Problemas

### Common Issues / Problemas Comuns

#### 1. "daml: command not found"

**Solution / Solução**:
```bash
export PATH="$HOME/.daml/bin:$PATH"
# Or reinstall / Ou reinstalar
curl -sSL https://get.daml.com/ | sh
```

#### 2. "Cannot resolve host: get.daml.com"

**Solution / Solução**: Use Docker Compose method  
**Solução**: Use método Docker Compose

```bash
docker-compose run --rm daml-builder
```

#### 3. Build errors / Erros de build

**Check syntax** / **Verificar sintaxe**:
```bash
cd canton-clearing-network/daml
daml build --help
# Review error messages / Revisar mensagens de erro
```

#### 4. Test failures / Falhas nos testes

**Run tests with verbose output** / **Executar testes com saída detalhada**:
```bash
cd canton-clearing-network/daml
daml test --show-coverage
```

#### 5. Permission issues / Problemas de permissão

**Fix permissions** / **Corrigir permissões**:
```bash
chmod +x install-daml.sh
chmod +x canton-clearing-network/scripts/*.sh
```

---

## Next Steps / Próximos Passos

After successful build / Após build bem-sucedido:

1. **Install Canton SDK** / **Instalar Canton SDK**
   ```bash
   # Download Canton from https://www.canton.io/downloads
   # Or use package manager / Ou usar gerenciador de pacotes
   ```

2. **Deploy DAR to Canton** / **Fazer Deploy do DAR no Canton**
   ```bash
   cd canton-clearing-network
   ./scripts/start-local.sh
   # Upload DAR using Canton console
   ```

3. **Test with Canton** / **Testar com Canton**
   - Start local Canton network / Iniciar rede Canton local
   - Upload DAR file / Fazer upload do arquivo DAR
   - Execute test scenarios / Executar cenários de teste

4. **Implement Java Integration** / **Implementar Integração Java**
   - See `canton-clearing-network/java-integration/` / Ver `canton-clearing-network/java-integration/`
   - Use Daml Java bindings / Usar bindings Java do Daml

---

## Documentation / Documentação

For more information / Para mais informações:

- **Installation Guide** / **Guia de Instalação**: [DAML_SDK_INSTALLATION.md](DAML_SDK_INSTALLATION.md)
- **Status Report** / **Relatório de Status**: [DAML_INSTALLATION_STATUS.md](DAML_INSTALLATION_STATUS.md)
- **Project README** / **README do Projeto**: [canton-clearing-network/README.md](canton-clearing-network/README.md)
- **Architecture** / **Arquitetura**: [canton-clearing-network/docs/en/ARCHITECTURE.md](canton-clearing-network/docs/en/ARCHITECTURE.md)

---

## Support / Suporte

### Official Resources / Recursos Oficiais

- **Daml Documentation**: https://docs.daml.com
- **Canton Documentation**: https://docs.canton.io
- **Daml Forum**: https://discuss.daml.com

### Project Resources / Recursos do Projeto

- **GitHub Issues**: For bug reports / Para relatórios de bugs
- **Project Documentation**: See `canton-clearing-network/docs/` / Ver `canton-clearing-network/docs/`

---

**Last Updated / Última Atualização**: 2026-02-15  
**Version / Versão**: 1.0
