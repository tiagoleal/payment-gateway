 # Architecture Overview - Multi-Payment Billing System

## Executive Summary

The Multi-Payment Billing System is a Ruby on Rails 8.0.4 application developed to process monthly charges for clients through multiple payment methods. The architecture was designed following SOLID principles, with special emphasis on the **Open/Closed Principle** through the implementation of the **Strategy Pattern**.

## 4-Level Architecture (C4 Model)

### Level 1: System Context

**Purpose**: High-level view showing the system in the business context.

**Main Actors**:
- **System User**: Administrator who manages clients and views reports
- **Billing System**: Central automated billing system
- **Email System**: External service for password recovery
- **Payment Gateway**: External processing systems (Boleto, Card, PIX)

**Main Flows**:
1. User manages clients via web interface
2. System processes charges through external gateways
3. System sends notifications via email

---

### Level 2: Containers

**Purpose**: Shows the main applications and services that make up the system.

#### Identified Containers

| Container | Technology | Responsibility |
|-----------|-----------|------------------|
| **Web Application** | Rails 8.0.4 + Hotwire + Tailwind | Responsive web interface, client CRUD, authentication |
| **Background Worker** | Solid Queue | Asynchronous billing processing, automatic retry |
| **Database** | SQLite 3 | Persistence of clients, users, billing records |
| **Queue System** | Solid Queue | Queue management and scheduling of recurring jobs |
| **Cache System** | Solid Cache | Performance optimization |

#### Main Interactions

```
Web App → Database (SQL)
Web App → Queue System (enqueues jobs)
Background Worker → Queue System (consumes jobs)
Background Worker → Payment Gateway (processes charges)
```

---

### Level 3: Components

**Purpose**: Detailing the internal components of the Web Application.

#### Controllers

| Controller | Responsibility |
|-----------|------------------|
| **ClientsController** | Client CRUD with payment method selection (1-31 days) |
| **BillingReportsController** | Dashboard of billed and pending clients |
| **SessionsController** | Autenticação (login/logout) |
| **UsersController** | Cadastro de usuários e recuperação de senha |

#### Models

| Model | Atributos Principais |
|-------|---------------------|
| **Client** | name, due_day (1-31), payment_method_identifier |
| **BillingRecord** | client_id, billed_at, year_month (YYYY-MM), status |
| **User** | email, password_digest (bcrypt) |

#### Services

| Service | Responsabilidade |
|---------|------------------|
| **BillingReportService** | Gera relatórios de faturamento e clientes pendentes |
| **PaymentStrategies** | Conjunto de estratégias de pagamento (Strategy Pattern) |

#### Background Jobs

| Job | Frequência | Função |
|-----|-----------|--------|
| **Billing::SchedulerJob** | Diário (12h prod, 1min dev) | Busca clientes com vencimento no dia e enfileira cobranças |
| **Billing::ChargeClientJob** | On-demand | Processa cobrança individual com retry (3x, 10min) |

---

### Nível 4: Código - Strategy Pattern

**Propósito**: Implementação detalhada do padrão Strategy para métodos de pagamento.

#### Estrutura de Classes

```
PaymentStrategies::Base (Abstract)
├── strategies() → Hash de todas estratégias (reflection)
└── charge(client) → NotImplementedError

PaymentStrategies::BoletoStrategy (Concrete)
└── charge(client) → Gera código de barras fictício

PaymentStrategies::CreditCardStrategy (Concrete)
└── charge(client) → Simula débito no cartão

PaymentStrategies::PixStrategy (Concrete - Futuro)
└── charge(client) → Processa PIX
```

#### Fluxo de Execução

```ruby
# 1. ChargeClientJob recebe client_id
client = Client.find(client_id)

# 2. Verifica duplicação (year_month = "2025-12")
return if BillingRecord.exists?(client_id: client.id, year_month: "2025-12")

# 3. Seleciona estratégia dinamicamente
strategies = PaymentStrategies::Base.strategies
strategy = strategies[client.payment_method_identifier]

# 4. Executa cobrança (polimorfismo)
result = strategy.charge(client)

# 5. Cria registro
BillingRecord.create!(
  client_id: client.id,
  status: result[:success] ? 'success' : 'failed',
  year_month: "2025-12"
)
```

#### Princípio Open/Closed

**Aberto para extensão** (adicionar novas estratégias):
```ruby
# app/services/payment_strategies/pix_strategy.rb
class PaymentStrategies::PixStrategy < PaymentStrategies::Base
  def charge(client)
    # Implementação PIX
    { success: true, message: "PIX gerado" }
  end
end
```

**Fechado para modificação** (nenhum código existente muda):
- Não precisa modificar `Base`
- Não precisa modificar `ChargeClientJob`
- Não precisa modificar outras estratégias
- Descoberta automática via `descendants`

---

## Principais Decisões Arquiteturais

### 1. Strategy Pattern para Pagamentos

**Decisão**: Usar Strategy Pattern em vez de if/else ou switch/case.

