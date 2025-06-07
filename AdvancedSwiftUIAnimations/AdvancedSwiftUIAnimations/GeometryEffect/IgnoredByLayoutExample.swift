//
//  IgnoredByLayoutExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 5.06.25.
//

import SwiftUI

struct IgnoredByLayoutExample: View {
    @State private var animate = false
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.green)
                .frame(width: 300, height: 50)
                .overlay(alignment: .center, content: {
                    SizeView()
                })
                .modifier(
                    OffsetEffect(x: animate ? 10 : -10)
                )
            
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.blue)
                .frame(width: 300, height: 50)
                .overlay(alignment: .center, content: {
                    SizeView()
                })
                .modifier(
                    OffsetEffect(x: animate ? -10 : 10)
                        .ignoredByLayout()
                )
               
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever()) {
                animate = true
            }
        }
    }
}

struct SizeView: View {
    var body: some View {
        GeometryReader { proxy in
            let x = Int(proxy.frame(in: .global).minX)
            Text("x = \(x)")
                .foregroundStyle(.white)
                .font(.headline)
                .frame(width: proxy.size.width, height: proxy.size.height)
            
        }
    }
}

struct OffsetEffect: GeometryEffect {
    var x: CGFloat
    
    var animatableData: CGFloat {
        get { x }
        set { x = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: x, y: 0))
    }
}

#Preview {
    IgnoredByLayoutExample()
}
