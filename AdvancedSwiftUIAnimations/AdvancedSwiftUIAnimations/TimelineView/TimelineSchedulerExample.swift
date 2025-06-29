//
//  TimelineSchedulerExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 21.06.25.
//

import SwiftUI

struct TimelineSchedulerExample: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            TimelineView(.everyMinute) { timeline in
                Text("Every minute: ") +
                Text(timeline.date.timeIntervalSinceReferenceDate.description)
            }
            
            TimelineView(.animation) { timeline in
                Text("Animation: ") +
                Text(timeline.date.timeIntervalSinceReferenceDate.description)
            }
            
            TimelineView(.animation(minimumInterval: 0.3, paused: false)) { timeline in
                Text("Animation min interval 0.3: ") +
                Text(timeline.date.timeIntervalSinceReferenceDate.description)
            }
            
            TimelineView(.everyFiveSeconds) { timeline in
                Text("everyFiveSeconds: ") +
                Text(timeline.date.timeIntervalSinceReferenceDate.description)
            }
        }
    }
}

extension TimelineSchedule where Self == PeriodicTimelineSchedule {
    static var everyFiveSeconds: PeriodicTimelineSchedule {
        .init(from: .now, by: 5.0)
    }
}

#Preview {
    TimelineSchedulerExample()
}
