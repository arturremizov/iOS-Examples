//
//  MyTextWidget.swift
//  MyTextWidget
//
//  Created by Artur Remizov on 12.05.23.
//

import WidgetKit
import SwiftUI
import Intents

struct MyTextEntry: TimelineEntry {
    let date: Date
    let displayText: String
    let fontSize: Int
    let borderColor: Color
}

struct MyTextTimelineProvider: IntentTimelineProvider {
    
    typealias Entry = MyTextEntry
    typealias Intent = MyTextConfigurationIntent
    
    func placeholder(in context: Context) -> MyTextEntry {
        MyTextEntry(
            date: Date(),
            displayText: "Hello 👋",
            fontSize: 16,
            borderColor: .clear
        )
    }
    
    func getSnapshot(for configuration: MyTextConfigurationIntent, in context: Context, completion: @escaping (MyTextEntry) -> Void) {
        
        let entry = setupMyTextEntry(with: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: MyTextConfigurationIntent, in context: Context, completion: @escaping (Timeline<MyTextEntry>) -> Void) {
        
        let entry = setupMyTextEntry(with: configuration)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    private func convertToColor(using borderColor: BorderColor) -> Color {
        switch borderColor {
        case .unknown:
            return .clear
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        }
    }
    
    private func setupMyTextEntry(with configuration: MyTextConfigurationIntent) -> MyTextEntry {
        
        let myText = configuration.myText ?? "Hello 👋"
        let fontSize = Int(truncating: configuration.fontSize ?? 16)
        let color = convertToColor(using: configuration.borderColor)
        
        let entry = MyTextEntry(
            date: Date(),
            displayText: myText,
            fontSize: fontSize,
            borderColor: color
        )
        return entry
    }
}

struct MyTextWidgetEntryView : View {
    
    var entry: MyTextEntry

    var body: some View {
        Text(entry.displayText)
            .font(.system(size: CGFloat(entry.fontSize)))
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(entry.borderColor, lineWidth: 2)
            }
            .containerBackground(for: .widget) { }
    }
}

struct MyTextWidget: Widget {
    let kind: String = "MyTextWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: MyTextConfigurationIntent.self,
            provider: MyTextTimelineProvider()
        ) { entry in
            MyTextWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("MyText Widget")
        .description("Show your favorite text!")
        .contentMarginsDisabled()
        .supportedFamilies([
            .systemSmall
        ])
    }
}

struct MyTextWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyTextWidgetEntryView(
            entry: MyTextEntry(
                date: Date(),
                displayText: "Hello 👋",
                fontSize: 16,
                borderColor: .red
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
