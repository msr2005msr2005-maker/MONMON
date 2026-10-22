# MONMON

Arabic RTL Flutter social-network **interactive prototype** for Android and iOS.

## Run
1. Install Flutter SDK and Android Studio or Xcode (macOS for iOS).
2. In this directory run `flutter create . --platforms=android,ios`.
3. Run `flutter pub get` then `flutter run`.

Includes local demo login, feed, post creation, likes, comment counters, friend-request toggles, groups list, local chat, notifications, and profile.

**Important:** Data is in memory and resets when the app restarts. Login is demonstration only (not secure authentication). No Firebase, backend, real users, image uploads, push notifications, moderation, or store deployment is configured. These require a Firebase project, credentials, security rules, platform configuration, and further development.

## Build APK with GitHub Actions (no local SDK required)
Create a new GitHub repository and upload the contents of this folder, including the hidden `.github/workflows/build-apk.yml` file. Open **Actions → Build MONMON APK → Run workflow**. Once the run finishes, download the `MONMON-android-apk` artifact; unzip it to obtain `app-release.apk`. The workflow also runs on pushes to `main` or `master`. This release is built with Flutter's default debug signing key for release builds unless you configure your own release signing; do not publish it to an app store without configuring production signing and application identifiers.
