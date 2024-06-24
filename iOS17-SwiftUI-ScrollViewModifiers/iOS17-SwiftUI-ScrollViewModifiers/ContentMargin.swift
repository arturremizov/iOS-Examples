//
//  ContentMargin.swift
//  iOS17-SwiftUI-ScrollViewModifiers
//
//  Created by Artur Remizov on 25.06.24.
//

import SwiftUI

struct ContentMargin: View {
    private var padding: CGFloat { 20.0 }
    
    private let colors: [Color] = [.red, .green, .blue, .orange, .purple, .black, .yellow]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                colorsContent
                    .padding(.horizontal, padding)
            }
            
            ScrollView(.horizontal) {
                colorsContent
            }
            .contentMargins(padding)
        }
    }
    
    private var colorsContent: some View {
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
    }
}

#Preview {
    ContentMargin()
}