**Justificativa**:
- ✅ Facilita adição de novos métodos de pagamento
- ✅ Cada estratégia é testada isoladamente
- ✅ Reduz complexidade ciclomática
- ✅ Compliance com SOLID (Open/Closed Principle)

**Trade-off**: Maior número de classes, mas código mais limpo e extensível.

### 2. Solid Queue para Background Jobs

**Decisão**: Usar Solid Queue (padrão Rails 8) em vez de Sidekiq/Resque.

**Justificativa**:
- ✅ Zero dependências externas (Redis, etc)
- ✅ Armazenamento em SQLite (simplicidade)
- ✅ Jobs recorrentes nativos (sem cron)
- ✅ Retry automático configurável
- ✅ Menor complexidade operacional

**Trade-off**: Menos features avançadas que Sidekiq, mas suficiente para o caso de uso.

### 3. SQLite como Database

**Decisão**: SQLite em vez de PostgreSQL/MySQL.

**Justificativa**:
- ✅ Zero configuração (serverless)
- ✅ Ideal para desenvolvimento e testes
- ✅ Sufficient para volume esperado
- ✅ Facilita onboarding de desenvolvedores

**Trade-off**: Limitações de concorrência, mas adequado para protótipo/teste técnico.

### 4. Hotwire em vez de React/Vue

**Decisão**: Usar Hotwire (Turbo + Stimulus) para frontend.

**Justificativa**:
- ✅ Server-side rendering (simplicidade)
- ✅ Interatividade sem JavaScript pesado
- ✅ Melhor performance inicial
- ✅ Menos complexidade de build

**Trade-off**: Menos interatividade que SPA, mas adequado para admin panel.

---

## Garantias do Sistema

### 1. Não Cobrar Duas Vezes no Mês

**Implementação**:
```ruby
# Índice único no banco
add_index :billing_records, [:client_id, :year_month], unique: true

# Verificação no job
return if BillingRecord.exists?(client_id: client.id, year_month: current_month)
```

### 2. Retry Automático

**Configuração**:
- 3 tentativas máximas
- 10 minutos de intervalo entre tentativas
- Job falha definitivamente após 3 tentativas

### 3. Isolamento de Falhas

**Implementação**:
- Cada cliente é processado em job separado
- Falha em um cliente não afeta outros
- Logs detalhados de cada tentativa

---

## Fluxo Completo de Faturamento

### Dia 1 do Mês (exemplo)

```
12:00 → Billing::SchedulerJob executa
│
├─ Busca clientes com due_day = 1
│   ├─ Cliente A (Boleto)
│   ├─ Cliente B (Cartão)
│   └─ Cliente C (Cartão)
│
├─ Enfileira 3 jobs no Solid Queue
│
└─ Jobs são processados pelo Worker:
    │
    ├─ ChargeClientJob(Cliente A)
    │   ├─ Verifica: não faturado em 2025-12? ✓
    │   ├─ Seleciona: BoletoStrategy
    │   ├─ Executa: charge(cliente_a)
    │   ├─ Gateway: processa boleto
    │   └─ Cria: BillingRecord(success)
    │
    ├─ ChargeClientJob(Cliente B)
    │   ├─ Verifica: não faturado em 2025-12? ✓
    │   ├─ Seleciona: CreditCardStrategy
    │   ├─ Executa: charge(cliente_b)
    │   ├─ Gateway: processa cartão
    │   └─ Cria: BillingRecord(success)
    │
    └─ ChargeClientJob(Cliente C)
        ├─ Verifica: não faturado em 2025-12? ✓
        ├─ Seleciona: CreditCardStrategy
        ├─ Executa: charge(cliente_c)
        ├─ Gateway: ERRO! Cartão inválido
        ├─ Status: failed
        └─ Retry: agendado para daqui 10 min
            │
            └─ [10 min depois]
                ├─ Tentativa 2/3
                ├─ Gateway: ERRO! Ainda inválido
                └─ Retry: agendado para daqui 10 min
                    │
                    └─ [10 min depois]
                        ├─ Tentativa 3/3
                        ├─ Gateway: ERRO!
                        └─ Job falha definitivamente
```

---

## Métricas de Qualidade

### Cobertura de Testes
- **RSpec**: 100% de cobertura
- **Cucumber**: Testes BDD completos
- **System Tests**: Selenium + Capybara

### Princípios SOLID
- ✅ **S**ingle Responsibility: Cada classe tem uma responsabilidade
- ✅ **O**pen/Closed: Strategy Pattern permite extensão sem modificação
- ✅ **L**iskov Substitution: Estratégias são intercambiáveis
- ✅ **I**nterface Segregation: Interfaces pequenas e focadas
- ✅ **D**ependency Inversion: Depende de abstrações (Base), não implementações

### Performance
- Cache com Solid Cache
- Background jobs para operações pesadas
- Índices de banco otimizados

---

**Documentação gerada**: 2025-12-13
**Versão do sistema**: 1.0
**Tecnologia principal**: Ruby on Rails 8.0.4
