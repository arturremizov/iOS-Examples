//
//  AnimatedSymbolsExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 1.07.25.
//

import SwiftUI

struct AnimatedSymbolsExample: View {
    var body: some View {
        Canvas { context, size in
            let symbol = context.resolveSymbol(id: 1)!
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            context.draw(symbol, at: center, anchor: .center)
        } symbols: {
            SpinningView()
                .tag(1)
        }
    }
}

fileprivate struct SpinningView: View {
    @State private var flag = true
    var body: some View {
        Text("🏐")
            .font(.system(size: 72))
            .rotationEffect(.degrees(flag ? 0 : 360))
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    flag.toggle()
                }
            }
    }
}


#Preview {
    AnimatedSymbolsExample()
}

