//
//  ViewSizeWidget.swift
//  ViewSizeWidget
//
//  Created by Artur Remizov on 11.05.23.
//

import WidgetKit
import SwiftUI

// MARK: - The Timeline Entry
struct ViewSizeEntry: TimelineEntry {
    let date: Date
    let providerInfo: String
}

// MARK: - The Widget View
struct ViewSizeWidgetView: View {
    
    let entry: ViewSizeEntry
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // show view size
                Text("\(Int(geometry.size.width)) x \(Int(geometry.size.height))")
                    .font(.system(.title2, weight: .bold))
                
                // show provider info
                Text(entry.providerInfo)
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green)
        }
    }
}

struct ViewSizeWidget_Previews: PreviewProvider {
    static var previews: some View {
        ViewSizeWidgetView(
            entry: ViewSizeEntry(date: Date(), providerInfo: "preview")
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

// MARK: - The Timeline Provider
struct ViewSizeTimelineProvider: TimelineProvider {
    
    typealias Entry = ViewSizeEntry
    
    func placeholder(in context: Context) -> ViewSizeEntry {
        return ViewSizeEntry(date: Date(), providerInfo: "placeholder")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ViewSizeEntry) -> Void) {
        let entry = ViewSizeEntry(date: Date(), providerInfo: "snapshot")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ViewSizeEntry>) -> Void) {
        let entry = ViewSizeEntry(date: Date(), providerInfo: "timeline")
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

// MARK: - The Widget Configuration
struct ViewSizeWidget: Widget {
    let kind: String = "ViewSizeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ViewSizeTimelineProvider()) { entry in
            ViewSizeWidgetView(entry: entry)
        }
        .configurationDisplayName("View Size Widget")
        .description("This is a demo widget.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge
        ])
    }
}
