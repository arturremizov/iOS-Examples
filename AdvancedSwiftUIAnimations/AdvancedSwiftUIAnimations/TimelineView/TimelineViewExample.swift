//
//  TimelineViewExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 15.06.25.
//

import SwiftUI

struct TimelineViewExample: View {
    let emoji = ["😀", "😬", "😄", "🙂", "😗", "🤓", "😏", "😕", "😟", "😎", "😜", "😍", "🤪"]
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.2)) { timeline in
            HStack(spacing: 120) {
                Text(emoji.randomElement()!)
                    .font(.largeTitle)
                    .scaleEffect(4.0)
                
                SubView(emoji: emoji.randomElement()!)
            }
        }
    }
    
    struct SubView: View {
        let emoji: String
        var body: some View {
            Text(emoji)
                .font(.largeTitle)
                .scaleEffect(4.0)
        }
    }
}

#Preview {
    TimelineViewExample()
}
