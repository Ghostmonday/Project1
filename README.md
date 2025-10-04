# NeurospLIT - Fair Tip Splitting with AI

> iOS app for service industry professionals | SwiftUI | StoreKit 2 | AI-Powered

[![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://www.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![CI](https://img.shields.io/github/workflow/status/yourname/neurosplit/CI)](https://github.com/yourname/neurosplit/actions)

**Bundle ID:** `net.neuraldraft.NeurospLIT`  
**Version:** 1.0  
**iOS:** 16.0+

---

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/yourname/neurosplit.git
cd neurosplit

# 2. Setup (creates API key config file)
make setup

# 3. Add your API keys to Configs/Secrets.xcconfig
# Edit the file and replace placeholders with real keys

# 4. Build and run
make build
make test      # Optional: run tests

# 5. Open in Xcode
open NeurospLIT.xcodeproj
# Press ⌘R to run
```

---

## Features

### Core Functionality
- 🤖 **AI-Powered Onboarding** - Describe tip rules in plain English
- 📊 **Multiple Calculation Methods** - Equal, hours-based, percentage, role-weighted
- 📈 **Visual Breakdowns** - Charts and detailed split views
- 💾 **Template System** - Save and reuse configurations
- 📱 **iOS Native** - Built with SwiftUI

### Business Features
- 💳 **StoreKit 2 Integration** - Subscriptions and in-app purchases
- 🪙 **WhipCoins System** - Purchase credits for AI template generation
- 🎁 **Referral Program** - Trial extensions via referrals
- 🔐 **Secure Storage** - Keychain-based credential storage

### Technical Features
- 🌐 **Network Resilience** - Automatic retry with exponential backoff
- ♿ **Accessibility** - VoiceOver support, Dynamic Type
- 📊 **Performance Monitoring** - Memory and launch time tracking
- 🧪 **Comprehensive Tests** - Unit, integration, and UI tests
- 🔒 **Privacy First** - No data collection, local storage only

---

## Project Structure

```
NeurospLIT/                    # Main application source
├── Application/               # App entry point (@main)
│   └── NeurospLITApp.swift   # Monolithic app file (4,300+ lines)
├── Models/                    # Data models
│   ├── Domain/                # Core business entities
│   │   └── Models.swift       # TipTemplate, Participant, etc.
│   └── Supporting/            # Supporting types
│       └── Errors.swift       # WhipCoreError
├── Views/                     # SwiftUI views
│   ├── Onboarding/            # AI-powered onboarding flow
│   │   └── ClaudeOnboardingView.swift
│   └── Components/            # Reusable UI components
│       └── ErrorView.swift
├── Services/                  # Business logic
│   ├── API/                   # External API integrations
│   │   └── ClaudeService.swift
│   └── Storage/               # Data persistence
│       └── Persistence.swift
├── Engine/                    # Tip calculation algorithms
│   ├── Engine.swift           # Core split logic
│   └── EngineHarness.swift    # Test harness
├── Utilities/                 # Helpers and extensions
│   └── Helpers/
│       ├── AccessibilityHelpers.swift
│       ├── PerformanceMonitor.swift
│       └── TemplateUtilities.swift
└── Resources/                 # Assets
    └── Assets.xcassets/

NeurospLITTests/               # Test suite
├── ServiceTests/              # Service layer tests (7 files)
├── EngineTests/               # Calculation logic tests
├── ViewTests/                 # UI flow tests
└── Mocks/                     # Test doubles
```

---

## Development

### Requirements

- **Xcode**: 15.0+
- **macOS**: for development
- **iOS Deployment Target**: 16.0+
- **Apple Developer Account**: for device testing

### Configuration

API keys are stored in `Configs/Secrets.xcconfig`:

```xcconfig
DEEPSEEK_API_KEY = sk-your-deepseek-key-here
CLAUDE_API_KEY = sk-ant-your-claude-key-here
```

Get API keys:
- **DeepSeek**: https://platform.deepseek.com
- **Claude**: https://console.anthropic.com

### Build Commands

```bash
make setup        # First-time setup
make build        # Build the app
make test         # Run all tests
make clean        # Clean build artifacts
make healthcheck  # Run project health check
make open         # Open in Xcode
```

### Architecture

Clean architecture with clear dependency hierarchy:

```
Level 0: Models + Utilities (no dependencies)
    ↓
Level 1: Engine (uses Models)
    ↓
Level 2: Services (uses Models + Engine)
    ↓
Level 3: Views (uses Services)
    ↓
Level 4: Application (coordinates everything)
```

**Design Note**: `NeurospLITApp.swift` is a monolithic file containing AppLogger, KeychainService, NetworkMonitor, and all core services. This is an intentional design pattern for simplified dependency management.

---

## Testing

```bash
# Run all tests
make test

# Or in Xcode
⌘U
```

Test coverage:
- **ServiceTests/** - API clients, storage, managers (7 test files)
- **EngineTests/** - Calculation algorithms
- **ViewTests/** - UI flows and navigation
- **Mocks/** - Test doubles for external dependencies

All tests use `@testable import NeurospLIT`.

---

## Contributing

### Adding New Features

**1. Add Model (if needed):**
```swift
// NeurospLIT/Models/Domain/YourModel.swift
public struct YourModel: Codable {
    public let id: UUID
    public let name: String
}
```

**2. Add Service (if needed):**
```swift
// NeurospLIT/Services/[API|Storage]/YourService.swift
@MainActor
final class YourService: ObservableObject {
    @Published var state: State = .idle
}
```

**3. Add View:**
```swift
// NeurospLIT/Views/[Feature]/YourView.swift
struct YourView: View {
    @StateObject private var service = YourService()
    
    var body: some View {
        // Implementation
    }
}
```

**4. Add Tests:**
```swift
// NeurospLITTests/ServiceTests/YourServiceTests.swift
@testable import NeurospLIT
import XCTest

final class YourServiceTests: XCTestCase {
    func testFeature() async throws {
        // Test implementation
    }
}
```

### Code Style

- Use SwiftUI for all UI
- Mark services with `@MainActor` where appropriate
- Use `async/await` for asynchronous operations
- Follow clean architecture principles
- Add tests for all new features

---

## Troubleshooting

### Build Fails

**"Cannot find Secrets.xcconfig"**
```bash
make setup
```

**"No such file or directory: Models.swift"**
- Verify `NeurospLIT/Models/Domain/Models.swift` exists
- Clean build: `⌘⇧K` then `⌘B`

### Tests Fail

**"Cannot find module 'NeurospLIT'"**
- Check target membership in File Inspector
- Ensure NeurospLITTests target depends on NeurospLIT

### Runtime Issues

**App crashes with API errors**
- Ensure `Configs/Secrets.xcconfig` has real API keys (not placeholders)
- Check network connectivity

---

## CI/CD

Automated builds run on every push via GitHub Actions:
- Builds project for iOS Simulator
- Runs all unit tests
- Uploads logs on failure

See `.github/workflows/ci.yml` for configuration.

---

## App Store Submission

### Checklist

- ✅ Bundle ID: `net.neuraldraft.NeurospLIT`
- ✅ Version: 1.0
- ✅ Deployment target: iOS 16.0+
- ✅ Privacy manifest configured
- ✅ App icons configured
- ✅ Build succeeds without warnings
- ⏳ Tests pass (configure test target)
- ⏳ Development team selected
- ⏳ Screenshots prepared
- ⏳ App Store description written

### Build Archive

```bash
make archive
```

Then upload via Xcode or Transporter app.

---

## Dependencies

### External
- **None** - fully self-contained native iOS app

### System Frameworks
- SwiftUI - modern declarative UI
- StoreKit 2 - subscriptions and purchases
- Combine - reactive programming
- Network - connectivity monitoring
- Security - Keychain access

---

## License

Proprietary - All rights reserved

---

## Documentation

- **`Documentation/`** - Detailed architecture and design docs
- **`Scripts/healthcheck.sh`** - Project health verification
- **`FIX_THIS_PROJECT.md`** - Setup and troubleshooting guide

---

## Status

- ✅ Core tip calculation engine
- ✅ AI-powered onboarding
- ✅ StoreKit 2 integration
- ✅ Network resilience
- ✅ Accessibility support
- ✅ Performance monitoring
- ✅ Security (Keychain)
- ✅ Clean project structure
- ✅ **BUILD SUCCEEDS**
- ⏳ Test suite (needs test target configuration)
- ⏳ App Store submission

---

**Ready to develop?** Run `make setup && make build` to get started! 🚀
