//
//  ContentView.swift
//  LocalizeWithStringCatalog
//
//  Created by Artur Remizov on 16.01.24.
//

import SwiftUI

// To localize custom views, strings need to be of type 'LocalizedStringResource' instead of 'String'
struct CustomView: View {
    let title: LocalizedStringResource
    let subtitle: LocalizedStringResource
    var body: some View {
        VStack {
            Text(title)
            Text(subtitle)
        }
    }
}

struct ContentView: View {
    
    @State private var bookCount: Int = 1
    
    private let cancelButtonTitle = String(
        localized: "Cancel.order.new",
        defaultValue: "Cancel",
        comment: "Cancel Button on the new order screen"
    )
    
    private let cancelOrderInProgress = String(
        localized: "Cancel.order.in.progress",
        defaultValue: "Cancel",
        comment: "Cancel Button on the orders in progress screen"
    )
    
    // Non-localizable string
    let appName = Text(verbatim: "AppName")
    
    var body: some View {
        VStack(spacing: 24.0) {
            Text("Buy Books")
                .font(.largeTitle)
            
            Image(systemName: "books.vertical.fill")
                .resizable()
                .foregroundStyle(Color.red)
                .frame(width: 100, height: 100)
            
            Text("How many books would you like to buy?")
            Stepper("\(bookCount) book", value: $bookCount, in: 1...100)
                .font(.headline)
                .frame(width: 200)
            
            Link(destination: URL(string: "https://www.url.com")!) {
                Text("Tap to learn more!")
            }
            .font(.headline)
            .foregroundStyle(Color.red)
            
            HStack(spacing: 24.0) {
                Button(cancelButtonTitle) { }
                    .buttonStyle(.bordered)
                Button("Buy") { }
                .buttonStyle(.borderedProminent)
            }
            .tint(Color.red)

            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
