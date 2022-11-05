//
//  ViewController.swift
//  NavigationBarLargeTitleGradient
//
//  Created by Artur Remizov on 3.11.22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleText = "Navigation Large Title"
        navigationItem.title = titleText
        
        // force to show Navigation Bar Large Title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        
        // setup Gradient Layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        // get large title text size to set accurate gradient width
        let largeTitleTextAttributes = navigationController?.navigationBar.standardAppearance.largeTitleTextAttributes
        let boundingRect = titleText.boundingRect(with: CGSize(width: Double.infinity, height: 0),
                                                  attributes:largeTitleTextAttributes,
                                                  context: nil)
        gradientLayer.frame = boundingRect
        
        // convert layer to image
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.scale = 1
        
        let imageRenderer = UIGraphicsImageRenderer(size: gradientLayer.bounds.size, format: rendererFormat)
        let pngData = imageRenderer.pngData { context in
            gradientLayer.render(in: context.cgContext)
        }
        let image = UIImage(data: pngData)!
        
        // create Color from image
        let gradientColor = UIColor(patternImage: image)
                
        // set foregroundColor for largeTitleTextAttributes
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: gradientColor]
        navigationController?.navigationBar.standardAppearance = navBarAppearance
    }
}

