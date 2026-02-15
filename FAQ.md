# FAQ - Migração para Canton Network / Canton Network Migration FAQ

## Perguntas Frequentes / Frequently Asked Questions

---

## Geral / General

### P: Por que migrar do Ethereum para Canton?
### Q: Why migrate from Ethereum to Canton?

**R/A**: Canton Network oferece vantagens significativas para o DCN:
- **Privacidade**: Settlements permanecem privados entre as partes envolvidas
- **Performance**: 10-100x mais transações por segundo
- **Custos**: Custos fixos e previsíveis vs. gas fees variáveis
- **Compliance**: Facilita adequação a regulações financeiras (GDPR, etc.)
- **Interoperabilidade**: Melhor integração entre múltiplas exchanges e sistemas

---

### P: Quanto tempo levará a migração?
### Q: How long will the migration take?

**R/A**: **15-20 semanas** (3.5-5 meses) para implementação completa:
- Fase 1: Setup e preparação (2-3 semanas)
- Fase 2: Core templates (3-4 semanas)
- Fase 3: Settlement logic (3-4 semanas)
- Fase 4: Integração (3-4 semanas)
- Fase 5: Testes (2-3 semanas)
- Fase 6: Documentação e deploy (2-3 semanas)

---

### P: Quanto custará?
### Q: How much will it cost?

**R/A**: Investimento estimado: **$190k-$335k**
- Desenvolvimento: $150k-$250k
- Infraestrutura: $5k-$10k/mês
- Treinamento: $10k-$20k
- Contingência (15%): $25k-$45k

**ROI**: Payback em 4-8 meses através de redução de custos operacionais.

---

### P: Devo adaptar o código existente ou criar um novo projeto?
### Q: Should I adapt existing code or create a new project?

**R/A**: **Criar novo projeto** (fortemente recomendado):
- ✅ Arquitetura limpa otimizada para Canton
- ✅ Aproveita recursos nativos do Canton
- ✅ Mais fácil de manter e evoluir
- ✅ Melhor experiência de desenvolvimento

Adaptar o código Ethereum resultaria em:
- ❌ Arquitetura comprometida
- ❌ Código sub-ótimo
- ❌ Complexidade desnecessária
- ❌ ~70-80% precisaria ser reescrito de qualquer forma

---

## Técnicas / Technical

### P: O que é Daml e como difere do Solidity?
### Q: What is Daml and how does it differ from Solidity?

**R/A**:
| Aspecto | Solidity | Daml |
|---------|----------|------|
| Paradigma | Imperativo | Funcional, declarativo |
| Tipagem | Estática | Forte, estática |
| Privacidade | Nenhuma | Nativa |
| Estado | Mutável, global | Imutável, ledger |
| Gas/Custos | Sim | Não |
| Learning Curve | Média | Média-Alta |

---

### P: Posso reutilizar algum código Java existente?
### Q: Can I reuse any existing Java code?

**R/A**: **Parcialmente**:
- ✅ **Pode reutilizar**: Lógica de negócio, helpers (hashing, validação)
- ✅ **Pode adaptar**: Classes de modelo, testes de lógica
- ❌ **Não pode reutilizar**: Código web3j, wrappers de contrato
- ❌ **Precisa reescrever**: Smart contracts (Solidity → Daml)

**Estimativa**: ~30-40% do código Java pode ser reutilizado/adaptado.

---

### P: Como funciona a privacidade no Canton?
### Q: How does privacy work in Canton?

**R/A**: Canton oferece **sub-transaction privacy**:
- Cada contrato tem signatories (quem pode criar/exercer)
- Observers (quem pode ver)
- Apenas partes envolvidas veem a transação
- Outros participantes da rede não veem nada
- Selective disclosure para reguladores/auditores

**Exemplo**:
```daml
template Settlement
  with
    exchange: Party
    users: [Party]
  where
    signatory exchange
    observer users  -- Só users e exchange veem
```

---

### P: Canton é descentralizado?
### Q: Is Canton decentralized?

**R/A**: **Sim, mas de forma diferente do Ethereum**:
- **Ethereum**: Descentralização total, consenso global
- **Canton**: Descentralização configurável, consenso entre participantes

**Canton oferece**:
- Múltiplos participant nodes independentes
- Múltiplos synchronization domains
- Não há ponto central de falha
- Governança distribuída possível

**Melhor para**: Aplicações que precisam de privacy e performance, mas ainda querem descentralização.

---

### P: Como faço para integrar com blockchains existentes (Ethereum, etc.)?
### Q: How do I integrate with existing blockchains (Ethereum, etc.)?

**R/A**: Canton oferece várias opções:
1. **Canton-Ethereum Bridge**: Para interoperabilidade com contratos Ethereum
2. **Oracle Services**: Para dados externos
3. **Daml on Ethereum**: Executar Daml em Ethereum (se necessário)
4. **APIs externas**: Via Ledger API triggers

**Recomendação**: Usar Canton como sistema principal e bridges apenas quando necessário.

---

### P: Quais são os requisitos de infraestrutura?
### Q: What are the infrastructure requirements?

