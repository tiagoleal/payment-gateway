# 💳 Multi-Payment Billing System

> Automated billing system with support for multiple payment methods using the Strategy Pattern.

[![Ruby](https://img.shields.io/badge/Ruby-3.2.1-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-8.0.4-red.svg)](https://rubyonrails.org/)
[![SQLite](https://img.shields.io/badge/SQLite-3-blue.svg)](https://www.sqlite.org/)
[![RSpec](https://img.shields.io/badge/Tests-RSpec-green.svg)](https://rspec.info/)
[![Coverage](https://img.shields.io/badge/Coverage-100%25-brightgreen.svg)](https://github.com/simplecov-ruby/simplecov)

## 📋 Index
- [About the Project](#-about-the-project)
- [Features](#-features)
- [Architecture](#-architecture)
- [Technologies](#-technologies)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Installation and Execution](#-installation-and-execution)
- [C4 Architecture Overview](docs/c4/INDEX.md)
- [Tests](#-tests)
- [Background Jobs](#-background-jobs)
- [Deploy](#-deploy)

---

## 🎯 About the Project

Billing system developed for the Monde selection process, designed to process monthly charges for clients with different payment methods (Boleto, Credit Card, PIX, etc.).

### Problem Solved

The company needs to support several payment methods to receive from its clients, and new methods may arise in the future. The system was developed following the **Open/Closed Principle**, allowing the addition or removal of payment methods without modifying existing code.

### Implemented Requirements

✅ **Client CRUD** with dynamic payment method selection

✅ **Generic Billing Process** that does not know the specific methods

✅ **Extensibility** - New payment methods without changing existing code

✅ **Automated Daily Billing** with Solid Queue

✅ **Guarantees** - Client is not billed twice in the same month

✅ **Error Handling** with automatic retry (3 attempts, 10 min interval)

✅ **Reports** of billed and pending clients

✅ **User Authentication** (bonus)

✅ **Responsive UI** with Tailwind CSS (bonus)

✅ **Rake clients** - Rake task to mass populate clients

✅ **Automated Tests** - 100% coverage with RSpec and Cucumber

---


## 🚀 Features


### 1. Client Management
- Register, edit, view, and delete clients
- Select preferred payment method
- Set due date (1-31)
- Responsive and intuitive interface


### 2. Payment Methods (Strategy Pattern)
- **Boleto** - Generates a fictitious barcode
- **Credit Card** - Simulates card debit
- **Extensible** - New methods added just by creating a new class


### 3. Automated Billing
- Runs daily via Solid Queue
- Processes clients with due date on the current day
- Records attempts and status
- Automatic retry in case of failure


### 4. Reports
- Dashboard with clients billed in the month
- List of clients pending billing
- Filter by period
- Visual status indicators


### 5. Authentication
- Complete login/logout system
- Account creation
- Password recovery via email
- Secure sessions with bcrypt

---


## 🏗 Architecture


### Strategy Pattern


The project implements the **Strategy pattern** to allow multiple payment methods without coupling:

```ruby
# app/services/payment_strategies/base.rb
class PaymentStrategies::Base
  def self.strategies
    # Dynamically loads all available strategies
    descendants.map { |strategy| [strategy.identifier, strategy] }.to_h
  end

  def charge(client)
    raise NotImplementedError
  end
end
```

**How to add a new payment method:**

```ruby
# app/services/payment_strategies/pix_strategy.rb
class PaymentStrategies::PixStrategy < PaymentStrategies::Base
  def charge(client)
    # Implement billing logic via PIX
    { success: true, message: "PIX generated successfully" }
  end
end
```

✨ **No existing code needs to be modified!**


### Billing Flow

```
┌─────────────────────────────────────────────────────────────┐
│  Solid Queue (Recurring Jobs)                               │
│  ├─ Billing::SchedulerJob (runs daily)                      │
│  │   └─ Finds clients with due date = today                 │
│  │                                                         │
│  └─ For each client:                                       │
│      └─ Billing::ChargeClientJob                           │
│          ├─ Checks if already billed this month            │
│          ├─ Selects payment strategy                       │
│          ├─ Executes billing                               │
│          ├─ Creates BillingRecord with status              │
│          └─ On error: automatic retry (3x)                 │
└─────────────────────────────────────────────────────────────┘
```


### Data Models

```
User
├─ email
├─ password_digest
└─ sessions

Client
├─ name
├─ due_day (1-31)
├─ payment_method_identifier
└─ billing_records

BillingRecord
├─ client_id
├─ billed_at
├─ year_month (YYYY-MM)
├─ payment_method_identifier
└─ status (success/failed)
```

---


## 🛠 Technologies


### Backend
- **Ruby 3.2.1** - Language
- **Rails 8.0.4** - Web framework
- **SQLite 3** - Database
- **Solid Queue** - Background jobs (Rails 8 default)
- **Solid Cache** - Cache
- **Solid Cable** - WebSockets


### Frontend
- **Hotwire** - Turbo + Stimulus
- **Tailwind CSS** - CSS framework
- **Importmap** - JavaScript without bundler


### Testing
- **RSpec** - Unit and integration tests
- **Cucumber** - BDD tests
- **Capybara** - System tests
- **Selenium** - Browser automation
- **SimpleCov** - Code coverage (100%)
- **FactoryBot** - Fixtures
- **Faker** - Fake data


### DevOps
- **Docker** - Containerization
- **Docker Compose** - Orchestration
- **Selenium Grid** - Browser testing

---


## 📁 Project Structure

```
teste-ruby-tiago/
├── app/
│   ├── controllers/
│   │   ├── clients_controller.rb          # Client CRUD
│   │   ├── billing_reports_controller.rb  # Reports
│   │   ├── sessions_controller.rb         # Authentication
│   │   └── users_controller.rb            # User registration
│   ├── models/
│   │   ├── client.rb                      # Client model
│   │   ├── billing_record.rb              # Billing record
│   │   └── user.rb                        # System user
│   ├── jobs/
│   │   └── billing/
│   │       ├── scheduler_job.rb           # Schedules daily billings
│   │       └── charge_client_job.rb       # Processes individual billing
│   ├── services/
│   │   ├── billing_report_service.rb      # Generates reports
│   │   └── payment_strategies/
│   │       ├── base.rb                    # Strategy base
│   │       ├── boleto_strategy.rb         # Boleto strategy
│   │       └── credit_card_strategy.rb    # Credit card strategy
│   └── views/
│       ├── clients/                       # CRUD views
│       ├── billing_reports/               # Dashboard
│       └── sessions/                      # Login/Logout
├── spec/                                  # RSpec tests
│   ├── models/
│   ├── controllers/
│   ├── jobs/
│   ├── services/
│   └── system/                            # End-to-end tests
├── features/                              # Cucumber tests
│   └── support/
├── config/
│   ├── recurring.yml                      # Recurring jobs config
│   └── queue.yml                          # Solid Queue config
├── docker-compose.yml                     # Docker orchestration
├── Dockerfile.dev                         # Development image
├── Makefile                               # Command shortcuts
└── README.md                              # This file
```

---


## ✅ Prerequisites


### Option 1: Docker (Recommended)
- **Docker** 20.10+
- **Docker Compose** 2.0+


### Option 2: Local
- **Ruby** 3.2.1
- **Node.js** 18+
- **SQLite** 3
- **Chrome/Chromium** (for tests)

---


## 🚀 Installation and Execution


### With Docker (Recommended)

```bash
# 1. Clone the repository
git clone <repo-url>
cd payment-gateway

# 2. Build the images
make build
# or: docker-compose build

# 3. Start the application (web + worker + selenium)
make up
# or: docker-compose up web worker

# 4. Access in the browser
# http://localhost:3000
```

The application will be running at **http://localhost:3000**

**Available services:**
- 🌐 **Web**: http://localhost:3000
- 🔍 **Selenium VNC**: http://localhost:7900 (password: `secret`)
- 👷 **Worker**: Processing background jobs

### Without Docker (Local)

```bash
# 1. Install dependencies
bundle install

# 2. Create and populate the database
rails db:create db:migrate db:seed

# 3. Start the web server
rails server

# 4. In another terminal, start the worker (jobs)
bundle exec rake solid_queue:start

# 5. Populate clients via task
make populate-clients
# or: bundle exec rake clients:create COUNT=20
# or: bundle exec rake clients:create COUNT=20

```

---


## 🧪 Tests


### RSpec (Unit and Integration Tests)

```bash
make rspec
# or: docker-compose run --rm test

# Specific file
make rspec-file FILE=spec/models/client_spec.rb
# or: docker-compose run --rm test bundle exec rspec spec/models/client_spec.rb

# Without Docker
bundle exec rspec

# With coverage
COVERAGE=true bundle exec rspec
```

**Current coverage: 100%** ✅

### Cucumber (BDD Tests)

```bash
# With Docker
make cucumber
# or: docker-compose run --rm cucumber

# Specific feature
make cucumber-file FILE=features/billing.feature
# or: docker-compose run --rm cucumber bundle exec cucumber features/billing.feature

# Without Docker
bundle exec cucumber
```


### View Tests in Browser

During the execution of tests with Selenium, you can view them in real-time:

1. Access http://localhost:7900
2. Password: `secret`
3. See the tests being executed in the browser


### Coverage Report

After running the tests, open the report:
```bash
open coverage/index.html
```

---


## 👷 Background Jobs


The system uses **Solid Queue** (Rails 8 default) to process billings in the background.


### Configured Jobs


**1. Billing::SchedulerJob**
- **Frequency**: Every 1 minute (development) / Daily at 12pm (production)
- **Function**: Finds clients with due date today and enqueues billings


**2. Billing::ChargeClientJob**
- **Function**: Processes individual client billing
- **Retry**: 3 attempts with 10-minute intervals
- **Guarantee**: Does not bill the same client twice in the month


### Manage Jobs

```bash
# View worker logs in real-time
make logs-worker

# Trigger job manually (without waiting for scheduling)
make jobs-trigger

# Check queue status
make jobs-status

# List all pending jobs
docker-compose exec web rails runner "puts SolidQueue::Job.where(finished_at: nil).count"
```


### Configuration


**config/recurring.yml** - Scheduled jobs
```yaml
development:
  periodic_cleanup:
    class: Billing::SchedulerJob
    queue: background
    schedule: "*/1 * * * *"  # Every 1 minute
```


**config/queue.yml** - Worker configuration
```yaml
workers:
  - queues: "*"
    threads: 3
    processes: 1
    polling_interval: 0.1
```

---


## 📊 Application Usage


### 1. Create Account / Login

Access http://localhost:3000 and create an account or log in.


### 2. Register Clients

1. Go to **Clients** in the menu
2. Click on **New Client**
3. Fill in:
   - Client name
   - Due day (1-31)
   - Payment method
4. Save


### 3. View Reports

1. Go to **Billing Reports** in the menu
2. See:
   - Clients billed in the current month
   - Clients pending billing
   - Payment method used
   - Date of last billing


### 4. Process Billing

Billing is automatically processed by the worker, but you can trigger it manually:

```bash
make jobs-trigger
```

---


## 🐳 Useful Docker Commands

```bash
# See all available commands
make help

# Stop containers
make down

# Access Rails console
make console

# Run migrations
make db-migrate

# Access container shell
make shell

# View logs
make logs

# Clean everything (careful!)
make clean
```

---


## 📝 License

This project was developed as a technical test for Monde.

---


## 👨‍💻 Author

**Tiago Leal**

- GitHub: [@tiagoleal](https://github.com/tiagoleal)

---
