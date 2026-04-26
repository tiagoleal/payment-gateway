
# Documentation Index - C4 Architecture

## Available Files

### 📊 PlantUML Diagrams

| File | Level | Description | Focus |
|---------|-------|-----------|------|
| [billing-system-c1.puml](billing-system-c1.puml) | **C1 - Context** | System Context | Overview, users, and external systems |
| [billing-system-c2.puml](billing-system-c2.puml) | **C2 - Container** | Containers | Web App, Worker, Database, Queue, Cache |
| [billing-system-c3.puml](billing-system-c3.puml) | **C3 - Component** | Components | Controllers, Models, Services, Jobs |
| [billing-system-c4.puml](billing-system-c4.puml) | **C4 - Code** | Code | Strategy Pattern for payment methods |

### 📖 Documentation

| File | Description |
|---------|-----------|
| [README.md](README.md) | Complete guide to using the C4 diagrams |
| [ARCHITECTURE_OVERVIEW.md](ARCHITECTURE_OVERVIEW.md) | Detailed view of the 4-level architecture |
| [INDEX.md](INDEX.md) | This file - navigation index |

---

## Quick Navigation Guide

### 1️⃣ Getting Started Understanding the System
**Read first**: [billing-system-c1.puml](billing-system-c1.puml)

Understand who uses the system and which external systems it communicates with.

### 2️⃣ Understanding the Infrastructure
**Read next**: [billing-system-c2.puml](billing-system-c2.puml)

See which containers (applications) make up the system and how they communicate.

### 3️⃣ Understanding the Internal Components
**Read after**: [billing-system-c3.puml](billing-system-c3.puml)

Explore the internal components of the Web Application: controllers, models, services, and jobs.

### 4️⃣ Understanding the Strategy Pattern
**Read last**: [billing-system-c4.puml](billing-system-c4.puml)

Understand how the system implements multiple payment methods using the Strategy Pattern.

---

## Frequently Asked Questions

### How to view the diagrams?

**Option 1 - VS Code** (Recommended):
1. Install the "PlantUML" extension
2. Open the `.puml` file
3. Press `Alt+D`

**Option 2 - Online**:
1. Go to http://www.plantuml.com/plantuml/uml/
2. Paste the file content
3. View


More details: [README.md](README.md)

### Why use C4?

The C4 model provides a hierarchy of diagrams that allows you to:
- Understand the system at different levels of detail
- Communicate architecture to different audiences (stakeholders, developers, etc.)
- Document architectural decisions visually
- Facilitate onboarding of new developers

### What is the difference between the levels?

| Level | Target Audience | Detail | Analogy |
|-------|----------------|--------|---------|
| **C1** | Stakeholders, Product Managers | Low | Satellite view of the city |
| **C2** | Architects, DevOps | Medium | Neighborhood map |
| **C3** | Senior Developers | High | Street map |
| **C4** | Developers | Very High | Building floor plan |

### How to update the diagrams?

1. Edit the corresponding `.puml` file
2. Save the changes
3. Visualize again to validate
4. Commit to Git

**Important**: Keep the diagrams synchronized with the code!

---

## Diagram Structure

### C1 - System Context
```
┌─────────────────────────────────────┐
│  Users                              │
│  ├─ System User                     │
│                                     │
│  System                             │
│  ├─ Billing System                  │
│                                     │
│  External Systems                   │
│  ├─ Email System                    │
│  └─ Payment Gateway                 │
└─────────────────────────────────────┘
```

### C2 - Container
```
┌─────────────────────────────────────┐
│  Billing System                     │
│  ├─ Web Application (Rails)         │
│  ├─ Background Worker (Solid Queue) │
│  ├─ Database (SQLite)               │
│  ├─ Queue System (Solid Queue)      │
│  └─ Cache System (Solid Cache)      │
└─────────────────────────────────────┘
```

### C3 - Component
```
┌─────────────────────────────────────┐
│  Web Application                    │
│  ├─ Controllers                     │
│  │   ├─ ClientsController           │
│  │   ├─ BillingReportsController    │
│  │   ├─ SessionsController          │
│  │   └─ UsersController             │
│  ├─ Models                          │
│  │   ├─ Client                      │
│  │   ├─ BillingRecord               │
│  │   └─ User                        │
│  ├─ Services                        │
│  │   ├─ BillingReportService        │
│  │   └─ PaymentStrategies           │
│  └─ Jobs                            │
│      ├─ Billing::SchedulerJob       │
│      └─ Billing::ChargeClientJob    │
└─────────────────────────────────────┘
```

