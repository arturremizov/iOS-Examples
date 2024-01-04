//
//  ViewController.swift
//  UIContentUnavailableConfiguration
//
//  Created by Artur Remizov on 4.01.24.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createContentUnavailableConfigurationFromScratch()
//        usePredefinedLoadingConfiguration()
//        usePredefinedSearchConfiguration()
        useUIHostingConfiguration()
    }
    
    private func createContentUnavailableConfigurationFromScratch() {
        var config = UIContentUnavailableConfiguration.empty()
        config.image = UIImage(systemName: "applelogo")
        config.text = "WWDC23 Demo"
        config.secondaryText = "Code new worlds."
        self.contentUnavailableConfiguration = config
    }
    
    private func usePredefinedLoadingConfiguration() {
        var config = UIContentUnavailableConfiguration.loading()
        config.text = "Fetching content. Please wait..."
        config.textProperties.font = .boldSystemFont(ofSize: 18)
        self.contentUnavailableConfiguration = config
    }
    
    private func usePredefinedSearchConfiguration() {
        var config = UIContentUnavailableConfiguration.search()
        self.contentUnavailableConfiguration = config
    }
    
    private func useUIHostingConfiguration() {
        var config = UIHostingConfiguration {
            Text("Unknown error occurred, please [contact support](https://swiftsenpai.com).")
                .multilineTextAlignment(.center)
        }
        self.contentUnavailableConfiguration = config
    }
}

