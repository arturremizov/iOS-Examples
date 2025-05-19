//
//  VectorArithmeticExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 15.05.25.
//

import SwiftUI

struct VectorArithmeticExample: View {
    @State private var point = AnimatablePoint(x: 150, y: 150)
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Rectangle()
                    .strokeBorder()
                    .frame(width: 300, height: 300)
                MovingDot(position: point)
                    .fill(Color.red)
                    .animation(.easeInOut(duration: 1), value: point)
            }
            .frame(width: 300, height: 300)
            
            Button("Move to random point") {
                point = AnimatablePoint(
                    x: Double.random(in: 20...280),
                    y: Double.random(in: 20...280)
                )
            }
        }
    }
}

#Preview {
    VectorArithmeticExample()
}

struct AnimatablePoint: VectorArithmetic {
    var x: Double
    var y: Double
    
    mutating func scale(by rhs: Double) {
        x *= rhs
        y *= rhs
    }

    var magnitudeSquared: Double {
        x * x + y * y
    }
    
    static var zero: AnimatablePoint {
        AnimatablePoint(x: 0, y: 0)
    }
    
    static func + (lhs: AnimatablePoint, rhs: AnimatablePoint) -> AnimatablePoint {
        AnimatablePoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func += (lhs: inout AnimatablePoint, rhs: AnimatablePoint) {
        lhs = lhs + rhs
    }
    
    static func - (lhs: AnimatablePoint, rhs: AnimatablePoint) -> AnimatablePoint {
        AnimatablePoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func -= (lhs: inout AnimatablePoint, rhs: AnimatablePoint) {
        lhs = lhs - rhs
    }
}

struct MovingDot: Shape {
    var position: AnimatablePoint
    
    var animatableData: AnimatablePoint {
        get { position }
        set { position = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: position.x, y: position.y)
        path.addEllipse(in: CGRect(x: center.x - 5, y: center.y - 5, width: 10, height: 10))
        return path
    }
}
