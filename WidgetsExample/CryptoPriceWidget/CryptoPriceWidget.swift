//
//  CryptoPriceWidget.swift
//  CryptoPriceWidget
//
//  Created by Artur Remizov on 13.05.23.
//

import WidgetKit
import SwiftUI
import Intents

struct CryptoPriceEntry: TimelineEntry {
    let date: Date
    let asset: Asset?
    
    init(date: Date, asset: Asset? = nil) {
        self.date = date
        self.asset = asset
    }
}

struct CryptoPriceTimelineProvider: IntentTimelineProvider {
    
    typealias Entry = CryptoPriceEntry
    typealias Intent = CryptoPriceConfigurationIntent
    
    func placeholder(in context: Context) -> CryptoPriceEntry {
        let asset = Asset.previewAsset
        return CryptoPriceEntry(date: Date(), asset:asset)
    }
    
    func getSnapshot(for configuration: CryptoPriceConfigurationIntent, in context: Context, completion: @escaping (CryptoPriceEntry) -> Void) {
        
        completion(CryptoPriceEntry(date: Date(), asset: nil))
    }
    
    func getTimeline(for configuration: CryptoPriceConfigurationIntent,
                     in context: Context,
                     completion: @escaping (Timeline<CryptoPriceEntry>) -> Void) {
        guard
            let selectedCrypto = configuration.selectedCrypto,
            let assetId = selectedCrypto.identifier
        else {
            let entry = CryptoPriceEntry(date: Date())
            completion(Timeline(entries: [entry], policy: .never))
            return
        }
        
        Task {
            let nextUpdateDate = Calendar.current.date(
                byAdding: .minute,
                value: 15,
                to: Date.now
            )!

            guard
                let asset = try? await AssetFetcher.fetchAsset(id: assetId)
            else {
                let entry = CryptoPriceEntry(date: Date())
                completion(Timeline(entries: [entry], policy: .after(nextUpdateDate)))
                return
            }
            
            let entry = Entry(date: Date(), asset: asset)
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
            completion(timeline)
        }
    }
}

struct CryptoPriceWidgetEntryView : View {
    let entry: CryptoPriceEntry

    var body: some View {
        Group {
            if let asset = entry.asset {
                VStack(spacing: 4) {
                    Text(asset.name)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .allowsTightening(true)
                    Text(asset.symbol)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(asset.price)
                        .font(.title3)
                        .bold()
                        .padding(.vertical, 2)
                }
            } else {
                Text("Please select an asset")
                    .font(.footnote)
                    .bold()
                    .multilineTextAlignment(.center)
            }
        }
//        .padding(8)
        .containerBackground(for: .widget) { }
    }
}

struct CryptoPriceWidget: Widget {
    let kind: String = "CryptoPriceWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: CryptoPriceConfigurationIntent.self,
            provider: CryptoPriceTimelineProvider()
        ) { entry in
            CryptoPriceWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Crypto Price Widget")
        .description("This is a demo widget.")
        .supportedFamilies([
            .systemSmall
        ])
    }
}

struct CryptoPriceWidget_Previews: PreviewProvider {
    static var previews: some View {
        CryptoPriceWidgetEntryView(
            entry: CryptoPriceEntry(date: Date(), asset: Asset.previewAsset)
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
