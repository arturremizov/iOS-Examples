//
//  CustomTimelineSchedulerExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 21.06.25.
//

import SwiftUI

struct CustomTimelineSchedulerExample: View {
    var body: some View {
        TimelineView(.cyclic(timeOffsets: [0.2, 0.2, 0.4])) { timeline in
            HeartView(date: timeline.date)
        }
    }
}

struct HeartView: View {
    
    let date: Date
    @State private var phase = 0
    private let scales: [CGFloat] = [1.0, 1.6, 2.0]
    
    var body: some View {
        Text("❤️")
            .font(.largeTitle)
            .scaleEffect(scales[phase])
            .animation(
                .spring(response: 0.1, dampingFraction: 0.24, blendDuration: 0.2),
                value: phase
            )
            .onChange(of: date) { _, _ in
                moveToNextPhase()
            }
            .onAppear {
                moveToNextPhase()
            }
    }
    
    private func moveToNextPhase() {
        phase = (phase + 1) % scales.count
    }
}

#Preview {
    CustomTimelineSchedulerExample()
}
