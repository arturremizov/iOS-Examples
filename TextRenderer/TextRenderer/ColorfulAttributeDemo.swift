//
//  ColorfulAttributeDemo.swift
//  TextRenderer
//
//  Created by Artur Remizov on 30.04.25.
//

import SwiftUI

struct ColorfulAttribute: TextAttribute {}

struct ColorfulAttributeRender: TextRenderer {
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        // layout -> [line] -> [run] -> [run slice]
        let runSlices = layout.flatMap { $0 }.flatMap { $0 }
        for (index, slice) in runSlices.enumerated() {
            if slice[ColorfulAttribute.self] != nil {
                let degree = Angle.degrees(360 / Double(index))
                var contextCopy = ctx
                contextCopy.addFilter(.hueRotation(degree))
                contextCopy.draw(slice)
            } else {
                ctx.draw(slice)
            }
        }
    }
}

struct ColorfulAttributeDemo: View {
    var body: some View {
        let text = Text("Colorful Attribute")
            .bold()
            .foregroundStyle(.orange)
            .customAttribute(ColorfulAttribute())
        
        Text("Insert [\(text)] here.")
            .textRenderer(ColorfulAttributeRender())
    }
}

#Preview {
    ColorfulAttributeDemo()
}
