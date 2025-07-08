//
//  GraphicsContextTextExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 1.07.25.
//

import SwiftUI

struct GraphicsContextTextExample: View {
    var body: some View {
        Canvas { context, size in
            let midPoint = CGPoint(x: size.width / 2, y: size.height / 2)
            let font = Font.custom("Arial Rounded MT Bold", size: 36)
            let text = Text("Hello World!").font(font)
            var resolvedText = context.resolve(text)
            
            let start = CGPoint(x: (size.width - resolvedText.measure(in: size).width) / 2.0, y: 0)
            let end = CGPoint(x: size.width - start.x, y: 0)
            
            resolvedText.shading = .linearGradient(
                Gradient(colors: [.green, .blue]),
                startPoint: start,
                endPoint: end
            )
            
            context.draw(resolvedText, at: midPoint, anchor: .center)
        }
    }
}

#Preview {
    GraphicsContextTextExample()
}
