//
//  ExplicitAnimations.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 14.05.25.
//

import SwiftUI

struct ExplicitAnimations: View {
    @State private var isHalf = false
    @State private var isDim = false
    var body: some View {
        Image(systemName: "star.fill")
            .font(.system(size: 240))
            .foregroundStyle(.yellow)
            .scaleEffect(isHalf ? 0.5 : 1.0)
            .opacity(isDim ? 0.2 : 1.0)
            .onTapGesture {
                withAnimation(.spring) {
                    isHalf.toggle()
                }
                withAnimation(.easeInOut(duration: 0.8)) {
                    isDim.toggle()
                }
            }
        
    }
}

#Preview {
    ExplicitAnimations()
}
