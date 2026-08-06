# Calcara — App Store Connect Submission Guide

**App name (device):** Calcara  
**Bundle ID:** `www.calpro.app`  
**Binary version (current):** `1.6.15` (build `35`)  
**Suggested first App Store version number:** `1.0` (you may also ship as `1.6.15` — keep ASC version = marketing version you want users to see)

---

## 0) You must provide / host before Submit

| Item | Status | Action |
|------|--------|--------|
| **Privacy Policy URL (HTTPS, live)** | Draft HTML ready in-repo | Host `store_assets/legal/privacy.html` (GitHub Pages or your domain), then paste URL in App Store Connect |
| **Support URL (HTTPS, live)** | Draft HTML ready | Host `store_assets/legal/support.html` |
| **Marketing URL** | Optional | Leave blank unless you have a landing page |
| **Reviewer phone number** | Missing | Your real mobile with country code |
| **Copyright legal entity** | Draft: `2026 Good Life` | Confirm legal name |
| **Age Rating questionnaire** | Not done in ASC | Complete in App Store Connect (expect **4+**) |
| **App Privacy nutrition labels** | Not done in ASC | Fill using section 6 below |
| **Screenshots uploaded** | Files ready below | Upload from `store_assets/screenshots/` (6.5") and optionally `screenshots_6_7/` |
| **1024×1024 App Icon** | `store_assets/app_icon_1024.png` | Confirm it matches Xcode asset |
| **Export compliance** | `ITSAppUsesNonExemptEncryption = false` in Info.plist | Answer ASC encryption questions accordingly |

**In-app (already implemented in this build):**
- Settings → Privacy Policy / Terms / Support (readable offline)
- Calcara Plus no longer claims paid subscription (App Store Guideline 3.1 safe for this version)
- Honest currency copy (offline estimates)

---

## 1) App Information (App Store Connect → App Information)

| Field | Enter this |
|-------|------------|
| **Name** | `Calcara` (≤30 characters) |
| **Subtitle** | `Everyday Smart Calculators` (≤30) |
| **Privacy Policy URL** | *Your live HTTPS URL to privacy.html* |
| **Category (Primary)** | Utilities |
| **Category (Secondary)** | Finance *(optional)* |
| **Content Rights** | Confirm you own icon, mascot, screenshots |

---

## 2) Version page — text fields

### Promotional Text (≤170, optional — editable anytime)
```
All-in-one calculators — percentage, mortgage, tips, BMI, EMI, converters & more. Fast, beautiful, accurate.
```

### Description (≤4000)
```
Calcara is a beautiful suite of everyday calculators — designed to be fast, clear, and pleasant to use.

Whether you’re splitting a dinner bill, checking a mortgage payment, figuring out a sale discount, or converting units, Calcara keeps the tools you need in one place.

WHAT’S INSIDE
• Percentage — X% of Y, what percent, and percent change
• Mortgage — monthly payment estimates & affordability
• Tip — tip amounts and bill splitting
• Discount — sale prices and stacked savings
• Health — BMI, BMR & TDEE helpers
• EMI / loans — payment estimates & amortization
• Compound interest / savings growth
• Scientific & basic calculators
• Unit converter — length, weight, temperature & more
• Currency — offline mid-market estimates
• Age, time, date & pregnancy due-date helpers
• Sales tax, unit price, fuel, markup, ROI & more

DESIGNED FOR REAL LIFE
• Home greeting with searchable catalog
• Category chips: Finance, Health, Everyday, Business
• Favorites and history
• Light & dark themes
• Optional haptics

Privacy-minded: preferences and history stay on your device. No account required.

Calcara — smart calculators for everyday life. Fast. Beautiful. Accurate.

Estimates only — not financial, tax, or medical advice.
```

### Keywords (≤100 characters)
```
calculator,percentage,mortgage,tip,discount,bmi,emi,converter,finance,math
```
(88 characters — do **not** repeat the app name “Calcara”)

### Support URL (required)
```
https://rakpa.github.io/Calpro-09OCTOBER25/support.html
```
(Enable GitHub Pages → `/docs` first — see `docs/README.md`)

### Privacy Policy URL (App Information)
```
https://rakpa.github.io/Calpro-09OCTOBER25/privacy.html
```

### Marketing URL (optional)
```
https://rakpa.github.io/Calpro-09OCTOBER25/
```

### What’s New (1.0 / first release)
```
Welcome to Calcara — your everyday calculator suite.
• Percentage, mortgage, tip, discount, health & EMI tools
• Unit & currency converters
• Favorites, history, light/dark themes
```

### Copyright
```
2026 Good Life
```

---

## 3) Screenshots (iPhone)

### 6.5" Display — **1284 × 2778** (required)
Upload in this order from `store_assets/screenshots/`:

| # | File | Shows |
|---|------|--------|
| 1 | `01_splash.png` | Brand / mascot |
| 2 | `02_home.png` | Home catalog |
| 3 | `03_browse.png` | Browse list |
| 4 | `04_percentage.png` | Percentage |
| 5 | `05_mortgage.png` | Mortgage |
| 6 | `06_tip.png` | Tip |
| 7 | `07_settings.png` | Privacy-minded settings *(optional 7th)* |

### 6.7" Display — **1290 × 2796**
Same set in `store_assets/screenshots_6_7/` (upload if ASC requires 6.7"/6.9").

Skip iPad / Watch unless you ship those targets.

> Note: These are marketing frames sized for ASC. For maximum trust, also capture 2–3 live device screenshots from TestFlight that match the current UI.

---

## 4) Build & App Review Information

1. Wait for TestFlight build **1.6.15 (35)** (or newer) → Ready to Submit  
2. Version page → **Add Build** → select it  
3. **Sign-in required:** Unchecked  

| Field | Value |
|-------|--------|
| First name | Good |
| Last name | Life |
| Phone | ***(you must fill)*** |
| Email | anubundu1@gmail.com |

### Review Notes
```
Calcara is a calculator suite with no account or login.

How to review:
1. Launch and finish onboarding if shown.
2. Home: browse/search calculators; open Percentage, Mortgage, Tip.
3. Enter your own numbers (fields start empty) and calculate.
4. Settings → Privacy Policy, Terms, Support.
5. Calcara Plus is a free on-device history unlock — no paid IAP in this version.

No demo account needed.
```

### Release
Recommend **Manually release this version** for first submission.

---

## 5) App Privacy (nutrition labels)

Declare honestly for current app:

- **Data Used to Track You:** No  
- **Data Linked to You:** None (no accounts)  
- **Data Not Linked to You:** typically none leaving the device  
- On-device only: preferences, favorites, history  
- Microphone: not required for core features in this version (voice search not in primary navigation). If ASC asks and you keep mic strings in Info.plist, declare optional audio for App Functionality, not linked to identity, not used for tracking.

---

## 6) Hosting legal pages (GitHub Pages quick path)

1. Repo Settings → Pages → Deploy from branch `main` (or this PR branch) `/ (root)` or `/docs`  
2. Or copy `calcpro/store_assets/legal/*.html` to any HTTPS host  
3. Paste the live Privacy + Support URLs into App Store Connect **before** submit  

In-app copies work offline even if web hosting is delayed — **ASC still requires live URLs**.

---

## 7) Pre-submission checklist

- [ ] Privacy Policy URL live (HTTPS)  
- [ ] Support URL live (HTTPS)  
- [ ] Screenshots uploaded (6.5" minimum)  
- [ ] App icon 1024×1024 accepted  
- [ ] Age Rating completed (4+)  
- [ ] App Privacy answered  
- [ ] Build selected  
- [ ] Reviewer contact phone filled  
- [ ] No paid IAP claims without StoreKit *(fixed in 1.6.15)*  
- [ ] Description matches shipping features (no “voice search” / “120+” claims)  
- [ ] TestFlight smoke: empty inputs, calculate, Settings legal links  

---

## 8) UX / QA findings (reviewer + first-time user)

### Fixed in this prep build
- Misleading **$4.99/month** Premium paywall → free on-device history unlock  
- Dead Settings rows (Accent Color, unused Tips) removed  
- Fake notification badge removed  
- Hardcoded Settings version → `1.6.15`  
- In-app Privacy / Terms / Support  
- Currency catalog copy honesty  
- Compound interest help text (monthly)  
- Mortgage “estimates only” disclaimer  

### Still recommended before / after first release
1. Differentiate Home vs Calculate tab naming (both feel like catalogs)  
2. Stronger empty-state validation toasts on Mortgage/Health when Calculate tapped with invalid input  
3. Live FX rates (or keep offline disclaimer highly visible)  
4. Wire or remove orphan `SearchScreen` + mic permissions long-term  
5. Confirm history Clear with a dialog  
6. Capture true device screenshots to replace marketing frames if Apple asks for accuracy  

### Rejection-risk gate (must be green)
| Risk | Status |
|------|--------|
| Paid subscription without StoreKit | **Mitigated** |
| Missing Privacy/Support URLs in ASC | **You must host** |
| Feature claims not in app (voice, 120+) | **Listing updated** |
| Empty calculator defaults | **Already cleared** |
