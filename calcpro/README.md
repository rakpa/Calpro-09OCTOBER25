# CalcPro (Flutter)

Native Flutter iOS/Android rebuild of the CalcPro multi-purpose calculator suite.
The original React/Vite app in this repository is kept as the product reference.

## Features

- Percentage, Basic, Scientific calculators
- Unit converter (length / weight / area)
- Financial (compound interest) & Mortgage
- Age, Time, Date difference
- Discount, Tip, Health (BMI / ideal weight)

Bundle ID: `www.calpro.app`

## Develop

```bash
cd calcpro
flutter pub get
flutter run
```

## Test

```bash
cd calcpro
flutter test
flutter analyze
```

## iOS build

```bash
cd calcpro
flutter build ios --release --no-codesign
```

## CI

GitHub Actions workflow: `.github/workflows/ios-build.yml`

- Runs tests on Ubuntu
- Signs + archives on macOS using App Store Connect API key (automatic signing)
- Exports IPA and uploads to TestFlight

### Required GitHub Actions secrets

| Secret | Purpose |
|--------|---------|
| `ASC_KEY_ID` | App Store Connect API Key ID |
| `ASC_ISSUER_ID` | App Store Connect Issuer ID |
| `ASC_PRIVATE_KEY` | `.p8` private key contents (PEM text or base64) |
| `APPLE_TEAM_ID` | Apple Developer Team ID |
| `BUILD_CERTIFICATE_BASE64` | Base64-encoded Apple **Distribution** `.p12` |
| `P12_PASSWORD` | Password for that `.p12` |
| `BUILD_PROVISION_PROFILE_BASE64` | Optional: base64 App Store `.mobileprovision` for `www.calpro.app` |

**Why the `.p12` is required:** App Store Connect API auth works, and the app `www.calpro.app` already exists. But this Apple team already has the **maximum Distribution certificates**, and their private keys are only on the Mac that created them. CI cannot invent those keys, and cannot create another cert.

#### Export `.p12` on your Mac
1. Open **Keychain Access** → **My Certificates**
2. Find **Apple Distribution: … (Rakesh Patil)** (or similar)
3. Right-click → **Export…** → save as `.p12` with a password
4. Encode and copy:
   ```bash
   base64 -i Certificates.p12 | pbcopy
   ```
5. Paste into GitHub secret `BUILD_CERTIFICATE_BASE64`, and set `P12_PASSWORD`

Manual trigger: **Actions → iOS Build & TestFlight → Run workflow**
