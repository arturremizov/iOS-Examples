//
//  AnimatableGradientExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 8.06.25.
//

import SwiftUI

struct AnimatableGradientExample: View {
    @State private var animate = false
    private let gradient1: [UIColor] = [.blue, .green]
    private let gradient2: [UIColor] = [.red, .yellow]
    
    var body: some View {
        VStack(spacing: 40) {
            AnimatableGradient(from: gradient1, to: gradient2, percent: animate ? 1 : 0)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(width: 260, height: 260)
            
            Button("Toggle Gradient") {
                withAnimation(.linear(duration: 1)) {
                    animate.toggle()
                }
            }
        }
    }
}

struct AnimatableGradient: View, Animatable {
    
    var from: [UIColor]
    var to: [UIColor]
    var percent: CGFloat

//    var animatableData: CGFloat {
//        get { percent }
//        set { percent = newValue }
//    }
    
    var body: some View {
        
        let colors = zip(from, to).map { mixColors(color1: $0, color2: $1, percent: percent) }
        
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
            )
    }
    
    private func mixColors(color1: UIColor, color2: UIColor, percent: CGFloat) -> Color {
        guard let components1 = color1.cgColor.components else { return Color(uiColor: color1) }
        guard let components2 = color2.cgColor.components else { return Color(uiColor: color2) }
        
        let red = components1[0] + (components2[0] - components1[0]) * percent
        let green = components1[1] + (components2[1] - components1[1]) * percent
        let blue = components1[2] + (components2[2] - components1[2]) * percent
        
        return Color(red: red, green: green, blue: blue)
    }
}

#Preview {
    AnimatableGradientExample()
}
