//
//  AnimationKeyframesExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 19.05.25.
//

import SwiftUI

struct SkewedOffset: GeometryEffect {
    var offset: CGFloat
    var progress: CGFloat
    let isGoingRight: Bool
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(offset, progress) }
        set {
            offset = newValue.first
            progress = newValue.second
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        var skew: CGFloat
        if progress < 0.2 {
            skew = (progress * 5) * 0.5 * (isGoingRight ? -1 : 1)
        } else if progress > 0.8 {
            skew = ((1 - progress) * 5) * 0.5 * (isGoingRight ? -1 : 1)
        } else {
            skew = 0.5 * (isGoingRight ? -1 : 1)
        }
 
        return ProjectionTransform(CGAffineTransform(1, 0, skew, 1, offset, 0))
    }
}

struct AnimationKeyframesExample: View {
    @State private var isMovingRight = false
    var body: some View {
        VStack(spacing: 24) {
            Text("Hello, World!")
                .font(.headline)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.green)
                )
                .modifier(
                    SkewedOffset(
                        offset: isMovingRight ? 120 : -120,
                        progress: isMovingRight ? 1 : 0,
                        isGoingRight: isMovingRight)
                )
                .animation(.easeInOut(duration: 1), value: isMovingRight)
            
            Button("Animate") {
                isMovingRight.toggle()
            }
        }
        
    }
}

#Preview {
    AnimationKeyframesExample()
}
