//
//  ScrollPosition.swift
//  iOS17-SwiftUI-ScrollViewModifiers
//
//  Created by Artur Remizov on 30.04.24.
//

import SwiftUI

struct ScrollPosition: View {
    
    private var padding: CGFloat { 40.0 }
    
    private let colors: [Color] = [.red, .green, .blue, .orange, .purple, .black, .yellow]
    @State private var itemPosition: Color?
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(color.gradient)
                            .frame(height: 200)
                            .containerRelativeFrame(.horizontal, alignment: .center) { length, _ in
                                return length - padding * 2
                            }
                    }
                }
                .padding(.horizontal, padding)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $itemPosition)
            
            if let itemPosition {
                Text(itemPosition.description.capitalized)
                    .font(.title)
            }
            Button("Toggle Random Color") {
                let randomColor = colors.randomElement()
                withAnimation {
                    itemPosition = randomColor
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            itemPosition = colors.first
        }
    }
}

#Preview {
    ScrollPosition()
}
