//
//  TimelineQuotesExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 15.06.25.
//

import SwiftUI

struct TimelineQuotesExample: View {
    var body: some View {
        TimelineView(.periodic(from: .now, by: 3.0)) { timeline in
            QuoteView(date: timeline.date)
                .padding(.horizontal, 32)
        }
    }
}

fileprivate struct QuoteView: View {
    let date: Date
    @State private var quotesDataBase = QuotesDatabase()
    var body: some View {
        Text(quotesDataBase.sentence)
            .onChange(of: date) { _, _ in
                quotesDataBase.advance()
            }
    }
}

@Observable
fileprivate class QuotesDatabase {
    static let sentences = [
        "I would love to change the world, but they won’t give me the source code.",
        "Why do Java developers wear glasses? Because they don’t C#.",
        "There are 10 kinds of people: those who understand binary and those who don’t.",
        "Debugging: Being the detective in a crime movie where you are also the murderer."
    ]
    
    @ObservationIgnored
    private var index: Int = 0
    
    private(set) var sentence: String = QuotesDatabase.sentences[0]
    
    func advance() {
        index = (index + 1) % QuotesDatabase.sentences.count
        sentence = QuotesDatabase.sentences[index]
    }
}

#Preview {
    TimelineQuotesExample()
}
