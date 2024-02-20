//
//  ColorRepository.swift
//  UICollectionViewCompositionalLayout
//
//  Created by Artur Remizov on 15.02.24.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

final class ColorRepository {
    lazy var letters: [Character] = {
        let aScalars = "a".unicodeScalars
        let aCode = aScalars[aScalars.startIndex].value
        return (0..<26).map {
            Character(Unicode.Scalar(aCode + $0) ?? aScalars[aScalars.startIndex])
        }
    }()
    
    lazy var colors: [UIColor] = {
        (0...100).map { _ in UIColor.random }
    }()
}
