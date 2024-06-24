//
//  ScrollTransition.swift
//  iOS17-SwiftUI-ScrollViewModifiers
//
//  Created by Artur Remizov on 25.06.24.
//

import SwiftUI

struct ScrollTransition: View {
    private var padding: CGFloat { 40.0 }
    
    private let colors: [Color] = [.red, .green, .blue, .orange, .purple, .black, .yellow]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(colors, id: \.self) { color in
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(color.gradient)
                        .frame(height: 200)
                        .containerRelativeFrame(.horizontal, alignment: .center) { length, _ in
                            return length - padding * 2
                        }
                        .scrollTransition(
                            topLeading: .interactive,
                            bottomTrailing: .interactive) { view, phase in
                                view
                                    .opacity(1 - (phase.value < 0 ? -phase.value : phase.value))
                                    .scaleEffect(1 - (phase.value < 0 ? 0 : phase.value))
                            }
                }
            }
            .padding(.horizontal, padding)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    ScrollTransition()
}
