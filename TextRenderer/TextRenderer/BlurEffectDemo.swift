//
//  BlurEffectDemo.swift
//  TextRenderer
//
//  Created by Artur Remizov on 30.04.25.
//

import SwiftUI

struct BlurAttribute: TextAttribute {}

struct BlurEffectRenderer: TextRenderer {
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        // layout -> [line] -> [run]
        let runs = layout.flatMap { $0 }
        for run in runs {
            if run[BlurAttribute.self] != nil {
                var contextCopy = ctx
                let radius = run.typographicBounds.rect.height / 5
                contextCopy.addFilter(.blur(radius: radius))
                contextCopy.draw(run)
            }
            ctx.draw(run)
        }
    }
}

struct BlurEffectDemo: View {
    var body: some View {
        let text = Text("Text with Blur Attribute")
            .bold()
            .foregroundStyle(.pink)
            .customAttribute(BlurAttribute())
        
        Text("Insert [\(text)] here.")
            .textRenderer(BlurEffectRenderer())
    }
}

#Preview {
    BlurEffectDemo()
}
