# Streamify 📱

A modern iOS streaming platform for video and audio content, built with SwiftUI and following Apple's latest design guidelines.

## 🎯 Overview

Streamify is a professional streaming application that provides users with a clean, intuitive interface to discover and consume video and audio content. The app features a modern design inspired by industry-leading platforms, with emphasis on clean typography, balanced spacing, and excellent user experience.

## ✨ Features

### 🎬 Content Streaming
- **Video Streaming**: High-quality video playback with modern AVKit integration
- **Audio Streaming**: Seamless audio playback with background support
- **Multiple Formats**: Support for various media formats and resolutions

### 🏠 Home Experience
- **Featured Content**: Curated selection of trending videos and music
- **Category Tabs**: Organized content by Featured, Music, Gaming, and Education
- **Hero Section**: Prominent display of featured content with rich metadata

### 🔍 Smart Search
- **Intelligent Search**: Fast and accurate content discovery
- **Category Filters**: Refine results by content type
- **Recent Searches**: Quick access to previously viewed content

### 👤 User Management
- **Sign In with Apple**: Secure authentication using Apple's ecosystem
- **Guest Mode**: Access content without account creation
- **CloudKit Integration**: Seamless data synchronization across devices

### 📱 Modern UI/UX
- **SwiftUI**: Built entirely with Apple's modern UI framework
- **Clean Design**: Airbnb-inspired professional aesthetics
- **Responsive Layout**: Optimized for all iOS device sizes
- **Dark Mode Support**: Automatic theme adaptation

## 🛠 Technical Stack

### Core Technologies
- **SwiftUI 5.0**: Modern declarative UI framework
- **iOS 17.5+**: Latest iOS features and capabilities
- **Xcode 16**: Latest development tools and SDKs

### Frameworks & Libraries
- **AVKit & AVFoundation**: Media playback and management
- **CloudKit**: User data synchronization
- **AuthenticationServices**: Apple Sign In integration
- **GoogleMobileAds**: Monetization through AdMob

### Architecture
- **MVVM Pattern**: Clean separation of concerns
- **ObservableObject**: Reactive state management
- **EnvironmentObject**: Dependency injection
- **Modular Design**: Organized code structure

## 📁 Project Structure

```
Streamify/
├── App/
│   └── Modules/
│       ├── Assets/                 # App icons, colors, and resources
│       ├── ContentView.swift       # Main navigation and tab structure
│       ├── Home/                   # Home screen and content display
│       │   ├── HomeView.swift      # Main home interface
│       │   ├── HomeModel.swift     # Home data management
│       │   ├── PlaylistView.swift  # Playlist display
│       │   ├── Search/             # Search functionality
│       │   │   ├── SearchView.swift    # Search interface
│       │   │   └── SearchModel.swift   # Search logic
│       │   └── Video/              # Video-related components
│       │       └── VideoModel.swift    # Video data and playback
│       ├── Onboard/                # User onboarding and authentication
│       │   ├── OnboardView.swift   # Welcome screen
│       │   ├── OnboardModel.swift  # Onboarding logic
│       │   └── Sign In/            # Authentication
│       │       ├── SignInView.swift    # Sign in interface
│       │       └── SignInModel.swift   # Authentication logic
│       ├── Settings/                # App settings and configuration
│       │   ├── SettingsView.swift  # Settings interface
│       │   ├── SettingsModel.swift # Settings management
│       │   ├── SettingsSubTabs.swift # Settings navigation
│       │   ├── Account/            # Account management
│       │   │   └── Deletion/       # Account deletion
│       │   │       ├── DeletionView.swift
│       │   │       └── DeletionModel.swift
│       │   └── FeedbackSupport.swift # User feedback system
│       ├── StreamifyApp.swift      # App entry point
│       └── Ads/                    # Advertising integration
│           ├── AdMobModel.swift    # AdMob configuration
│           ├── GADNativeViewController.swift # Native ad display
│           └── GADNativeViewWrapper.swift   # Ad wrapper components
├── Streamify.xcodeproj/            # Xcode project file
├── Streamify-Info.plist            # App configuration
└── Streamify.entitlements          # App capabilities and permissions
```

## 🚀 Getting Started

### Prerequisites
- **Xcode 16.0+** (Latest version recommended)
- **iOS 17.5+** deployment target
- **macOS 14.0+** for development
- **Apple Developer Account** (for device testing and distribution)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/Streamify.git
   cd Streamify
   ```

2. **Open in Xcode**
   ```bash
   open Streamify.xcodeproj
   ```

3. **Configure signing**
   - Select your team in the project settings
   - Update bundle identifier if needed
   - Ensure proper provisioning profiles

4. **Build and run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### Dependencies

The project uses Swift Package Manager for dependencies:

- **GoogleMobileAds**: AdMob integration for monetization
- **GoogleUserMessagingPlatform**: User consent management

Dependencies are automatically resolved when opening the project in Xcode.

## 🎨 Design System

### Typography
- **Headings**: `.title`, `.title2`, `.title3` with `.semibold` weight
- **Body Text**: `.body`, `.subheadline` with `.medium` weight
- **Captions**: `.caption`, `.caption2` for metadata

### Spacing
- **Small**: 8px (internal component spacing)
- **Medium**: 16px (component margins)
- **Large**: 20px (section spacing)
- **Extra Large**: 32px (major section separation)

### Colors
- **Primary**: System primary color for main content
- **Secondary**: System secondary color for supporting text
- **Background**: System background colors with proper contrast
- **Accent**: Blue accent for interactive elements

### Shadows & Corners
- **Subtle Shadows**: 8px radius with low opacity for depth
- **Rounded Corners**: 12px, 16px, 20px for different component types
- **Clean Borders**: Minimal use of borders for definition

## 🔧 Configuration

### App Capabilities
- **CloudKit**: User data synchronization
- **Sign In with Apple**: Secure authentication
- **Background Audio**: Continuous audio playback
- **AdMob Integration**: Monetization support

### Info.plist Settings
- **Privacy Descriptions**: Camera, microphone, and photo library access
- **Supported Orientations**: Portrait and landscape support
- **Background Modes**: Audio playback and background fetch

## 📱 Supported Devices

- **iPhone**: iOS 17.5+ on iPhone 12 and newer
- **iPad**: iOS 17.5+ on iPad Air (4th gen) and newer
- **Simulator**: Xcode Simulator for development and testing

## 🧪 Testing

### Unit Tests
- Model layer testing
- Business logic validation
- Data transformation testing

### UI Tests
- User flow validation
- Accessibility testing
- Cross-device compatibility

### Manual Testing
- Device-specific testing
- Performance validation
- User experience testing

## 🚀 Deployment

### Development
- Use Xcode's built-in simulator for rapid development
- Test on physical devices for accurate performance metrics
- Enable development signing for local testing

### Distribution
- Archive the project for App Store distribution
- Configure production signing certificates
- Test with TestFlight before public release

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Swift API Design Guidelines
- Use SwiftLint for consistent formatting
- Write clear, descriptive commit messages
- Include appropriate documentation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Apple**: For SwiftUI and iOS development tools
- **Google**: For AdMob integration and monetization
- **Design Inspiration**: Airbnb and other leading platforms for UI/UX guidance

## 📞 Support

For support and questions:
- **Issues**: Create an issue in the GitHub repository
- **Documentation**: Check the inline code documentation

---

*Last updated: August 2024*
