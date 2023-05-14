//
//  TapMeWidget.swift
//  TapMeWidget
//
//  Created by Artur Remizov on 14.05.23.
//

import WidgetKit
import SwiftUI
import Intents

struct TapMeWidgetEntry: TimelineEntry {
    let date: Date
    let backgroundColor: BackgroundColor
}

struct TapMeWidgetTimelineProvider: IntentTimelineProvider {
    
    typealias Entry = TapMeWidgetEntry
    typealias Intent = TapMeConfigurationIntent
    
    func placeholder(in context: Context) -> TapMeWidgetEntry {
        TapMeWidgetEntry(date: Date(), backgroundColor: .red)
    }
    
    func getSnapshot(for configuration: TapMeConfigurationIntent, in context: Context, completion: @escaping (TapMeWidgetEntry) -> Void) {
        
        let entry = TapMeWidgetEntry(
            date: Date(),
            backgroundColor: configuration.backgroundColor
        )
        completion(entry)
    }
    
    func getTimeline(for configuration: TapMeConfigurationIntent, in context: Context, completion: @escaping (Timeline<TapMeWidgetEntry>) -> Void) {
        
        let entry = TapMeWidgetEntry(
            date: Date(),
            backgroundColor: configuration.backgroundColor
        )
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct TapMeWidgetEntryView : View {
    let entry: TapMeWidgetEntry
    
    var body: some View {
        VStack {
            Text("Tap Me!")
                .font(.title)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(entry.backgroundColor.color)
        .widgetURL(entry.backgroundColor.widgetURL)
    }
}

struct TapMeWidget: Widget {
    let kind: String = "TapMeWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: TapMeConfigurationIntent.self,
            provider: TapMeWidgetTimelineProvider()
        ) { entry in
            TapMeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Tap Me Widget")
        .description("This is a demo widget.")
        .supportedFamilies([
            .systemSmall
        ])
    }
}

struct TapMeWidget_Previews: PreviewProvider {
    static var previews: some View {
        TapMeWidgetEntryView(
            entry: TapMeWidgetEntry(date: Date(), backgroundColor: .red)
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
