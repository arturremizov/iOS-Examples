//
//  BackgroundExtensionEffect.swift
//  iOS-26-SwiftUI
//
//  Created by Artur Remizov on 1.12.25.
//

import SwiftUI

struct BackgroundExtensionEffect: View {
    var body: some View {
        VStack {
            Image(.test)
                .resizable()
                .scaledToFill()
                .backgroundExtensionEffect(isEnabled: true)
        }
        .safeAreaInset(edge: .bottom) {
            Text("Background Extension Effect")
                .font(.headline)
                .bold()
                .foregroundStyle(.white)
                .frame(height: 160)
        }
    }
}

#Preview {
    BackgroundExtensionEffect()
}
