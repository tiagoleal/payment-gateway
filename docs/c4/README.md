 # C4 Diagrams - Multi-Payment Billing System

This directory contains the C4 architecture diagrams of the Billing System in PlantUML format.

## About C4

The C4 model (Context, Containers, Components, Code) is a hierarchical approach to documenting software architecture, created by Simon Brown. Each level provides a progressively more detailed view of the system.

## Available Diagrams

### 1. C1 - System Context Diagram
**File**: `billing-system-c1.puml`

High-level view showing the system and its interactions with users and external systems.

**Main elements**:
- System User (administrator)
- Billing System
- Email System (external)
- Payment Gateway (external)

### 2. C2 - Container Diagram
**File**: `billing-system-c2.puml`

Shows the main containers (applications/services) that make up the system.

**Containers**:
- **Web Application**: Rails 8.0.4 with Hotwire and Tailwind CSS
- **Background Worker**: Solid Queue for asynchronous processing
- **Database**: SQLite 3 for persistence
- **Queue System**: Solid Queue for queue management
- **Cache System**: Solid Cache for optimization

### 3. C3 - Component Diagram
**File**: `billing-system-c3.puml`

Details the internal components of the Web Application.

**Main components**:
- **Controllers**: Clients, Billing Reports, Sessions, Users
- **Models**: Client, BillingRecord, User
- **Services**: Billing Report Service, Payment Strategies
- **Jobs**: Scheduler Job, Charge Client Job

### 4. C4 - Code Diagram
**File**: `billing-system-c4.puml`

Focuses on the implementation of the Strategy Pattern for payment methods.

**Main classes**:
- `PaymentStrategies::Base` (abstract strategy)
- `PaymentStrategies::BoletoStrategy` (concrete implementation)
- `PaymentStrategies::CreditCardStrategy` (concrete implementation)
- `PaymentStrategies::PixStrategy` (extensibility example)

## How to View the Diagrams

### Option 1: VS Code (Recommended)
1. Install the **PlantUML** extension in VS Code
2. Open any `.puml` file
3. Press `Alt+D` (or use Command Palette: "PlantUML: Preview Current Diagram")

### Option 2: Online
1. Go to [PlantUML Online Editor](http://www.plantuml.com/plantuml/uml/)
2. Paste the contents of the `.puml` file
3. View the generated diagram

### Option 3: CLI with Docker
```bash
# Generate PNG for a specific diagram
docker run --rm -v $(pwd):/data plantuml/plantuml billing-system-c1.puml

# Generate all diagrams
docker run --rm -v $(pwd):/data plantuml/plantuml *.puml
```

### Option 4: Local PlantUML
```bash
# Install PlantUML (requires Java)

# or
sudo apt install plantuml  # Linux

# Generate diagram
plantuml billing-system-c1.puml
```

## Diagram Features

### Language
- **Descriptive texts**: English only
- **Technical terms**: English (Service, Container, Component, Strategy, Job, Queue, etc.)

### Highlighted Technologies
- Ruby on Rails 8.0.4
- Solid Queue (background jobs)
- SQLite 3
- Hotwire (Turbo + Stimulus)
- Tailwind CSS
- Strategy Pattern (Open/Closed Principle)

### Key Highlights

#### Strategy Pattern (C4)
The code diagram clearly demonstrates:
- How to add new payment methods without modifying existing code
- Dynamic discovery of strategies via reflection
- Polymorphism in billing execution
- Compliance with Open/Closed Principle (SOLID)

#### Background Jobs (C2, C3)
- **SchedulerJob**: Runs daily, finds clients by due date
- **ChargeClientJob**: Processes individual billing with automatic retry (3x)
- Guarantee not to bill the same client twice in a month

#### Authentication (C3)
- Complete login/logout system
- Password recovery via email
- Secure sessions with bcrypt

## Export Diagrams

### PNG
```bash
plantuml -tpng *.puml
```

### SVG (Scalable)
```bash
plantuml -tsvg *.puml
```

### PDF
```bash
plantuml -tpdf *.puml
```

## Update Diagrams

When modifying the system architecture, update the corresponding diagrams:

1. **New components**: Add to C3
2. **New containers**: Add to C2
3. **New external integrations**: Add to C1
4. **New payment strategies**: Add to C4

## References

- [C4 Model](https://c4model.com/) - Official site
- [C4-PlantUML](https://github.com/plantuml-stdlib/C4-PlantUML) - Library used
- [PlantUML](https://plantuml.com/) - Diagramming tool
- [Strategy Pattern](https://refactoring.guru/design-patterns/strategy) - Implemented design pattern

## Contributing

When adding new diagrams:
1. Follow the naming convention: `billing-system-c[1-4].puml`
2. Keep descriptive texts in English and technical terms in English
3. Use the same C4-PlantUML includes
4. Add explanatory notes when necessary
5. Update this README

---

**Generated for**: Multi-Payment Billing System
**Date**: 2025-12-13
**Version**: 1.0
