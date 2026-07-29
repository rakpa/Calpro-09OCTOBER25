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

Manual trigger: **Actions → iOS Build & TestFlight → Run workflow**
