# Calcara — App Store Connect fill guide

Use this while editing **iOS App Version 1.0 → Prepare for Submission**.

---

## 0) Before you fill anything

1. Wait until the TestFlight / App Store Connect build finishes processing (Processing → Ready to Submit).
2. On the version page, **Build → Add Build** → pick the latest build from CI.
3. **Uncheck “Sign-in required”** under App Review Information (Calcara has no login).
4. You need a live **Privacy Policy URL** and **Support URL** (Apple requires them). See draft privacy text below.

---

## 1) Previews and Screenshots (iPhone)

**Tab:** iPhone → **6.5" Display** (required)

Upload these files from `store_assets/screenshots/` (already sized **1284 × 2778**):

| Order | File | Shows |
|------:|------|--------|
| 1 | `01_splash.png` | Brand + mascot welcome |
| 2 | `02_home.png` | Home / popular calculators |
| 3 | `03_percentage.png` | Percentage calculator |
| 4 | `04_mortgage.png` | Mortgage calculator |
| 5 | `05_search.png` | Search + voice |
| 6 | `06_tip.png` | Tip calculator |

You can skip iPad / Apple Watch if those aren’t supported.

---

## 2) Copy-paste text fields

### Promotional Text (≤170 characters) — optional
```
All-in-one smart calculators — percentage, mortgage, tips, BMI, EMI, and more. Fast, beautiful, accurate.
```

### Description (≤4000 characters)
```
Calcara is a beautiful suite of everyday calculators — designed to be fast, clear, and actually pleasant to use.

Whether you’re splitting a dinner bill, checking a mortgage payment, figuring out a sale discount, or converting units, Calcara keeps the tools you need in one place.

WHAT’S INSIDE
• Percentage — find X% of Y, percent change, and more
• Mortgage — estimate monthly payments in seconds
• Tip — tip amounts and bill splitting
• Discount — sale prices and stacked savings
• BMI & health — quick health checks
• EMI / financial — loans and interest
• Scientific — trig, powers, and advanced math
• Unit converter — length, weight, temperature
• Age, time & date — everyday date math
• Basic calculator — clean everyday arithmetic

DESIGNED FOR REAL LIFE
• Clean home with popular calculators at a glance
• Search (with voice) to jump straight to a tool
• Favorites and history so recent work stays handy
• Light & dark themes
• Optional haptics and tips

Calcara — smart calculators for everyday life. Fast. Beautiful. Accurate.
```

### Keywords (≤100 characters, comma-separated, no spaces after commas preferred)
```
calculator,percentage,mortgage,tip,discount,bmi,emi,converter,finance,math
```
(Character count: 88)

### Support URL (required)
Use a real page you control, for example:
- `https://yourdomain.com/calcara/support`
- or a public Google Doc / Notion page marked as Support

Suggested support page content:
- App name: Calcara
- Email: anubundu1@gmail.com
- “For help with Calcara, email us. We typically reply within 2 business days.”

### Marketing URL (optional)
```
(leave blank, or your landing page if you have one)
```

### Version
```
1.0
```
(Matches the App Store version you’re submitting. The binary build number can be higher from CI — that’s fine.)

### Copyright
```
2026 Good Life
```
(Or your legal name / company name.)

---

## 3) Build

1. Click **Add Build**
2. Select the newest processed build (`www.calpro.app`)
3. If export compliance appears: for a normal calculator with HTTPS only, answer **No** to encryption exempt questions as appropriate (standard HTTPS → usually “uses encryption only for HTTPS” path)

---

## 4) App Review Information

### Sign-in required
**Unchecked** (no account)

### Contact Information
| Field | Value |
|-------|--------|
| First Name | Good |
| Last Name | Life |
| Phone Number | *(your real phone with country code)* |
| Email | anubundu1@gmail.com |

### Notes (for reviewer)
```
Calcara is a calculator suite with no account or login.

How to review:
1. Launch the app (skip/finish onboarding if shown).
2. On Home, open Percentage, Mortgage, Tip, or any calculator.
3. Enter sample values and tap Calculate.
4. Try Search from the center Calculate tab / search field.
5. Settings → theme, haptics, and Calcara Premium trial (local trial; no paid IAP required to review core features).

No special demo account needed.
```

---

## 5) App Store Version Release

Recommended for first release:
- **Manually release this version** (so you control the go-live moment)

Or keep **Automatically release** if you want it live as soon as Apple approves.

---

## 6) App Privacy (App Store Connect → App Privacy)

Declare data collection honestly. For current Calcara (local preferences, no analytics backend assumed):

- **Data Used to Track You:** No
- **Data Linked to You:** typically none if everything stays on-device
- If you only store favorites/history/theme on device: you can often select that you do **not** collect data that leaves the device
- Microphone: used for optional voice search — declare if Apple’s questionnaire asks about audio; purpose = App Functionality; not linked to identity if not uploaded

Save privacy answers before submitting.

---

## 7) Age Rating / Content Rights

- Complete the age rating questionnaire (calculator app → usually **4+**)
- Confirm you have rights to the icon, mascot, and screenshots

---

## 8) Submit

1. **Save** the version page
2. Fix any yellow/red missing-metadata warnings
3. Click **Add for Review** → **Submit to App Review**

Typical review time: ~24–48 hours (can vary).

---

## Privacy Policy draft (host this at your Privacy Policy URL)

```
Privacy Policy for Calcara

Last updated: July 30, 2026

Calcara (“we”, “us”) provides a calculator utility app for iOS.

Information we store on your device
• App preferences (theme, haptics, sound, tips)
• Favorites, recent searches, and calculation history
These stay on your device unless you clear app data or uninstall.

Microphone
• Optional voice search may use the microphone while you search.
• Audio is processed to recognize search terms and is not used to create an account profile.

Premium trial
• Any premium trial status may be stored locally on your device.

Third parties
• We do not sell your personal information.
• App Store / Apple may process purchase and download data under Apple’s privacy policy.

Contact
• Email: anubundu1@gmail.com

Changes
• We may update this policy; the “Last updated” date will change when we do.
```

Host on GitHub Pages, Notion (public), Carrd, or your site, then paste that URL into:
- App Store Connect → App Information → Privacy Policy URL
- and the version’s required privacy fields if prompted
