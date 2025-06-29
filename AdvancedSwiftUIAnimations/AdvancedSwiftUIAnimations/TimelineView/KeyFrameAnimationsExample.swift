//
//  KeyFrameAnimationsExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 23.06.25.
//

import SwiftUI

struct KeyFrameAnimationsExample: View {
    var body: some View {
        JumpingEmoji()
    }
}

#Preview {
    KeyFrameAnimationsExample()
}

enum KeyFrameAnimation {
    case none, linear, easeOut, easeIn

    func animation(duration: TimeInterval) -> Animation? {
        switch self {
        case .none: return nil
        case .linear: return .linear(duration: duration)
        case .easeIn: return .easeIn(duration: duration)
        case .easeOut: return .easeOut(duration: duration)
        }
    }
}

struct KeyFrame {
    let offset: TimeInterval
    let rotation: Double
    let yScale: Double
    let y: CGFloat
    let animationKind: KeyFrameAnimation
    
    var animation: Animation? {
        animationKind.animation(duration: offset)
    }
}

let keyframes = [
    // Initial state
    KeyFrame(offset: 0.0, rotation: 0, yScale: 1.0, y: 0, animationKind: .none),
    // Animation keyframes
    KeyFrame(offset: 0.2, rotation:   0, yScale: 0.5, y:  20, animationKind: .linear),
    KeyFrame(offset: 0.4, rotation:   0, yScale: 1.0, y: -20, animationKind: .linear),
    KeyFrame(offset: 0.5, rotation: 360, yScale: 1.0, y: -80, animationKind: .easeOut),
    KeyFrame(offset: 0.4, rotation: 360, yScale: 1.0, y: -20, animationKind: .easeIn),
    KeyFrame(offset: 0.2, rotation: 360, yScale: 0.5, y:  20, animationKind: .easeOut),
    KeyFrame(offset: 0.4, rotation: 360, yScale: 1.0, y: -20, animationKind: .linear),
    KeyFrame(offset: 0.5, rotation:   0, yScale: 1.0, y: -80, animationKind: .easeOut),
    KeyFrame(offset: 0.4, rotation:   0, yScale: 1.0, y: -20, animationKind: .easeIn),
]

struct JumpingEmoji: View {
    private let offsets = keyframes.dropFirst().map(\.offset)
    var body: some View {
        TimelineView(.cyclic(timeOffsets: offsets)) { timelineView in
            HappyEmoji(date: timelineView.date)
        }
    }
}

struct HappyEmoji: View {
    private struct Effects: ViewModifier {
        let keyframe: KeyFrame
        func body(content: Content) -> some View {
            content
                .scaleEffect(CGSize(width: 1.0, height: keyframe.yScale))
                .rotationEffect(Angle(degrees: keyframe.rotation))
                .offset(y: keyframe.y)
        }
    }
    
    let date: Date
    @State private var index: Int = 0
    var body: some View {
        Text("😃")
            .font(.largeTitle)
            .scaleEffect(4.0)
            .modifier(Effects(keyframe: keyframes[index]))
            .animation(keyframes[index].animation, value: index)
            .onChange(of: date) { _, _ in
                nextKeyFrame()
            }
            .onAppear {
                nextKeyFrame()
            }
        
    }
    
    private func nextKeyFrame() {
        index = (index + 1) % keyframes.count
        if index == 0 { index = 1 }
    }
}
