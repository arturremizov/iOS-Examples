//
//  ColorfulDemo.swift
//  TextRenderer
//
//  Created by Artur Remizov on 20.04.25.
//

import SwiftUI

struct ColorfulTextRender: TextRenderer {
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        // layout -> [line] -> [run] -> [run slice]
        let runSlices = layout.flatMap { $0 }.flatMap { $0 }
        
        for (index, slice) in runSlices.enumerated() {
            let degree = Angle.degrees(360 / Double(index + 1))
            var copyCtx = ctx
            copyCtx.addFilter(.hueRotation(degree))
            copyCtx.draw(slice)
        }
    }
}

struct ColorfulDemo: View {
    var body: some View {
        let heart = Image(systemName: "heart.fill")
        Text("Hello \(heart) World")
            .font(.title)
            .fontWeight(.heavy)
            .foregroundStyle(.red)
            .textRenderer(ColorfulTextRender())
    }
}

#Preview {
    ColorfulDemo()
}

