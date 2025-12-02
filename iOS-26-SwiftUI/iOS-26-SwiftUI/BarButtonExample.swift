//
//  BarButtonExample.swift
//  iOS-26-SwiftUI
//
//  Created by Artur Remizov on 1.12.25.
//

import SwiftUI

struct BarButtonExample: View {
    
    @State private var count: Int = 0
    @State private var isShowingModal: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                NavigationLink("Push") {
                    DetailsView()
                }
                
                Button("Show modal") {
                    isShowingModal.toggle()
                }
            }
            .navigationTitle("Bar Button")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Minus", systemImage: "minus", action: {
                        count = max(0, count - 1)
                    })
                }
//                .sharedBackgroundVisibility(.hidden)
                
                ToolbarSpacer(placement: .topBarLeading)
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Plus", systemImage: "plus", action: {
                        count += 1
                    })
                    .badge(count)
                }
                
                ToolbarItem(id: "disable-animation-id") {
                    Button("Label") {}
                }
            }
            .sheet(isPresented: $isShowingModal) {
                ModalView()
            }
        }
    }
    
    struct DetailsView: View {
        var body: some View {
            Text("DetailsView")
                .toolbar {
                    ToolbarItem(id: "disable-animation-id") {
                        Button("Label") {}
                    }
                }
        }
    }
    
    struct ModalView: View {
        var body: some View {
            NavigationStack {
                Text("ModalView")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(role: .close) { }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(role: .confirm) { }
//                                .buttonStyle(.glassProminent)
                        }
                    }
            }
        }
    }
}


#Preview {
    BarButtonExample()
}
