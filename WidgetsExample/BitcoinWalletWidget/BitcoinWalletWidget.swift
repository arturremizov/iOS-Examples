//
//  BitcoinWalletWidget.swift
//  BitcoinWalletWidget
//
//  Created by Artur Remizov on 15.05.23.
//

import WidgetKit
import SwiftUI

struct BitcoinWalletProvider: TimelineProvider {
    
    typealias Entry = BitcoinWalletEntry
    
    func placeholder(in context: Context) -> BitcoinWalletEntry {
        BitcoinWalletEntry.demoEntry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (BitcoinWalletEntry) -> Void) {
        completion(BitcoinWalletEntry.demoEntry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BitcoinWalletEntry>) -> Void) {
        let entry = BitcoinWalletEntry.demoEntry
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct BitcoinWalletEntry: TimelineEntry {
    let date: Date
    let title: String
    let amount: String
    
    static var demoEntry: BitcoinWalletEntry {
        BitcoinWalletEntry(
            date: Date(),
            title: "Bitcoin Balance",
            amount: "0.25₿"
        )
    }
}

struct BitcoinWalletWidgetEntryView : View {
    
    var entry: BitcoinWalletEntry
    @Environment(\.redactionReasons) private var redactionReasons
    
    var body: some View {
        ZStack {
            if #unavailable(iOS 17) {
                customRedactActivateView
            }
            VStack(alignment: .leading) {
                Text(entry.title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.orange)
                
    //            Text(entry.amount)
    //                .font(.headline)
    //                .fontWeight(.semibold)
    //                .foregroundColor(.gray)
    //                .privacySensitive()
                if redactionReasons.isEmpty {
                    amountTextView
                } else {
                    amountTextView
                        .blur(radius: 4)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .containerBackground(for: .widget) { }
    }
}

extension BitcoinWalletWidgetEntryView {
    
    private var amountTextView: some View {
        Text(entry.amount)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.gray)
    }
    
    // iOS 16 fix 
    private var customRedactActivateView: some View {
        Text("---")
            .privacySensitive()
            .frame(maxWidth: .infinity, maxHeight: 0.0)
    }
}

struct BitcoinWalletWidget: Widget {
    let kind: String = "BitcoinWalletWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: BitcoinWalletProvider()
        ) { entry in
            BitcoinWalletWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Bitcoin Wallet Widget")
        .description("This is a demo widget.")
        .supportedFamilies([
            .systemSmall
        ])
    }
}

struct BitcoinWalletWidget_Previews: PreviewProvider {
    static var previews: some View {
        BitcoinWalletWidgetEntryView(entry: BitcoinWalletEntry.demoEntry)
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
