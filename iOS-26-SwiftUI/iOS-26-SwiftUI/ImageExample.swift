//
//  ImageExample.swift
//  iOS-26-SwiftUI
//
//  Created by Artur Remizov on 2.12.25.
//

import SwiftUI

struct ImageExample: View {
    @State private var value: Double = 0.0
    @State private var animate: Bool = false
    
    var body: some View {
        Image(systemName: "bolt.house.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundStyle(.orange.gradient)
        
        Image(systemName: "cloud.sun.rain.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
//            .symbolRenderingMode(.palette)
            .foregroundStyle(.gray.gradient, .yellow.gradient, .blue.gradient)
           
        VStack {
            Slider(value: $value)
                .padding(.horizontal, 32)
            
            Image(systemName: "speaker.wave.3.fill", variableValue: value)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .symbolVariableValueMode(.draw)
        }
        
        VStack {
            Button("Animate") {
                animate.toggle()
            }
            
            Image(systemName: "atom")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .symbolEffect(
                    .drawOn.individually,
                    options: .speed(0.1),
                    isActive: animate
                )
        }
        
    }
}

#Preview {
    ImageExample()
}
