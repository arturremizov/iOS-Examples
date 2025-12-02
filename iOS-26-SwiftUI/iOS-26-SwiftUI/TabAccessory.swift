//
//  TabAccessory.swift
//  iOS-26-SwiftUI
//
//  Created by Artur Remizov on 2.12.25.
//

import SwiftUI

struct TabAccessory: View {
    @State private var searchText = ""
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                homeView
            }
            Tab("New", systemImage: "square.split.2x2.fill") {
                Text("New")
            }
            Tab("Radio", systemImage: "dot.radiowaves.left.and.right") {
                Text("Radio")
            }
            Tab("Library", systemImage: "play.square.stack.fill") {
                Text("Library")
            }
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                NavigationStack {
                    Text("Search")
                }
            }
        }
        .searchable(text: $searchText)
        .tint(.red)
        .tabViewBottomAccessory {
            miniPayerView
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
    
    private var miniPayerView: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.purple.gradient)
                .aspectRatio(1, contentMode: .fit)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Tunnel of Love")
                    .font(.subheadline)
                    .bold()
                Text("Dire Straits")
                    .font(.footnote)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button { } label: {
                    Image(systemName: "play.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.foreground)
                }
                
                Button { } label: {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.foreground)
                }
            }
            .padding(.vertical, 7)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
    
    private var homeView: some View {
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
    }
}

#Preview {
    TabAccessory()
}
