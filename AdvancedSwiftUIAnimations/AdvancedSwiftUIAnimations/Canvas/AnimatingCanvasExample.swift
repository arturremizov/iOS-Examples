//
//  AnimatingCanvasExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 8.07.25.
//

import SwiftUI

struct AnimatingCanvasExample: View {
    var body: some View {
        SimpleClock()
            .frame(width: 200, height: 200)
            .background(Color.black.opacity(0.1))
    }
}

#Preview {
    AnimatingCanvasExample()
}

struct SimpleClock: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0)) { timeline in
            Canvas { context, size in
                let date = timeline.date
                let angle = Calendar.current.component(.second, from: date) * 6  // 360 / 60 = 6 degrees per second
                
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius = min(size.width, size.height) / 2.5
                
                // Draw clock hand
                context.translateBy(x: center.x, y: center.y)
                context.rotate(by: .degrees(Double(angle)))
                
                let hand = Path { path in
                    path.move(to: .zero)
                    path.addLine(to: CGPoint(x: 0, y: -radius))
                }
                
                context.stroke(hand, with: .color(.red), lineWidth: 2)
                
                // Draw center dot
                let dot = Path(ellipseIn: CGRect(x: -4, y: -4, width: 8, height: 8))
                context.fill(dot, with: .color(.black))
            }
        }
    }
}
