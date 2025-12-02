//
//  NavigationItemExample.swift
//  iOS-26-SwiftUI
//
//  Created by Artur Remizov on 2.12.25.
//

import SwiftUI

struct NavigationItemExample: View {
    @State private var searchText: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                Text("NavigationItemExample")
            }
            .navigationTitle("Title")
            .navigationSubtitle("Subtitle")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        }
    }
}

#Preview {
    NavigationItemExample()
}
