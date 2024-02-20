//
//  SpacerView.swift
//  UICollectionViewCompositionalLayout
//
//  Created by Artur Remizov on 15.02.24.
//

import UIKit

class SpacerView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
