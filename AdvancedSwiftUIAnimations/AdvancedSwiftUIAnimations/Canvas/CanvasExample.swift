//
//  CanvasExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 29.06.25.
//

import SwiftUI

struct CanvasExample: View {
    var body: some View {
        Canvas { context, size in
            let padding: CGFloat = 24
            let rect = CGRect(origin: .zero, size: size).insetBy(dx: padding, dy: padding)
            
            let path = Path(roundedRect: rect, cornerRadius: 32, style: .continuous)
            
            let gradient = Gradient(colors: [.green, .blue])
            let from = rect.origin
            let to = CGPoint(x: rect.width, y: rect.height)
            
            context.stroke(path, with: .color(.blue), lineWidth: 24)
            context.fill(path, with: .linearGradient(gradient, startPoint: from, endPoint: to))
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    CanvasExample()
}
