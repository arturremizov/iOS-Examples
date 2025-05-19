//
//  ImplicitAnimations.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 14.05.25.
//

import SwiftUI

struct ImplicitAnimations: View {
    @State private var isHalf = false
    @State private var isDim = false
    var body: some View {
        Image(systemName: "star.fill")
            .font(.system(size: 240))
            .foregroundStyle(.yellow)
            .scaleEffect(isHalf ? 0.5 : 1.0)
            .animation(.spring, value: isHalf)
            .opacity(isDim ? 0.2 : 1.0)
            .animation(.easeInOut(duration: 0.8), value: isDim)
            .onTapGesture {
                isHalf.toggle()
                isDim.toggle()
            }
        
    }
}

#Preview {
    ImplicitAnimations()
}
