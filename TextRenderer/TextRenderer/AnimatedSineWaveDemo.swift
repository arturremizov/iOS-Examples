//
//  AnimatedSineWaveDemo.swift
//  TextRenderer
//
//  Created by Artur Remizov on 20.04.25.
//

import SwiftUI

struct AnimatedSineWaveOffsetRender: TextRenderer {
    let timeOffset: Double
    let fontSize: CGFloat
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        // layout -> [line] -> [run] -> [run slice]
        let runSlices = layout.flatMap { $0 }.flatMap { $0 }
        
        let width = layout.first?.typographicBounds.width ?? 0
        let height = layout.first?.typographicBounds.rect.height ?? 0
        
        for (index, runSlice) in runSlices.enumerated() {
            
            let offset = animatedSineWaveOffset(
                forCharacterAt: index,
                amplitude: height / 2,
                waveLength: width,
                phaseOffset: timeOffset,
                totalCharacters: runSlices.count
            )
            
            var copyContext = ctx
            copyContext.translateBy(x: 0, y: offset)
            copyContext.draw(runSlice)
        }
    }
    
    func sizeThatFits(proposal: ProposedViewSize, text: TextProxy) -> CGSize {
        let originalSize = text.sizeThatFits(proposal)
        return CGSize(width: originalSize.width, height: originalSize.height * 2) // max amplitude
    }
    
    var displayPadding: EdgeInsets {
        let height = fontSize * 1.2
        return EdgeInsets(top: -height / 2, leading: 0, bottom: 0, trailing: 0)
    }
    
    private func animatedSineWaveOffset(forCharacterAt index: Int, amplitude: Double, waveLength: Double, phaseOffset: Double, totalCharacters: Int) -> Double {
        
        let x = Double(index)
        let position = (x / Double(totalCharacters)) * waveLength
        let radians = ((position + phaseOffset) / waveLength) * 2 * .pi
        return sin(radians) * amplitude
    }
}

struct AnimatedSineWaveDemo: View {
    @State private var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State var offset: Double = 0
    var body: some View {
        Text("Build Visual Effects with TextRenderer!")
            .font(.system(size: 16))
            .textRenderer(AnimatedSineWaveOffsetRender(timeOffset: offset, fontSize: 16))
            .border(.blue)
            .onReceive(timer) { _ in
                if offset > 1e4 {
                    offset = 0 // Reset the time offset
                }
                offset += 10
            }
    }
}

#Preview {
    AnimatedSineWaveDemo()
}
