//
//  ViewController.swift
//  CoreTextExample
//
//  Created by Artur Remizov on 18.09.23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = Label(text: "Hello World is very big and the ocean is very large so maybe we wrap this text")
        label.backgroundColor = .secondarySystemBackground
        view.addSubview(label)
        
        label.frame = CGRect(x: 0, y: 0, width: 220, height: 160)
        label.center = view.center
        
        print("getSizeThatFits: \(label.getSizeThatFits(maxSize: CGSize(width: 100, height: 50)))")
    }
}

