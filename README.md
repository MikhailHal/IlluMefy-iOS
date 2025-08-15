# IlluMefy
## Status
[![CI](https://github.com/MikhailHal/IlluMefy-iOS/actions/workflows/ci.yml/badge.svg)](https://github.com/MikhailHal/IlluMefy-iOS/actions/workflows/ci.yml)

## Demo(These are just mock data NOT REAL!!)
https://github.com/user-attachments/assets/87cac2e9-ee4d-47e4-9821-370c3c88ad3f

## 🛠️ Development Setup

### Prerequisites
- macOS 13.0 or later
- Xcode 16.2 or later
- Ruby (for CocoaPods if needed)
- Homebrew (for SwiftGen installation)

### Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/MikhailHal/IlluMefy-iOS.git
   cd IlluMefy-iOS
   ```

2. **Install SwiftGen**
   ```bash
   brew install swiftgen
   ```

3. **Open the project in Xcode**
   ```bash
   cd IlluMefy
   open IlluMefy.xcodeproj
   ```

4. **Build and Run**
   - Select your target device/simulator
   - Press `Cmd + R` to build and run

### Running Tests

```bash
# Run all tests
xcodebuild test -scheme IlluMefy -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test suite
xcodebuild test -scheme IlluMefy -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:IlluMefyTests/PhoneAuthRepositorySpec
```

## What's this app?
IlluMefy is a cross-platform mobile application (iOS/Android) developed by MikhailHal.  
It helps users discover gaming creators through community-driven tagging (folksonomy).  
Its key feature is allowing users to add tags to creators, creating a collective intelligence system for finding content creators.  
The reason for developing it is to offer more authentic, personalized ways to discover creators beyond algorithmic recommendations.  
Discovery Through Community Wisdom
IlluMefy harnesses the power of folksonomy - a collaborative tagging system where users collectively categorize content. The name "IlluMefy" combines "Illuminate" (to shed light on) with "Me" and "-fy" (to extend to others), reflecting our mission to illuminate both your preferences and the wider community's wisdom.

## 🌟 Key Features

* Folksonomy-Based Discovery: Find gaming creators based on community tags, not algorithms or paid promotions
* Personalized Recommendations: Discover content creators who match your specific interests and play style
* Community-Driven Tags: Add meaningful tags to creators and help others find exactly what they're looking for
* Tag Exploration: Browse popular tags to discover new creators across different games, styles, and content types
* Intuitive Interface: Navigate seamlessly through our clean, modern design in both light and dark modes

## 🚀 Our Vision
IlluMefy is more than just an app - it's a movement toward more authentic, community-driven content discovery. We believe in offering continuous excellent experiences to people around the world through our own technologies.

## 🔍 Current Status
IlluMefy has been developing by MikhailHal.  
I will launch this app as beta version soon!!

## What are used in this app?
### Basic Information
IDE: Xcode(Ver 16.2)  
Language: Swift 5(I wouldn't update to Swift 6 unless I can work around SwiftGen's compatibility issues.)  
Architecture: Clean Architecture+Router  
Package Manager: SPM(Swift Package Manager)  
Static Analysis: SwiftLint  
CI/CD: GitHubActions

### Capabilities
* BackgroundModes
* Push Notifications
### Libraries
#### UI
* SwiftUI  
* SwiftfulLoadingIndicators  
* SwiftUI Shimmer
* WrappingHStack
#### Logic
##### Firebase
* Firebase Authentication  
* Firebase Cloud Functions  
* Firebase Clashlytics  
* Firebase Analytics  
* Firebase Storage
##### Resources
* SwiftGen
##### Logic Test
* Quick
* Nimble
##### UI Test
* hogehoge
##### Other
* Combine

### Architecture
To know them, please check [architecure.md](https://github.com/MikhailHal/IlluMefy-iOS/blob/main/IlluMefy/docs/architecture.md)

## 🤝 Contributing

We welcome contributions to IlluMefy! Here's how you can help:

### How to Contribute

1. **Fork the repository**
   - Click the "Fork" button at the top of this repository

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the existing code style and architecture patterns
   - Add tests for new functionality
   - Update documentation as needed

4. **Run tests**
   ```bash
   xcodebuild test -scheme IlluMefy -destination 'platform=iOS Simulator,name=iPhone 15'
   ```

5. **Commit your changes**
   ```bash
   git commit -m "feat: Add your feature description"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Select your fork and branch
   - Describe your changes in detail

### Code Guidelines

- Follow Clean Architecture principles
- Use SwiftLint rules defined in the project
- Write unit tests for new features
- Keep commits atomic and well-described
- Update documentation for API changes

### Reporting Issues

- Use GitHub Issues to report bugs
- Include detailed steps to reproduce
- Attach screenshots if applicable
- Mention your iOS version and device

## Related URL
・[Google Cloud](https://github.com/aoi-stella/Nimli-GoogleCloud)  
・[iOS](https://github.com/aoi-stella/Nimli-iOS)
