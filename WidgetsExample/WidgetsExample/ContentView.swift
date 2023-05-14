//
//  ContentView.swift
//  WidgetsExample
//
//  Created by Artur Remizov on 11.05.23.
//

import SwiftUI

struct ContentView: View {
     
    @State private var widgetBackgroundColor: BackgroundColor? = nil
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Widget Demo App!")
        }
        .padding()
        .sheet(item: $widgetBackgroundColor) { backgroundColor in
            VStack {
                Text("\(backgroundColor.colorName) view".capitalized)
                    .font(.largeTitle)
                    .foregroundColor(.white)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor.color)
        }
        .onOpenURL { url in
            handleWidgetDeepLink(url)
        }
    }
    
    private func handleWidgetDeepLink(_ url: URL) {
        guard
            let scheme = url.scheme,
            let host = url.host(),
            scheme == BackgroundColor.widgetScheme,
            let backgroundColor = BackgroundColor.backgroundColor(for: host)
        else { return }
        widgetBackgroundColor = backgroundColor
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
