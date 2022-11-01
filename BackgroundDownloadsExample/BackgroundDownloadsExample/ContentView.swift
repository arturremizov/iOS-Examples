//
//  ContentView.swift
//  BackgroundDownloadsExample
//
//  Created by Artur Remizov on 31.10.22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var downloadManager = DownloadManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(downloadManager.tasks, id: \.self) { task in
                    if let urlString = task.currentRequest?.url?.absoluteString {
                        VStack(alignment: .leading, spacing: 10.0) {
                            Text(urlString)
                            ProgressView(task.progress)
                        }
                    }
                }
            }
            .navigationTitle("Downloads")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Download file") {
                        downloadFile()
                    }
                }
            }
        }
    }
    
    private func downloadFile() {
        guard let url = URL(string: "https://sabnzbd.org/tests/internetspeed/50MB.bin") else { return }
        downloadManager.startDownload(url: url)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
