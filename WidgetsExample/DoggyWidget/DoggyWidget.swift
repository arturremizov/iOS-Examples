//
//  DoggyWidget.swift
//  DoggyWidget
//
//  Created by Artur Remizov on 12.05.23.
//

import WidgetKit
import SwiftUI

struct DoggyEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct DoggyTimelineProvider: TimelineProvider {
    
    typealias Entry = DoggyEntry
    
    func placeholder(in context: Context) -> DoggyEntry {
        DoggyEntry(
            date: Date(),
            image: UIImage(named: "preview-image")!
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DoggyEntry) -> Void) {
        var snapshotDoggy: UIImage
        if context.isPreview && !DoggyFetcher.cachedDoggyAvailable {
            snapshotDoggy = UIImage(named: "preview-image")!
        } else {
            snapshotDoggy = DoggyFetcher.cachedDoggy!
        }
        let entry = DoggyEntry(date: Date(), image: snapshotDoggy)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DoggyEntry>) -> Void) {
        Task {
            guard let image = try? await DoggyFetcher.fetchRandomDoggy() else {
                return
            }
            let entry = DoggyEntry(date: Date(), image: image)
            let nextUpdate = Calendar.current.date(
                byAdding: .minute,
                value: 15,
                to: Date()
            )!
            let timeline = Timeline(
                entries: [entry],
                policy: .after(nextUpdate)
            )
            completion(timeline)
        }
    }
}

struct DoggyWidgetEntryView : View {
    var entry: DoggyTimelineProvider.Entry

    var body: some View {
        Image(uiImage: entry.image)
            .resizable()
            .scaledToFill()
            .containerBackground(for: .widget) { }
    }
}

struct DoggyWidget: Widget {
    let kind: String = "DoggyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DoggyTimelineProvider()) { entry in
            DoggyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Doggy Widget")
        .description("This is a demo widget.")
        .contentMarginsDisabled()
        .supportedFamilies([
            .systemSmall
        ])
    }
}

struct DoggyWidget_Previews: PreviewProvider {
    static var previews: some View {
        DoggyWidgetEntryView(
            entry: DoggyEntry(
                date: Date(),
                image: UIImage(named: "preview-image")!
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
