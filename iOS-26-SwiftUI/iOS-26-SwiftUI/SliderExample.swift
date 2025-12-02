//
//  SliderExample.swift
//  iOS-26-SwiftUI
//
//  Created by Artur Remizov on 2.12.25.
//

import SwiftUI

struct SliderExample: View {
    
    @State private var value = 0.5
    @State private var value2 = 0.5
    @State private var value3 = 0.5
    @State private var value4 = 0.5
    @State private var value5 = 0.5
    @State private var value6 = 0.5

    var body: some View {
        VStack {
            Slider(value: $value)
            
            Slider(value: $value2)
                .sliderThumbVisibility(.hidden)
            
            Slider(value: $value3, in: 0...1, step: 0.25)
            
            Slider(value: $value4, in: 0...1, step: 0.25) {
            } tick: { point in
                SliderTick(point) {
                    Text("\(point)")
                }
            }
            
            Slider(value: $value5, neutralValue: 0.5) { }
            
            Slider(value: $value6, enabledBounds: 0...0.75) { }

        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    SliderExample()
}