### C4 - Code
```
┌─────────────────────────────────────┐
│  PaymentStrategies Package          │
│  ├─ Base (Abstract)                 │
│  │   ├─ strategies()                │
│  │   └─ charge(client)              │
│  ├─ BoletoStrategy (Concrete)       │
│  │   └─ charge(client)              │
│  ├─ CreditCardStrategy (Concrete)   │
│  │   └─ charge(client)              │
│  └─ PixStrategy (Concrete)          │
│      └─ charge(client)              │
└─────────────────────────────────────┘
```

---

## Architectural Highlights

### ✨ Strategy Pattern (Open/Closed Principle)

The system uses the Strategy Pattern to support multiple payment methods:

**Benefits**:
- ✅ Add new methods WITHOUT modifying existing code
- ✅ Each strategy is tested in isolation
- ✅ Automatic discovery of strategies via reflection
- ✅ Pure polymorphism

**See in**: [billing-system-c4.puml](billing-system-c4.puml)

### 🔄 Background Jobs (Solid Queue)

Asynchronous billing processing:

**Jobs**:
- **SchedulerJob**: Daily (12h prod / 1min dev)
- **ChargeClientJob**: On-demand with retry (3x, 10min)

**Guarantees**:
- Does not bill the same client twice in the same month
- Automatic retry on failures
- Failure isolation between clients

**See in**: [billing-system-c3.puml](billing-system-c3.puml)

### 🔒 Secure Authentication

Complete login/logout system:

**Features**:
- Secure sessions with bcrypt
- Password recovery via email
- New user registration

**See in**: [billing-system-c3.puml](billing-system-c3.puml)

---

## Technologies by Level

### C1 - Integrations
- HTTPS (web interface)
- SMTP (emails)
- REST API (payment gateways)

### C2 - Infrastructure
- **Backend**: Ruby 3.2.1, Rails 8.0.4
- **Database**: SQLite 3
- **Jobs**: Solid Queue
- **Cache**: Solid Cache
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS

### C3 - Frameworks
- **MVC**: Rails ActiveRecord, ActionController, ActionView
- **Background**: Solid Queue recurring jobs
- **Testing**: RSpec, Cucumber, Capybara, Selenium

### C4 - Patterns
- **Strategy Pattern**: Multiple interchangeable algorithms
- **SOLID**: Open/Closed Principle
- **Reflection**: Automatic discovery of strategies

---

## Quality Metrics

| Metric | Value | Diagram |
|--------|-------|---------|
| **Test Coverage** | 100% | C3, C4 |
| **Number of Containers** | 5 | C2 |
| **Number of Components** | 11 | C3 |
| **Payment Strategies** | 3 (extensible) | C4 |
| **SOLID Compliance** | ✅ Open/Closed | C4 |

---

## Next Steps

### For New Developers

1. ✅ Read [ARCHITECTURE_OVERVIEW.md](ARCHITECTURE_OVERVIEW.md)
2. ✅ View the diagrams in order (C1 → C2 → C3 → C4)
3. ✅ Read the code following the diagram flow
4. ✅ Run the tests to validate understanding

### For Architects

1. ✅ Review architectural decisions in [ARCHITECTURE_OVERVIEW.md](ARCHITECTURE_OVERVIEW.md)
2. ✅ Validate if the diagrams reflect the current code
3. ✅ Propose improvements while maintaining SOLID principles
4. ✅ Update diagrams as the system evolves

### For Stakeholders

1. ✅ Start with C1 for an overview
2. ✅ Read the executive summary in [ARCHITECTURE_OVERVIEW.md](ARCHITECTURE_OVERVIEW.md)
3. ✅ Focus on system guarantees (no duplication, retry)
4. ✅ Understand extensibility (new payment methods)

---

## External References

- 📚 [C4 Model Official Site](https://c4model.com/)
- 🎨 [PlantUML Documentation](https://plantuml.com/)
- 🧩 [C4-PlantUML Library](https://github.com/plantuml-stdlib/C4-PlantUML)
- 🏗️ [Strategy Pattern](https://refactoring.guru/design-patterns/strategy)
- 💎 [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- ⚡ [Solid Queue GitHub](https://github.com/rails/solid_queue)

---

## Contributing

When adding or modifying diagrams:

1. ✅ Keep texts in **Portuguese** (with accents)
2. ✅ Keep technical terms in **English**
3. ✅ Use the same C4-PlantUML includes
4. ✅ Add explanatory notes when necessary
5. ✅ Update this INDEX.md
6. ✅ Update ARCHITECTURE_OVERVIEW.md if relevant

---

## Contact

**Questions about the architecture?**
- Open an issue in the repository
- Check the main project README.md
- Review the tests (spec/) to understand behaviors

---

**Last update**: 2025-12-13
**Version**: 1.0
**Status**: ✅ Complete and synchronized with the code
