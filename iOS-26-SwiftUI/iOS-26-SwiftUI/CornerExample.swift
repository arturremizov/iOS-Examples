//
//  CornerExample.swift
//  iOS-26-SwiftUI
//
//  Created by Artur Remizov on 2.12.25.
//

import SwiftUI

struct CornerExample: View {
    var body: some View {
        
//        ConcentricRectangle()
        Rectangle()
            .fill(.blue.gradient)
            .clipShape(
//                .rect(topLeadingRadius: 26,
//                      bottomLeadingRadius: 10,
//                      bottomTrailingRadius: 26,
//                      topTrailingRadius: 10)
                
                .rect(corners: .concentric)
            )
            .padding()
            .ignoresSafeArea()
            .sheet(isPresented: .constant(true)) {
                ConcentricRectangle()
                    .fill(.purple.gradient)
                    .padding()
                    .ignoresSafeArea()
                    .presentationDetents([.medium])
            }
//            .popover(isPresented: .constant(true)) {
//                ConcentricRectangle(
//                    corners: .concentric, isUniform: true
//                )
//                .fill(.green.gradient)
//                .frame(width: 200, height: 200)
//                .padding()
//                .presentationDetents([.medium])
//                .presentationCompactAdaptation(.popover)
//            }
    }
}

#Preview {
    CornerExample()
}
