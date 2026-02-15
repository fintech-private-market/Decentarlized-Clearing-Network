# Daml SDK Installation Guide / Guia de Instalação do Daml SDK

**Date / Data**: 2026-02-15  
**Status / Estado**: Installation Required / Instalação Necessária  
**Priority / Prioridade**: 🔴 Critical / Crítico

---

## English

### Current Situation

The Canton Clearing Network project is ready for building, but requires the Daml SDK to be installed. The standard installation method (`curl -sSL https://get.daml.com/ | sh`) is currently blocked due to network restrictions.

### Project Requirements

- **Required Daml SDK Version**: 2.9.0 (as specified in `canton-clearing-network/daml/daml.yaml`)
- **Compatible Versions**: 2.10.x or 3.x should also work
- **Java Requirement**: Java 11 or higher (Java 17 is installed and available)

### Installation Methods

#### Method 1: Standard Installation (Requires Network Access)

Once network access to `get.daml.com` is enabled:

```bash
# Install Daml SDK
curl -sSL https://get.daml.com/ | sh

# Add to PATH
export PATH="$HOME/.daml/bin:$PATH"

# Verify installation
daml version
```

#### Method 2: Manual Installation from GitHub Releases

If direct installation is blocked, download manually:

```bash
# Note: Adjust version as needed (2.10.3, 3.4.10, etc.)
DAML_VERSION="2.10.3"

# Download the installer (if available)
wget https://github.com/digital-asset/daml/releases/download/${DAML_VERSION}/install.sh
chmod +x install.sh
./install.sh

# Or use the official installer with version specification
curl -sSL https://get.daml.com/ | sh -s ${DAML_VERSION}
```

#### Method 3: Docker-Based Build

Use Docker to build without installing SDK locally:

```bash
# Create a Dockerfile with Daml SDK
cat > Dockerfile.daml <<'EOF'
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl ca-certificates
RUN curl -sSL https://get.daml.com/ | sh
ENV PATH="/root/.daml/bin:${PATH}"

WORKDIR /workspace
CMD ["/bin/bash"]
EOF

# Build Docker image
docker build -t daml-builder -f Dockerfile.daml .

# Use it to build the project
docker run -v $(pwd)/canton-clearing-network:/workspace daml-builder \
    bash -c "cd daml && daml build"
```

#### Method 4: Pre-configured CI/CD Environment

Use a CI/CD environment with Daml SDK pre-installed:
- GitHub Actions with Daml action
- GitLab CI with Daml SDK in runner
- Custom CI environment with pre-installed tools

#### Method 5: Alternative Package Managers (Future)

```bash
# Using Nix (if available in future)
nix-env -i daml

# Using Homebrew (macOS/Linux)
brew install digital-asset/tap/daml
```

### Building the Project

Once Daml SDK is installed:

```bash
cd /home/runner/work/Decentarlized-Clearing-Network/Decentarlized-Clearing-Network/canton-clearing-network

# Option 1: Use the build script
./scripts/build.sh

# Option 2: Build directly
cd daml
daml build

# Expected output: .daml/dist/canton-clearing-network-0.1.0.dar
```

### Running Tests

```bash
# Option 1: Use the test script
./scripts/test.sh

# Option 2: Run tests directly
cd daml
daml test
```

### Expected Results

✅ **Build Success Indicators**:
- Compilation completes without errors
- DAR file created at `daml/.daml/dist/canton-clearing-network-0.1.0.dar`
- File size approximately 50-100KB
- No critical warnings

✅ **Test Success Indicators**:
- All 3 test scenarios pass (testSetup, testUserOperations, testSettlement)
- No test failures
- Clear output showing test results

### Troubleshooting

**Issue**: `daml: command not found`
- **Solution**: Ensure `$HOME/.daml/bin` is in your PATH
- **Fix**: `export PATH="$HOME/.daml/bin:$PATH"`

**Issue**: Version mismatch
- **Solution**: Install the version specified in daml.yaml (2.9.0) or update daml.yaml
- **Fix**: Edit `canton-clearing-network/daml/daml.yaml` and change sdk-version

**Issue**: Network timeout during installation
- **Solution**: Use alternative installation method (Docker, manual download)
- **Fix**: See Method 2 or Method 3 above

**Issue**: Permission denied
- **Solution**: Ensure installer has execute permissions
- **Fix**: `chmod +x install.sh` or use sudo if needed

### Next Steps After Installation

1. ✅ Build the project (`daml build`)
2. ✅ Run tests (`daml test`)
3. ✅ Verify DAR file generation
4. ⏳ Install Canton SDK
5. ⏳ Deploy to local Canton network
6. ⏳ Test end-to-end functionality

---

## Português

### Situação Atual

O projeto Canton Clearing Network está pronto para build, mas requer que o Daml SDK seja instalado. O método padrão de instalação (`curl -sSL https://get.daml.com/ | sh`) está atualmente bloqueado devido a restrições de rede.

### Requisitos do Projeto

- **Versão Necessária do Daml SDK**: 2.9.0 (conforme especificado em `canton-clearing-network/daml/daml.yaml`)
- **Versões Compatíveis**: 2.10.x ou 3.x também devem funcionar
- **Requisito Java**: Java 11 ou superior (Java 17 está instalado e disponível)

### Métodos de Instalação

#### Método 1: Instalação Padrão (Requer Acesso à Rede)

