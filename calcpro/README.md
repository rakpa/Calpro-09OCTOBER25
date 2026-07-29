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
- Builds unsigned iOS release on macOS
- TestFlight upload job is stubbed until Apple Developer credentials are provided

### Secrets needed for TestFlight (later)

| Secret | Purpose |
|--------|---------|
| `APP_STORE_CONNECT_API_KEY_ID` | ASC API Key ID |
| `APP_STORE_CONNECT_API_ISSUER_ID` | ASC Issuer ID |
| `APP_STORE_CONNECT_API_KEY` | Base64-encoded `.p8` key |
| `APPLE_TEAM_ID` | Apple Developer Team ID |
| Distribution cert + provisioning profile (or Match) | Code signing |
