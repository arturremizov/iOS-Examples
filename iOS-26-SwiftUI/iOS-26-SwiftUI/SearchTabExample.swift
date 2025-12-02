//
//  SearchTabExample.swift
//  iOS-26-SwiftUI
//
//  Created by Artur Remizov on 2.12.25.
//

import SwiftUI

struct SearchTabExample: View {
    
    @State private var searchText = ""
    
    var body: some View {
        TabView {
            Tab("Library", systemImage: "photo.on.rectangle") {
                Text("Library")
            }
            Tab("Collections", systemImage: "rectangle.stack.fill") {
                Text("Collections")
            }
            
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                NavigationStack {
                    Text("Search")
                }
            }
            
        }
        .tabBarMinimizeBehavior(.automatic)
        .searchable(text: $searchText)
    }
}

#Preview {
    SearchTabExample()
}
