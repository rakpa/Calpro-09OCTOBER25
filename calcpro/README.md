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
| `BUILD_CERTIFICATE_BASE64` | Optional after first successful cert create — base64 Distribution `.p12` |
| `P12_PASSWORD` | Optional — password used when exporting/importing the `.p12` |
| `BUILD_PROVISION_PROFILE_BASE64` | Optional App Store `.mobileprovision` for `www.calpro.app` |

### No Mac? Do this (Windows is fine)

Your Apple team is at the **max Distribution certificates** limit. CI cannot use those certs without their private keys.

1. Open (any browser): https://developer.apple.com/account/resources/certificates/list  
2. Revoke **one unused** **Apple Distribution** certificate (only if you don’t need it for another live app)  
3. Re-run the GitHub Action  
4. CI will create a new Distribution cert, sign, upload to TestFlight, and attach artifact `calcpro-distribution-p12`  
5. Download that `.p12` and save it as secrets for future runs:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("distribution.p12")) | Set-Clipboard
```

Add `BUILD_CERTIFICATE_BASE64` (paste) and `P12_PASSWORD` (see README inside the artifact).

**Alternative:** If a previous iOS CI (Codemagic / Bitrise / another GitHub repo) already has a Distribution `.p12`, copy those secrets here instead of revoking.