Assim que o acesso à rede para `get.daml.com` for habilitado:

```bash
# Instalar Daml SDK
curl -sSL https://get.daml.com/ | sh

# Adicionar ao PATH
export PATH="$HOME/.daml/bin:$PATH"

# Verificar instalação
daml version
```

#### Método 2: Instalação Manual via GitHub Releases

Se a instalação direta estiver bloqueada, baixe manualmente:

```bash
# Nota: Ajuste a versão conforme necessário (2.10.3, 3.4.10, etc.)
DAML_VERSION="2.10.3"

# Baixar o instalador (se disponível)
wget https://github.com/digital-asset/daml/releases/download/${DAML_VERSION}/install.sh
chmod +x install.sh
./install.sh

# Ou usar o instalador oficial com especificação de versão
curl -sSL https://get.daml.com/ | sh -s ${DAML_VERSION}
```

#### Método 3: Build Baseado em Docker

Use Docker para build sem instalar SDK localmente:

```bash
# Criar um Dockerfile com Daml SDK
cat > Dockerfile.daml <<'EOF'
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl ca-certificates
RUN curl -sSL https://get.daml.com/ | sh
ENV PATH="/root/.daml/bin:${PATH}"

WORKDIR /workspace
CMD ["/bin/bash"]
EOF

# Build da imagem Docker
docker build -t daml-builder -f Dockerfile.daml .

# Usar para build do projeto
docker run -v $(pwd)/canton-clearing-network:/workspace daml-builder \
    bash -c "cd daml && daml build"
```

#### Método 4: Ambiente CI/CD Pré-configurado

Use um ambiente CI/CD com Daml SDK pré-instalado:
- GitHub Actions com ação Daml
- GitLab CI com Daml SDK no runner
- Ambiente CI personalizado com ferramentas pré-instaladas

#### Método 5: Gerenciadores de Pacotes Alternativos (Futuro)

```bash
# Usando Nix (se disponível no futuro)
nix-env -i daml

# Usando Homebrew (macOS/Linux)
brew install digital-asset/tap/daml
```

### Construindo o Projeto

Assim que o Daml SDK estiver instalado:

```bash
cd /home/runner/work/Decentarlized-Clearing-Network/Decentarlized-Clearing-Network/canton-clearing-network

# Opção 1: Usar o script de build
./scripts/build.sh

# Opção 2: Build direto
cd daml
daml build

# Saída esperada: .daml/dist/canton-clearing-network-0.1.0.dar
```

### Executando os Testes

```bash
# Opção 1: Usar o script de teste
./scripts/test.sh

# Opção 2: Executar testes diretamente
cd daml
daml test
```

### Resultados Esperados

✅ **Indicadores de Sucesso do Build**:
- Compilação completa sem erros
- Arquivo DAR criado em `daml/.daml/dist/canton-clearing-network-0.1.0.dar`
- Tamanho do arquivo aproximadamente 50-100KB
- Sem warnings críticos

✅ **Indicadores de Sucesso dos Testes**:
- Todos os 3 cenários de teste passam (testSetup, testUserOperations, testSettlement)
- Sem falhas nos testes
- Saída clara mostrando resultados dos testes

### Solução de Problemas

**Problema**: `daml: command not found`
- **Solução**: Garantir que `$HOME/.daml/bin` está no seu PATH
- **Correção**: `export PATH="$HOME/.daml/bin:$PATH"`

**Problema**: Incompatibilidade de versão
- **Solução**: Instalar a versão especificada em daml.yaml (2.9.0) ou atualizar daml.yaml
- **Correção**: Editar `canton-clearing-network/daml/daml.yaml` e alterar sdk-version

**Problema**: Timeout de rede durante instalação
- **Solução**: Usar método alternativo de instalação (Docker, download manual)
- **Correção**: Ver Método 2 ou Método 3 acima

**Problema**: Permissão negada
- **Solução**: Garantir que o instalador tem permissões de execução
- **Correção**: `chmod +x install.sh` ou usar sudo se necessário

### Próximos Passos Após Instalação

1. ✅ Build do projeto (`daml build`)
2. ✅ Executar testes (`daml test`)
3. ✅ Verificar geração do arquivo DAR
4. ⏳ Instalar Canton SDK
5. ⏳ Deploy na rede Canton local
6. ⏳ Testar funcionalidade end-to-end

---

## Alternative Workaround (Advanced Users)

If you have a working Daml installation on another machine, you can:

1. Build the project there: `daml build`
2. Copy the generated DAR file to this environment
3. Use the DAR file directly with Canton SDK

```bash
# On machine with Daml SDK:
cd canton-clearing-network/daml
daml build
# Copy .daml/dist/canton-clearing-network-0.1.0.dar to target machine
```

## References / Referências

- **Daml Documentation**: https://docs.daml.com
- **Daml SDK Releases**: https://github.com/digital-asset/daml/releases
- **Canton Documentation**: https://docs.canton.io
- **Installation Guide**: https://docs.daml.com/getting-started/installation.html

---

**Status**: Waiting for network access or alternative installation method  
**Estado**: Aguardando acesso à rede ou método alternativo de instalação  
**Next Action**: Enable network access to get.daml.com OR use Docker/CI method  
**Próxima Ação**: Habilitar acesso à rede para get.daml.com OU usar método Docker/CI
