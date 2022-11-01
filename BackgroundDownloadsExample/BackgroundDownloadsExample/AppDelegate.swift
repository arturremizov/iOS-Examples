//
//  AppDelegate.swift
//  BackgroundDownloadsExample
//
//  Created by Artur Remizov on 31.10.22.
//

import Foundation
import UIKit
import os

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession identifier: String,
                     completionHandler: @escaping () -> Void) {
        
        os_log("handleEventsForBackgroundURLSession for %@", type: .info, identifier)
        completionHandler()
    }
}
