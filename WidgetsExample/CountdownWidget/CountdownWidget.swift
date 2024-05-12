//
//  CountdownWidget.swift
//  CountdownWidget
//
//  Created by Artur Remizov on 12.05.23.
//

import WidgetKit
import SwiftUI

struct CountdownProvider: TimelineProvider {
    typealias Entry = CountdownEntry
    
    func placeholder(in context: Context) -> CountdownEntry {
        CountdownEntry(date: Date(), status: "Counting down...", gaugeValue: 60)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CountdownEntry) -> Void) {
        let entry = CountdownEntry(date: Date(), status: "Counting down..", gaugeValue: 60)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CountdownEntry>) -> Void) {
        
        var entries: [CountdownEntry] = []
        for i in 0...CountdownWidget.totalCountdown {
            let components = DateComponents(second: i)
            let refreshDate = Calendar.current.date(byAdding: components, to: Date())!
            
            let gaugeValue = CGFloat(CountdownWidget.totalCountdown - i)
            
            let status = gaugeValue == 0 ? "Waiting refresh..." : "Counting down..."
            
            let entry = CountdownEntry(
                date: refreshDate,
                status: status,
                gaugeValue: gaugeValue
            )
            
            entries.append(entry)
        }
        
        let lastIUpdate = entries.last!.date
        let nextUpdate = Calendar.current.date(byAdding: .second,
                                               value: 5,
                                               to: lastIUpdate)!
        
        let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct CountdownEntry: TimelineEntry {
    let date: Date
    let status: String
    let gaugeValue: CGFloat
}

struct CountdownWidgetEntryView : View {
    
    let entry: CountdownProvider.Entry

    var body: some View {
        VStack(spacing: 10) {
            Text(getFutureDate(), style: .timer)
                .monospacedDigit()
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(4)
                .background(.red)
            
            Gauge(value: entry.gaugeValue, in: 0...CGFloat(CountdownWidget.totalCountdown)) {
                Text("countdown")
            } currentValueLabel: {
                Text(entry.gaugeValue.formatted())
                    .foregroundColor(.white)
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(.white)

            Text(entry.status)
                .font(.caption)
                .foregroundColor(Color(.systemGray))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget) {
            Color.black
        }
    }
    
    private func getFutureDate() -> Date {
        let components = DateComponents(second: CountdownWidget.totalCountdown + 1)
        let futureDate = Calendar.current.date(byAdding: components, to: Date())!
        return futureDate
    }
}

struct CountdownWidget: Widget {
    
    static let totalCountdown: Int = 60
    let kind: String = "CountdownWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CountdownProvider()) { entry in
            CountdownWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Countdown Widget")
        .description("This is a demo widget.")
        .contentMarginsDisabled()
        .supportedFamilies([
            .systemSmall
        ])
    }
}

struct CountdownWidget_Previews: PreviewProvider {
    static var previews: some View {
        CountdownWidgetEntryView(
            entry: CountdownEntry(date: Date(), status: "a", gaugeValue: 1)
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
