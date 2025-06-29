//
//  TimelineViewClockExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 15.06.25.
//

import SwiftUI

struct TimelineViewClockExample: View {
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { timeline in
            Text(timeline.date.description)
        }
    }
}

#Preview {
    TimelineViewClockExample()
}
