//
//  ShapePaths.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 14.05.25.
//

import SwiftUI

struct ShapePathsExample: View {
    @State private var sides: Int = 3
    var body: some View {
        VStack(spacing: 32) {
            PolygonShape(sides: sides)
                .stroke(Color.blue, lineWidth: 3)
                .fill(Color.blue.opacity(0.0001))
                .animation(.easeInOut(duration: 1), value: sides)
      
            Text("\(sides) sides")
            
            HStack {
                CustomButton(text: "3") {
                    sides = 3
                }
                CustomButton(text: "5") {
                    sides = 5
                }
                CustomButton(text: "7") {
                    sides = 7
                }
                CustomButton(text: "30") {
                    sides = 30
                }
            }
        }
        .padding(.all, 32)
    }
}

#Preview {
    ShapePathsExample()
}

struct CustomButton: View {
    let text: String
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.title)
                .foregroundStyle(.white)
                .padding(10)
                .frame(width: 70)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.green)
                        .shadow(radius: 2)
                )

        }
    }
}

struct PolygonShape: Shape {
    var sides: Int
    private var sidesAsDouble: Double
    
    var animatableData: Double {
        get { sidesAsDouble }
        set { sidesAsDouble = newValue }
    }
    
    init(sides: Int) {
        self.sides = sides
        self.sidesAsDouble = Double(sides)
    }
    
    func path(in rect: CGRect) -> Path {
        // hypotenuse
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0
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