**R/A**: **Para desenvolvimento**:
- CPU: 4+ cores
- RAM: 8+ GB
- Storage: 50+ GB
- OS: Linux, macOS, ou Windows

**Para produção** (por participant):
- CPU: 8+ cores
- RAM: 16+ GB
- Storage: 500+ GB SSD
- Network: Alta largura de banda, baixa latência
- Database: PostgreSQL recomendado

---

## Migração / Migration

### P: Como migro dados do Ethereum para Canton?
### Q: How do I migrate data from Ethereum to Canton?

**R/A**: **Processo de migração**:
1. **Export**: Exportar estado atual do Ethereum (users, balances, etc.)
2. **Transform**: Converter para formato Canton (JSON/CSV)
3. **Import**: Usar scripts Daml para popular Canton
4. **Validate**: Verificar integridade dos dados
5. **Cutover**: Trocar para Canton em janela de manutenção

**Ferramentas**: Criaremos scripts de migração como parte do projeto.

---

### P: Posso rodar Ethereum e Canton em paralelo?
### Q: Can I run Ethereum and Canton in parallel?

**R/A**: **Sim, recomendado para transição gradual**:
1. **Fase 1**: Ethereum em produção, Canton em teste
2. **Fase 2**: Ambos em produção, novos clientes no Canton
3. **Fase 3**: Migração gradual de clientes existentes
4. **Fase 4**: Ethereum em modo legacy, sunset planejado

**Duração sugerida**: 6-12 meses de operação paralela.

---

### P: O que acontece se a migração falhar?
### Q: What happens if migration fails?

**R/A**: **Plano de contingência**:
- Ethereum continua operando normalmente
- Canton pode ser desligado sem impacto
- Dados não são perdidos (export antes da migração)
- Rollback plan preparado
- Insurance através de testes extensivos e beta phase

**Risco**: Baixo, devido a abordagem gradual e testes extensivos.

---

## Desenvolvimento / Development

### P: Preciso aprender uma nova linguagem?
### Q: Do I need to learn a new language?

**R/A**: **Sim, Daml**:
- **Similaridade**: Se você conhece Haskell ou ML, será familiar
- **Learning Curve**: 2-4 semanas para proficiência básica
- **Recursos**: Documentação excelente, tutorials, comunidade ativa
- **Treinamento**: Recomendamos curso oficial Daml Fundamentals

**Para Java developers**: A integração Java usa bindings gerados, familiar para quem usa web3j.

---

### P: Quais ferramentas de desenvolvimento estão disponíveis?
### Q: What development tools are available?

**R/A**: **Ferramentas Canton/Daml**:
- **Daml IDE**: Extensão VSCode com syntax highlighting, autocomplete
- **Daml Studio**: IDE standalone
- **Canton Console**: REPL interativo para debug
- **Daml Script**: Testing framework nativo
- **Navigator**: UI web para explorar ledger

**Vantagens**: Experiência de desenvolvimento superior ao Ethereum.

---

### P: Como faço testes?
### Q: How do I do testing?

**R/A**: **Múltiplas camadas de teste**:
1. **Daml Scenarios**: Testes unitários nativos, executam instantaneamente
2. **Daml Scripts**: Testes de integração com múltiplos parties
3. **Canton Integration Tests**: Testes com rede Canton real
4. **Java Tests**: JUnit para lógica de integração

**Vantagens**:
- Testes mais rápidos (sem deploy real)
- Debugging melhor
- Time-travel para reproduzir estados

---

### P: Há exemplos de código disponíveis?
### Q: Are there code examples available?

**R/A**: **Sim**:
- **QUICKSTART_GUIDE.md**: Exemplos completos de User template
- **Documentação oficial Daml**: Centenas de exemplos
- **Canton Examples**: GitHub repository com demos
- **Este projeto**: Criaremos exemplos completos durante implementação

---

## Operacional / Operational

### P: Como faço deploy em produção?
### Q: How do I deploy to production?

**R/A**: **Processo de deploy**:
1. Compilar Daml code → .dar file
2. Upload .dar para Canton participants
3. Configurar participants e domain
4. Iniciar participants
5. Conectar ao domain
6. Executar scripts de inicialização

**Automação**: Scripts de deploy fornecidos no projeto.

---

### P: Como monitoro o sistema Canton?
### Q: How do I monitor the Canton system?

**R/A**: **Opções de monitoramento**:
- **Canton Console**: Métricas e status em tempo real
- **Prometheus**: Exportador de métricas disponível
- **Grafana**: Dashboards para visualização
- **Logging**: Logs estruturados (JSON)
- **Health Checks**: Endpoints HTTP para health

---

### P: Como faço backup?
### Q: How do I do backups?

**R/A**: **Estratégia de backup**:
- **Database Backups**: Backup do PostgreSQL regular
- **DAR Files**: Versionar em Git
- **Configuration**: Backup de configs Canton
- **Frequency**: Recomendado diário + antes de upgrades

**Recovery**: Restore database + redeploy DARs.

---

### P: Como atualizo o código Daml em produção?
### Q: How do I update Daml code in production?

