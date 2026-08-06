# Calcara iOS Home Screen Widget

Swift sources live in `ios/CalcaraWidget/`.

To enable on a Mac (one-time):

1. Open `ios/Runner.xcworkspace` in Xcode.
2. File → New → Target → Widget Extension → name `CalcaraWidget`.
3. Replace generated Swift with `ios/CalcaraWidget/CalcaraWidget.swift`.
4. Add App Group `group.www.calpro.app` to Runner + widget targets.
5. Ensure Runner uses `Runner.entitlements`.

The Flutter app writes `title`, `result`, and `popular` via `home_widget` into that App Group.
