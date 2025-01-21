# Braver Search

A Safari extension that automatically redirects searches to Brave Search, providing a more private search experience.

> **Disclaimer**: Braver Search is an independent Safari extension and is not affiliated with, endorsed by, or connected to Brave Software Inc. This is a third-party tool created to enhance the user experience of [Brave Search](https://search.brave.com) within Safari, which is a trademark of Brave Software Inc.

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Support-yellow.svg?style=flat&logo=buy-me-a-coffee)](https://www.buymeacoffee.com/btbishop93)
[![App Store](https://img.shields.io/badge/Download%20on%20the-App%20Store-blue.svg?style=flat&logo=app-store&logoColor=white)](https://apps.apple.com/app/idYOUR_APP_ID)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS-lightgrey.svg?style=flat)
![License](https://img.shields.io/badge/license-MIT%20with%20Commons%20Clause-green.svg?style=flat)

## About Brave Search

This extension redirects your searches to [Brave Search](https://search.brave.com), a privacy-respecting search engine created by [Brave Software Inc](https://brave.com). Brave Search offers:
- Independent search results
- Privacy-first approach
- No tracking or profiling
- Transparent ranking
- Community-powered features

Learn more about Brave Search:
- [About Brave Search](https://brave.com/search/)
- [Brave Search Blog](https://brave.com/search/blog/)
- [Brave Search Help Center](https://support.brave.com/search)

## Support the Project
- [![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Support-yellow.svg?style=flat&logo=buy-me-a-coffee)](https://www.buymeacoffee.com/btbishop93)
- [![App Store](https://img.shields.io/badge/Download%20on%20the-App%20Store-blue.svg?style=flat&logo=app-store&logoColor=white)](https://apps.apple.com/app/idYOUR_APP_ID)
- ⭐ Star this repository
- 🐛 Report bugs and contribute fixes

## Project Structure

```
Braver Search/
├── iOS (App)/               # iOS host app
├── iOS (Extension)/         # iOS extension-specific code
├── macOS (App)/            # macOS host app
├── macOS (Extension)/      # macOS extension-specific code
├── Shared (App)/           # Shared app code
└── Shared (Extension)/     # Shared extension code and resources
    ├── Resources/
    │   ├── popup.html      # Extension popup UI
    │   ├── popup.css       # Popup styling
    │   ├── popup.js        # Popup functionality
    │   └── background.js   # Core extension functionality
    └── SafariWebExtensionHandler.swift  # Native bridge
```

## Components

### Extension Core (`background.js`)
- Monitors web navigation events
- Intercepts search queries from Safari's default search engine
- Redirects to Brave Search when enabled
- Uses `browser.storage.local` for state management

### Popup Interface
- **HTML (`popup.html`)**: Simple UI with toggle switch and status indicator
- **CSS (`popup.css`)**: Modern styling with system-native appearance
- **JavaScript (`popup.js`)**: Handles user interactions and state management

### Native Integration
- **SafariWebExtensionHandler**: Manages extension state and Safari integration
- Supports both iOS and macOS platforms
- Uses UserDefaults for persistent storage

## How It Works

1. **State Management**
   - Extension state (enabled/disabled) stored in `browser.storage.local`
   - Persists across browser sessions
   - Syncs between popup and background script

2. **Search Redirection**
   - Background script monitors navigation events
   - Detects search queries in URLs
   - When enabled, redirects to Brave Search with the same query

3. **User Interface**
   - Toggle switch to enable/disable redirection
   - Visual indicators for current state
   - Instant feedback on state changes

## Development

### Contributing
We welcome contributions! Here's how you can help:
- Fork the repository
- Create a feature branch
- Submit pull requests
- Report bugs via issues
- Improve documentation
- Share feedback and suggestions

### Prerequisites
- Xcode 15+
- iOS 17.0+ / macOS 14.0+
- Safari 17.0+

### Building
1. Clone the repository
2. Open `Braver Search.xcodeproj` in Xcode
3. Select target platform (iOS/macOS)
4. Build and run

## License

This project is licensed under the MIT License with Commons Clause.

### Personal Use and Contributions (MIT License)
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to:
- Use the software for personal, non-commercial purposes
- Modify the software for personal use
- Contribute improvements back to the main repository
- Fork the repository for personal projects

### Commons Clause Restriction
The Commons Clause restricts you from:
- Selling the software or modifications of it
- Using the software in commercial products without authorization
- Redistributing the software through commercial channels

### App Store Distribution
- Official distribution through the App Store is exclusively by Brenden Bishop
- One-time purchase price: $4.99
- Family Sharing enabled
- Updates included
- App Store terms and EULA apply

### Privacy and Data Collection
- No personal information collected
- Search queries sent directly to Brave Search
- Settings stored locally
- No analytics or tracking

## Contributing

We love contributions! Here's how:

### Ways to Contribute
- Submit bug reports
- Propose new features
- Improve documentation
- Submit pull requests
- Share the project
- Support via App Store purchase or donation

### Getting Started
1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to your branch
5. Open a Pull Request

For feature requests or inquiries:
- Email: btbishop93@gmail.com
- GitHub Issues: For bugs and improvements
 
