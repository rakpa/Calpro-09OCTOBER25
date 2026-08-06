import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "Calcara", result: "Open a calculator", popular: "Percentage · Mortgage · BMI")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = loadEntry()
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 30)))
        completion(timeline)
    }

    private func loadEntry() -> SimpleEntry {
        let defaults = UserDefaults(suiteName: "group.www.calpro.app")
        let title = defaults?.string(forKey: "title") ?? "Calcara"
        let result = defaults?.string(forKey: "result") ?? "Open a calculator"
        let popular = defaults?.string(forKey: "popular") ?? "Percentage · Mortgage · BMI"
        return SimpleEntry(date: Date(), title: title, result: result, popular: popular)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let result: String
    let popular: String
}

struct CalcaraWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Calcara")
                .font(.headline)
                .foregroundColor(Color(red: 0.35, green: 0.19, blue: 0.96))
            Text(entry.title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(entry.result)
                .font(.title3).bold()
                .lineLimit(2)
            Spacer()
            Text(entry.popular)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding()
    }
}

@main
struct CalcaraWidget: Widget {
    let kind: String = "CalcaraWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalcaraWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Calcara")
        .description("Latest calculation and popular tools.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
