//
//  AnimatablePairsExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 15.05.25.
//

import SwiftUI

struct AnimatablePairsExample: View {
    @State private var sides: Int = 3
    @State private var scale: Double = 1
    var body: some View {
        VStack(spacing: 32) {
            ScaledPolygonShape(sides: sides, scale: scale)
                .stroke(Color.blue, lineWidth: 3)
                .fill(Color.blue.opacity(0.0001))
                .animation(.easeInOut(duration: 1), value: sides)
      
            
            Text("\(sides) sides, scale: \(scale.formatted())")
            
            HStack {
                CustomButton(text: "3") {
                    sides = 3
                    scale = 1.0
                }
                CustomButton(text: "5") {
                    sides = 5
                    scale = 0.7
                }
                CustomButton(text: "7") {
                    sides = 7
                    scale = 0.4
                }
                CustomButton(text: "30") {
                    sides = 30
                    scale = 1.0
                }
            }
        }
        .padding(.all, 32)
    }
}

#Preview {
    AnimatablePairsExample()
}

struct ScaledPolygonShape: Shape {
    var sides: Int
    private var sidesAsDouble: Double
    var scale: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(sidesAsDouble, scale) }
        set {
            sidesAsDouble = newValue.first
            scale = newValue.second
        }
    }
    
    init(sides: Int, scale: Double) {
        self.sides = sides
        self.sidesAsDouble = Double(sides)
        self.scale = scale
    }
    
    func path(in rect: CGRect) -> Path {
        // hypotenuse
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0 * scale
        // center
        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        var path = Path()
        let extra: Int = Double(sidesAsDouble) != Double(Int(sidesAsDouble)) ? 1 : 0
        for i in 0..<Int(sidesAsDouble) + extra {
            let angle = (Double(i) * (360.0 / Double(sidesAsDouble))) * Double.pi / 180
            // Calculate vertex position
            let pt = CGPoint(x: c.x + CGFloat(cos(angle) * h), y: c.y + CGFloat(sin(angle) * h))
            if i == 0 {
                path.move(to: pt) // move to first vertex
            } else {
                path.addLine(to: pt) // draw line to next vertex
            }
        }
        path.closeSubpath()
        return path
    }
}
