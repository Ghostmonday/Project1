# NeurospLIT - Architecture

## Overview

NeurospLIT is an iOS app for fair tip splitting using AI-powered onboarding.

## Structure

```
NeurospLIT/
├── Application/        App entry point (monolithic)
├── Models/            Data models
├── Views/             SwiftUI views
├── Services/          Business logic
├── Engine/            Tip calculation
├── Utilities/         Helpers
└── Resources/         Assets

NeurospLITTests/       Test suite
```

## Dependency Hierarchy

```
Models (Level 0)
    ↓
Engine (Level 1)
    ↓
Services (Level 2)
    ↓
Views (Level 3)
    ↓
Application (Level 4)
```

## Key Components

- **NeurospLITApp.swift** - Monolithic app file containing all services
- **Engine.swift** - Tip calculation algorithms
- **ClaudeService.swift** - AI integration
- **Models.swift** - Core data models

## Technologies

- SwiftUI
- StoreKit 2
- Combine
- async/await
- Keychain

