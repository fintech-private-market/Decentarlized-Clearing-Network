# Arquitetura do Canton Clearing Network

## Visão Geral

O Canton Clearing Network (CCN) é uma reimplementação completa do Decentralized Clearing Network (DCN) original baseado em Ethereum, agora construído na Canton Network. Esta migração aproveita as capacidades avançadas da Canton Network para privacidade, interoperabilidade e escalabilidade.

## Componentes Principais

### 1. Templates Daml

#### UserAccount
- Representa contas de usuário na rede
- Suporta até 2^64 usuários
- Gerencia status de conta (ativo/inativo)
- Armazena metadados do usuário

#### RegisteredExchange
- Representa exchanges registradas
- Suporta até 2^32 exchanges
- Gerencia taxas de liquidação
- Controla status de exchange

#### RegisteredAsset
- Representa ativos registrados
- Suporta até 2^32 ativos
- Gerencia informações de ativos (símbolo, nome, decimais)
- Rastreia fornecedor de ativos

#### SettlementRequest
- Gerencia solicitações de liquidação
- Suporta transferências multi-party
- Implementa fluxo de aprovação
- Rastreia status de liquidação

#### TradingSession
- Gerencia sessões de negociação
- Rastreia participantes e ativos ativos
- Controla ciclo de vida da sessão

#### DCNOperatorRole
- Define papel e permissões do operador
- Gerencia configuração da rede
- Mantém logs de auditoria

## Modelo de Privacidade

A Canton Network fornece privacidade em nível de subtransação:

1. **Privacidade de Dados**: Apenas as partes envolvidas em uma transação veem os detalhes
2. **Divulgação Seletiva**: Operador pode revelar dados para auditoria quando necessário
3. **Criptografia de Ponta a Ponta**: Comunicação segura entre participantes

## Modelo de Sincronização

### Participantes
- **DCN Operator**: Gerencia a rede
- **Exchanges**: Entidades que facilitam negociações
- **Users**: Usuários finais que negociam ativos
- **Asset Providers**: Fornecedores de ativos

### Domínios
- **DCN Domain**: Domínio principal de sincronização para liquidação
- Possibilidade de múltiplos domínios para escalabilidade

## Comparação com Ethereum DCN

| Aspecto | Ethereum DCN | Canton DCN |
|---------|-------------|------------|
| Linguagem | Solidity | Daml |
| Privacidade | Pública | Sub-transação privada |
| Modelo de Dados | Storage mutável | Contracts imutáveis |
| Escalabilidade | Limitada | Horizontal |
| Interoperabilidade | Limitada a EVM | Multi-domain |
| Custos | Gas fees | Taxas configuráveis |

## Fluxo de Liquidação

1. **Criação de Sessão**: Operador cria uma sessão de negociação
2. **Registro de Negociações**: Exchanges registram negociações
3. **Solicitação de Liquidação**: Sistema cria solicitações de liquidação
4. **Aprovação Multi-Party**: Partes aprovam liquidação
5. **Execução**: Operador executa a liquidação
6. **Finalização**: Balances são atualizados atomicamente

## Segurança

- **Signatários**: Cada template requer signatários apropriados
- **Observadores**: Partes que podem ver mas não modificar contratos
- **Chaves**: Identificadores únicos para contracts
- **Permissões**: Sistema de permissões baseado em roles

## Integração

### API Ledger
- gRPC API para integração de aplicações
- Suporte para Java, JavaScript, Python

### Java Client
- Cliente Java fornecido em `java-integration/`
- Abstração sobre Canton Ledger API
- Métodos para operações comuns (registrar usuário, criar liquidação, etc.)

## Configuração

### Local (Desenvolvimento)
- Storage em memória
- Múltiplos participantes locais
- Configuração simplificada

### Test
- PostgreSQL para persistência
- Configuração similar à produção
- Múltiplos participantes

### Production
- PostgreSQL com HA
- Múltiplos domínios
- Monitoramento e métricas
- SSL/TLS habilitado

## Próximos Passos

1. Implementar lógica de negócio adicional
2. Adicionar mais casos de teste
3. Implementar integração Java completa
4. Desenvolver ferramentas de migração
5. Setup de CI/CD
6. Documentação de API
7. Testes de performance
