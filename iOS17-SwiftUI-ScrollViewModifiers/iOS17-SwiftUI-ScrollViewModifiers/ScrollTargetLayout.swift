//
//  ScrollTargetLayout.swift
//  iOS17-SwiftUI-ScrollViewModifiers
//
//  Created by Artur Remizov on 29.04.24.
//

import SwiftUI

struct ScrollTargetLayout: View {
    
    private let colors: [Color] = [.red, .green, .blue, .orange, .purple, .black, .yellow]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(color.gradient)
                            .frame(height: 200)
                            .padding(40)
                            .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            
            
            let padding: CGFloat = 40
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
        }
    }
}

#Preview {
    ScrollTargetLayout()
}
