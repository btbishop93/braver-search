# Apple Distribution Setup Guide

This guide walks through the complete setup process for distributing iOS and macOS apps to the App Store, including code signing and CI/CD configuration.

## Prerequisites
- Apple Developer Program membership
- Access to App Store Connect
- Access to Apple Developer portal
- Xcode installed on your Mac
- GitHub repository for your project

## 1. App Store Connect API Key Setup
1. Go to App Store Connect > Users and Access > Keys
2. Click the "+" button to generate a new API Key
3. Give it a name (e.g., "CI/CD Key")
4. Save the API Key ID (visible in the list)
5. Download the .p8 file (you can only download this once)
6. Note the Issuer ID (visible in the Keys page)

## 2. Distribution Certificate Setup
1. Open Keychain Access on your Mac
2. Go to Keychain Access > Certificate Assistant > Request a Certificate From a Certificate Authority
3. Fill out the form:
   - Enter your email and name
   - Select "Saved to disk"
   - Leave CA Email Address empty
4. Save the Certificate Signing Request (CSR) file
5. Go to Apple Developer portal > Certificates
6. Click "+" to create a new certificate
7. Select "Apple Distribution" (this works for both iOS and macOS)
8. Upload your CSR file
9. Download and install the certificate
10. In Keychain Access, find the installed certificate under "My Certificates"
11. Export the certificate (with private key) as .p12:
    - Right-click the certificate
    - Choose Export
    - Save as .p12 file
    - Set a temporary password

## 3. Provisioning Profiles Setup
For a universal Safari extension app, you need four provisioning profiles:

### iOS Profiles
1. Go to Apple Developer portal > Profiles
2. Click "+" to create new profile
3. Select "App Store" under iOS
4. Select your main app bundle ID
5. Select your Distribution certificate
6. Name it clearly (e.g., "MyApp iOS App Store")
7. Download the profile
8. Repeat for extension with extension bundle ID

### macOS Profiles
1. Go to Apple Developer portal > Profiles
2. Click "+" to create new profile
3. Select "Mac App Store" (not Mac Catalyst)
4. Select your main app bundle ID
5. Select your Distribution certificate
6. Name it clearly (e.g., "MyApp macOS App Store")
7. Download the profile
8. Repeat for extension with extension bundle ID

## 4. GitHub Secrets Setup
Add these secrets to your GitHub repository (Settings > Secrets and variables > Actions):

1. `APPLE_API_KEY_ID`
   - Value: Key ID from App Store Connect
   - Found in: App Store Connect > Users and Access > Keys

2. `APPLE_API_KEY_ISSUER_ID`
   - Value: Issuer ID from App Store Connect
   - Found in: App Store Connect > Users and Access > Keys

3. `APPLE_API_PRIVATE_KEY`
   - Value: Content of the downloaded .p8 file
   - Include the BEGIN and END markers

4. `APPLE_CERTIFICATE_PRIVATE_KEY`
   - Export the private key from your Distribution certificate:
   ```bash
   cd ~/Downloads
   openssl pkcs12 -in distribution.p12 -nodes -nocerts -legacy -out private_key.pem -passin pass:YOUR_PASSWORD
   ```
   - Value: Content of private_key.pem including BEGIN and END markers

5. `APPLE_TEAM_ID`
   - Value: Your Team ID
   - Found in: Apple Developer portal > Membership
   - Or: App Store Connect > Users and Access (top right)

6. `APPLE_APP_SPECIFIC_PASSWORD`
   - Go to https://appleid.apple.com
   - Security > App-Specific Passwords > Generate Password
   - Give it a name (e.g., "GitHub CI")
   - Copy the generated password

## 5. GitHub Actions and Fastlane Setup

### Fastlane Setup
1. Create a `Gemfile` in your project root:
   ```ruby
   source "https://rubygems.org"
   gem "fastlane"
   ```

2. Create `fastlane/Fastfile` with your build lanes:
   ```ruby
   platform :ios do
     lane :beta do
       setup_ci if is_ci
       update_code_signing_settings(
         use_automatic_signing: false,
         team_id: ENV["APPLE_TEAM_ID"]
       )
       build_ios_app(
         project: "YourProject.xcodeproj",
         scheme: "Your Scheme",
         export_method: "app-store"
       )
       upload_to_testflight
     end
   end
   ```

### GitHub Actions Workflow
1. Create `.github/workflows/app-store.yml`
2. Configure the workflow to:
   - Run on push to main or manual trigger
   - Set up Ruby and Xcode
   - Create temporary keychain
   - Import certificates
   - Run Fastlane lanes
   - Clean up sensitive data

## Security Notes
- Never commit certificates, private keys, or .p12 files to version control
- Delete downloaded certificates and keys after adding to GitHub Secrets
- Keep the .p8 file from App Store Connect in a secure location
- GitHub Secrets are encrypted and can only be used by GitHub Actions
- Use environment variables for sensitive values in CI/CD

## Common Issues
- Make sure bundle IDs match exactly between Xcode and provisioning profiles
- Distribution certificate should be "Apple Distribution" (universal), not platform-specific
- Provisioning profiles need to be regenerated if the certificate expires
- Mac Catalyst is different from native macOS - use the correct profile type
- Check GitHub Actions logs for detailed error messages
- Verify all required secrets are set in GitHub repository settings

## Advantages of Fastlane
- Simpler, more readable syntax than raw shell commands
- Built-in error handling and retry mechanisms
- Automatic environment detection
- Consistent behavior between local and CI environments
- Large community and extensive documentation
- Can be tested locally before running in CI

## Next Steps
1. Test the workflow by pushing to main or manual trigger
2. Monitor the GitHub Actions execution
3. Check TestFlight for successful uploads
4. Set up automated version incrementing
5. Configure notification for build status 