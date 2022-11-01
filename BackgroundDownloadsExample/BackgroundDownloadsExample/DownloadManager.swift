//
//  DownloadManager.swift
//  BackgroundDownloadsExample
//
//  Created by Artur Remizov on 31.10.22.
//

import Foundation
import os

class DownloadManager: NSObject, ObservableObject {
    
    static var shared = DownloadManager()
    
    @Published var tasks: [URLSessionTask] = []
    
    private var urlSession: URLSession!
    
    private override init() {
        super.init()
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.arturremizov.BackgroundDownloadsExample.background")
        urlSession = URLSession(configuration: configuration,
                                delegate: self,
                                delegateQueue: OperationQueue())
        updateTasks()
    }
    
    private func updateTasks() {
        urlSession.getAllTasks { tasks in
            DispatchQueue.main.async {
                self.tasks = tasks
            }
        }
    }
    
    func startDownload(url: URL) {
        let task = urlSession.downloadTask(with: url)
        task.resume()
        tasks.append(task)
    }
}

extension DownloadManager: URLSessionDelegate, URLSessionDownloadDelegate {
  
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        os_log("Progress %f for %@", type: .debug, downloadTask.progress.fractionCompleted, downloadTask)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        os_log("Download finished: %@", type: .info, location.absoluteString)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error {
            os_log("Download error: %@", type: .error, String(describing: error))
        } else {
            os_log("Task finished: %@", type: .info, task)
        }
    }
}
