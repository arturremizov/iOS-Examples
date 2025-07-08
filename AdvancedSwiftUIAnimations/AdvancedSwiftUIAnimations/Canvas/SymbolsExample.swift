//
//  SymbolsExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 1.07.25.
//

import SwiftUI

struct SymbolsExample: View {
    private let colors: [Color] = [.cyan, .blue, .indigo]
    var body: some View {
        Canvas { context, size in
            let rectangle0 = context.resolveSymbol(id: 0)!
            let rectangle1 = context.resolveSymbol(id: 1)!
            let rectangle2 = context.resolveSymbol(id: 2)!

            context.draw(rectangle0, at: CGPoint(x: 10, y: 10), anchor: .topLeading)
            context.draw(rectangle1, at: CGPoint(x: 30, y: 20), anchor: .topLeading)
            context.draw(rectangle2, at: CGPoint(x: 50, y: 30), anchor: .topLeading)
            context.draw(rectangle0, at: CGPoint(x: 70, y: 40), anchor: .topLeading)
            
        } symbols: {
            ForEach(Array(colors.enumerated()), id: \.0) { i, color in
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(width: 100, height: 50)
                    .tag(i)
            }
        }
        .frame(width: 200, height: 100, alignment: .center)
    }
}

#Preview {
    SymbolsExample()
}
