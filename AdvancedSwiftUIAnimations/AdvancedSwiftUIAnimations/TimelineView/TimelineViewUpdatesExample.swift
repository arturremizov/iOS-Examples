//
//  TimelineViewUpdatesExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 29.06.25.
//

import SwiftUI

struct TimelineViewUpdatesExample: View {
    var body: some View {
        TimelineView(.periodic(from: .now, by: 2.0)) { timeline in
            Subview(date: timeline.date)
        }
    }
    struct Subview: View {
        @State private var flag = false
        let date: Date
        var body: some View {
            Text("Hello, World!")
                .foregroundStyle(flag ? .red : .blue)
                .onChange(of: date) { _, _ in
                    flag.toggle()
                }
        }
    }
}

#Preview {
    TimelineViewUpdatesExample()
}
