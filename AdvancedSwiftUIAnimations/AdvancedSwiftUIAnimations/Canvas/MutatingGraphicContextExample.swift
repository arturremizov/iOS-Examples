//
//  MutatingGraphicContextExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 8.07.25.
//

import SwiftUI

struct MutatingGraphicContextExample: View {
    var body: some View {
        Canvas { context, size in
            
//            context.withCGContext { cgContext in
//
//            }
            
            let scaleFactor: CGFloat = 4
            context.scaleBy(x: scaleFactor, y: scaleFactor)
            
            let mid = CGPoint(x: size.width / (2 * scaleFactor), y: size.height / (2 * scaleFactor))
            
            var house = context.resolve(Image(systemName: "house.fill"))
            
            // left house
            house.shading = .color(.red)
            context.draw(house, at: mid - CGPoint(x: house.size.width, y: 0), anchor: .center)
            
            
            // center house
//            var blurContext = context
//            blurContext.addFilter(.blur(radius: 1, options: .dithersResult), options: .linearColor)
//            house.shading = .color(.green)
//            blurContext.draw(house, at: mid, anchor: .center)
            
            context.drawLayer { layerContext in
                layerContext.addFilter(.blur(radius: 1, options: .dithersResult), options: .linearColor)
                house.shading = .color(.green)
                layerContext.draw(house, at: mid, anchor: .center)
            }
            
            
            // right house
            house.shading = .color(.blue)
            context.draw(house, at: mid + CGPoint(x: house.size.width, y: 0), anchor: .center)
            
//            // center house
//            context.addFilter(.blur(radius: 1, options: .dithersResult), options: .linearColor)
//            house.shading = .color(.green)
//            context.draw(house, at: mid, anchor: .center)
        }
    }
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

#Preview {
    MutatingGraphicContextExample()
}
