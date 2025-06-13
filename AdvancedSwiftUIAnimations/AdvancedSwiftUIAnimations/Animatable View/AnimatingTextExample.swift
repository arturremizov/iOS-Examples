//
//  AnimatingTextExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 7.06.25.
//

import SwiftUI

struct AnimatingTextExample: View {
    @State private var percent: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 40) {
            PercentageIndicator(percent: percent)
                .frame(width: 160, height: 160)
            
            HStack(spacing: 40) {
                Button("0%") {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        percent = 0
                    }
                }
                Button("27%") {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        percent = 0.27
                    }
                }
                Button("100%") {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        percent = 1
                    }
                }
            }
        }
    }
}

struct PercentageIndicator: View, Animatable {
    
    var percent: CGFloat = 0
    
    var animatableData: CGFloat {
        get { percent }
        set { percent = newValue }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("\(Int(percent * 100)) %")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            ArcShape(percent: percent)
                .foregroundStyle(.red)
        }
    }
}

struct ArcShape: Shape {
    let percent: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.width / 2, y: rect.height / 2),
            radius: rect.height / 2 + 5,
            startAngle: .degrees(0),
            endAngle: .degrees(360 * Double(percent)),
            clockwise: false)
        return path
            .strokedPath(.init(lineWidth: 10, dash: [6,3], dashPhase: 10))
    }
}

#Preview {
    AnimatingTextExample()
}
