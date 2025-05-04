//
//  LineByLineTransitionDemo.swift
//  TextRenderer
//
//  Created by Artur Remizov on 30.04.25.
//

import SwiftUI

struct LineByLineTextRenderer: TextRenderer, Animatable {
    
    var elapsedTime: TimeInterval
    var elementDuration: TimeInterval
    var totalDuration: TimeInterval
    
    var animatableData: Double {
        get { elapsedTime }
        set { elapsedTime = newValue }
    }
    
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        let delay: Double = elementDelay(count: layout.count)
        for (index, line) in layout.enumerated() {
            let timeOffset = TimeInterval(index) * delay
            let elementTime = max(0, min(elapsedTime - timeOffset, elementDuration))
            
            var copy = ctx
            draw(line, at: elementTime, in: &copy)
        }
    }
    
    private func elementDelay(count: Int) -> TimeInterval {
        let count = TimeInterval(count)
        let remainingTime = totalDuration - count * elementDuration
        
        let delay = max(remainingTime / (count + 1), (totalDuration - elementDuration) / count)
        return delay
    }
    
    private func draw(_ line: Text.Layout.Line, at time: TimeInterval, in context: inout GraphicsContext) {
        let progress = time / elementDuration
        let opacity = UnitCurve.easeIn.value(at: 1.4 * progress)
        let blurRadius = line.typographicBounds.rect.height / 16 * UnitCurve.easeIn.value(at: 1 - progress)
        let translationY = spring.value(fromValue: -line.typographicBounds.descent, toValue: 0, initialVelocity: 0, time: time)
        
        context.opacity = opacity
        context.addFilter(.blur(radius: blurRadius))
        context.translateBy(x: 0, y: translationY)
        context.draw(line, options: .disablesSubpixelQuantization)
    }
    
    var spring: Spring {
        .snappy(duration: elementDuration - 0.05, extraBounce: 0.4)
    }
}

struct LineByLineTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        let duration = 0.9
        let elapsedTime = phase.isIdentity ? duration : 0
        let renderer = LineByLineTextRenderer(elapsedTime: elapsedTime, elementDuration: 0.5, totalDuration: duration)
        
        content.transaction { t in
            if !t.disablesAnimations {
                t.animation = .linear(duration: duration)
            }
        } body: { view in
            view.textRenderer(renderer)
        }
    }
}

struct LineByLineTransitionDemo: View {
    @State private var show = true
    var body: some View {
        VStack {
            if show {
                let text = Text("Text Transition")
                    .foregroundStyle(.pink)
                Text("Line by Line\n\(text)\nwith SwiftUI")
                    .font(.title)
                    .fontDesign(.rounded)
                    .bold()
                    .transition(LineByLineTransition())
            }
            Spacer()
            GroupBox {
                Toggle("Show", isOn: $show.animation())
            }
        }
        .frame(height: 200)
        
    }
}

#Preview {
    LineByLineTransitionDemo()
}