**R/A**: **Upgrade process**:
1. Desenvolver nova versão do DAR
2. Testar extensivamente
3. Upload novo DAR para participants
4. Rolling upgrade dos participants
5. Verificar funcionamento
6. (Opcional) Deprecar versão antiga

**Vantagem**: Upgrades mais fáceis que no Ethereum (sem migração de estado).

---

## Negócio / Business

### P: Quais são os benefícios de negócio?
### Q: What are the business benefits?

**R/A**: **ROI direto**:
- **Redução de custos**: 60%+ em custos operacionais
- **Performance**: 10-100x mais throughput
- **Time-to-market**: Features mais rápido
- **Compliance**: Adequação regulatória facilitada
- **Competitividade**: Diferencial no mercado

**ROI indireto**:
- Melhor experiência do cliente
- Menos downtime
- Maior confiabilidade

---

### P: Como justifico o investimento para stakeholders?
### Q: How do I justify the investment to stakeholders?

**R/A**: **Use EXECUTIVE_RECOMMENDATION.md**:
- Apresentação executiva clara
- Análise custo-benefício detalhada
- Comparação de alternativas
- Métricas de sucesso
- Timeline e recursos

**Key Points**:
- Investimento: $190k-$335k
- Payback: 4-8 meses
- Redução de custos: $60k-$480k/ano

---

### P: Que garantias tenho de que Canton é confiável?
### Q: What guarantees do I have that Canton is reliable?

**R/A**: **Credibilidade**:
- Desenvolvido por **Digital Asset** (empresa líder em DLT)
- Usado por instituições financeiras globais
- Auditado e certificado
- Open source (transparência)
- Comunidade ativa e suporte enterprise

**Casos de uso**: ASX (bolsa australiana), múltiplos bancos globais.

---

## Suporte / Support

### P: Onde obtenho ajuda durante a implementação?
### Q: Where do I get help during implementation?

**R/A**: **Recursos**:
- **Documentação**: https://docs.canton.io, https://docs.daml.com
- **Fórum**: https://discuss.daml.com
- **Slack**: Canton Community Slack
- **Suporte Enterprise**: Digital Asset oferece suporte pago
- **Consultoria**: Parceiros certificados disponíveis

---

### P: Preciso de suporte enterprise?
### Q: Do I need enterprise support?

**R/A**: **Depende**:
- **Sim, se**: Aplicação crítica, SLA rigoroso, precisa de garantias
- **Não, se**: Community support suficiente, equipe experiente

**Recomendação**: Community para desenvolvimento, Enterprise para produção.

---

### P: A comunidade Canton/Daml é ativa?
### Q: Is the Canton/Daml community active?

**R/A**: **Sim, muito ativa**:
- Forum: Centenas de posts por mês
- Slack: Milhares de membros
- GitHub: Issues respondidas rapidamente
- Meetups: Eventos regulares
- Conferências: DDD (Daml Driven Development) anual

---

## Próximos Passos / Next Steps

### P: Por onde começo?
### Q: Where do I start?

**R/A**: **Checklist imediato**:
1. ✅ Ler **EXECUTIVE_RECOMMENDATION.md**
2. ✅ Revisar **CANTON_MIGRATION_PLAN.md**
3. ✅ Estudar **ARCHITECTURE_COMPARISON.md**
4. 🔲 Seguir **QUICKSTART_GUIDE.md**
5. 🔲 Instalar Canton e Daml SDK
6. 🔲 Implementar PoC básico
7. 🔲 Apresentar para stakeholders

---

### P: Quem devo contatar para mais informações?
### Q: Who should I contact for more information?

**R/A**: **Contatos**:
- **Technical Lead**: [email técnico]
- **Product Manager**: [email produto]
- **Architecture Team**: [email arquitetura]

**Para suporte geral**: Abrir issue neste repositório.

---

### P: Há um roadmap público?
### Q: Is there a public roadmap?

**R/A**: **Roadmap preliminar**:
- **Q2 2026**: PoC e aprovação
- **Q3 2026**: Desenvolvimento core features
- **Q4 2026**: Beta testing
- **Q1 2027**: Production deployment
- **Q2 2027**: Full migration complete

**Status**: Aguardando aprovação de stakeholders.

---

## Glossário / Glossary

**Canton Network**: Rede de interoperabilidade baseada no Canton protocol.

**Daml**: Digital Asset Modeling Language - linguagem para smart contracts.

**Participant**: Nó que hospeda aplicações Daml.

**Domain**: Domínio de sincronização para ordering de transações.

**Template**: Equivalente Canton de smart contract.

**Choice**: Método/função em um template Daml.

**Party**: Entidade que pode assinar contratos (usuário, exchange, etc.).

**Signatory**: Party que deve assinar para criar/exercer um contrato.

**Observer**: Party que pode ver um contrato mas não pode modificá-lo.

**Ledger API**: API gRPC para integração com Canton.

**DAR**: Daml Archive - pacote compilado de código Daml.

---

**Versão**: 1.0  
**Última Atualização**: 2026-02-15  
**Idiomas**: Português, English  
**Licença**: MIT
