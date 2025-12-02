//
//  ScrollEdgeEffectExample.swift
//  iOS-26-SwiftUI
//
//  Created by Artur Remizov on 2.12.25.
//

import SwiftUI

struct ScrollEdgeEffectExample: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(0..<30) { _ in
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.mint.gradient)
                            .frame(width: 64, height: 64)
                        VStack(alignment: .leading) {
                            Text("Title")
                                .font(.headline)
                            Text("Subtitle")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
            }
            .scrollEdgeEffectStyle(.hard, for: .top)
            .scrollEdgeEffectStyle(.soft, for: .bottom)
            .navigationTitle("ScrollEdgeEffect")
            .toolbar {
                ToolbarSpacer(placement: .bottomBar)
                
                ToolbarItem(placement: .bottomBar) {
                    Button { } label: {
                        Image(systemName: "plus")
                    }

                }
            }
        }
    }
}

#Preview {
    ScrollEdgeEffectExample()
}
