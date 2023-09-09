//
//  ViewController.swift
//  AdvancedUIViewShadowEffects
//
//  Created by Artur Remizov on 8.09.23.
//

import UIKit

class ViewController: UIViewController {

    let shadowType: ShadowType
    
    init(shadowType: ShadowType) {
        self.shadowType = shadowType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = shadowType.rawValue
        
        let width: CGFloat = 200
        let height: CGFloat = 200
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.image = UIImage(systemName: "cloud.sun")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .cyan
        imageView.center = view.center
        view.addSubview(imageView)
        
        switch shadowType {
        case .contact:
            let shadowSize: CGFloat = 20
            let shadowDistance: CGFloat = 20
            let contactRect = CGRect(x: -shadowSize, y: height - (shadowSize * 0.4) + shadowDistance, width: width + shadowSize * 2, height: shadowSize)
            imageView.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
            imageView.layer.shadowRadius = 5
            imageView.layer.shadowOffset = .zero
            imageView.layer.shadowOpacity = 0.4
        case .depth:
            let shadowRadius: CGFloat = 5
            let shadowWidth: CGFloat = 1.25
            let shadowHeight: CGFloat = 0.5
            let shadowOffsetX: CGFloat = 0 // -50
            
            let shadowPath = UIBezierPath()
            shadowPath.move(to: CGPoint(x: shadowRadius / 2, y:  height - shadowRadius / 2))
            shadowPath.addLine(to: CGPoint(x: width - shadowRadius / 2, y: height - shadowRadius / 2))
            shadowPath.addLine(to: CGPoint(x: width * shadowWidth + shadowOffsetX, y: height + (height * shadowHeight)))
            shadowPath.addLine(to: CGPoint(x: width * -(shadowWidth - 1) + shadowOffsetX, y: height + (height * shadowHeight)))
            
            imageView.layer.shadowPath = shadowPath.cgPath
            imageView.layer.shadowRadius = shadowRadius
            imageView.layer.shadowOffset = .zero
            imageView.layer.shadowOpacity = 0.2
        case .flat:
            let shadowOffsetX: CGFloat = 2000
            let shadowPath = UIBezierPath()
            shadowPath.move(to: CGPoint(x: 0, y: height))
            shadowPath.addLine(to: CGPoint(x: width, y: 0))
            shadowPath.addLine(to: CGPoint(x: width + shadowOffsetX, y: 2000))
            shadowPath.addLine(to: CGPoint(x: shadowOffsetX, y: 2000))

            imageView.layer.shadowPath = shadowPath.cgPath
            imageView.layer.shadowRadius = 1
            imageView.layer.shadowOffset = .zero
            imageView.layer.shadowOpacity = 0.2
            
            view.backgroundColor = .orange
        case .curved:
            let shadowRadius: CGFloat = 5
            let curveAmount: CGFloat = 40
            let shadowPath = UIBezierPath()
            
            shadowPath.move(to: CGPoint(x: shadowRadius, y: 0))
            shadowPath.addLine(to: CGPoint(x: width - shadowRadius * 2, y: 0))
            shadowPath.addLine(to: CGPoint(x: width - shadowRadius, y: height + curveAmount))
            shadowPath.addCurve(
                to: CGPoint(x: shadowRadius, y: height + curveAmount),
                controlPoint1: CGPoint(x: width, y: height - shadowRadius),
                controlPoint2: CGPoint(x: 0, y: height - shadowRadius)
            )
            imageView.layer.shadowPath = shadowPath.cgPath
            
            imageView.layer.shadowRadius = shadowRadius
            imageView.layer.shadowOffset = CGSize(width: 0, height: 10)
            imageView.layer.shadowOpacity = 0.5
        case .doubleStrokes:
            imageView.image = UIImage(systemName: "tornado")
            
            let shadowSize: CGFloat = 20
            let shadowPadding: CGFloat = 2
            let shadowRect = CGRect(x: -shadowPadding, y: -shadowPadding, width: width + shadowPadding * 2, height: height + shadowPadding * 2)
            let shadowPath = UIBezierPath(rect: shadowRect)
            imageView.layer.shadowPath = shadowPath.cgPath

            imageView.layer.shadowRadius = 0
            imageView.layer.shadowOffset = .zero
            imageView.layer.shadowOpacity = 1
            
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = shadowSize
        }
    }
}

