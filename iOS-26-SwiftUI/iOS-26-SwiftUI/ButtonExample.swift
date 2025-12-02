//
//  ButtonExample.swift
//  iOS-26-SwiftUI
//
//  Created by Artur Remizov on 1.12.25.
//

import SwiftUI

struct ButtonExample: View {
    
    @State private var didPressLikeButton = false
    
    var body: some View {
        ZStack {
            Image(.image2)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Button("Grass") {}
                    .controlSize(.large)
                    .buttonStyle(.glass)
                
                Button("Clear Grass") {}
                    .foregroundStyle(.white)
                    .controlSize(.large)
                    .buttonStyle(.glass(.clear))
                
                Button("Prominent Grass") {}
                    .controlSize(.large)
                    .buttonStyle(.glassProminent)
            
                
                Button("", systemImage: didPressLikeButton ? "suit.heart.fill" : "heart") {
                    didPressLikeButton.toggle()
                }
                .contentTransition(.symbolEffect(.replace))
                .buttonBorderShape(.circle)
                .controlSize(.large)
                .buttonStyle(.glassProminent)
                .tint(.red)
            }
        }
    }
}

#Preview {
    ButtonExample()
}
