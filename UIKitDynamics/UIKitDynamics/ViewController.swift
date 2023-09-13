//
//  ViewController.swift
//  UIKitDynamics
//
//  Created by Artur Remizov on 12.09.23.
//

import UIKit

class ViewController: UIViewController {

    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
//    var firstContact: Bool = false
    var square: UIView!
    var snap: UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        square.backgroundColor = .gray
        view.addSubview(square)
        
        let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
        barrier.backgroundColor = .red
        view.addSubview(barrier)
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [square])
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior(items: [square])
        collision.collisionDelegate = self
        collision.addBoundary(withIdentifier: NSString("barrier"), for: UIBezierPath(rect: barrier.frame))
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
//        collision.action = {
//            print("\(NSCoder.string(for: square.transform)) \(NSCoder.string(for: square.center))")
//        }
        
        let itemBehavior = UIDynamicItemBehavior(items: [square])
        itemBehavior.elasticity = 0.6
        animator.addBehavior(itemBehavior)
        
//        var updateCount: Int = 0
//        collision.action = {
//            if updateCount % 3 == 0 {
//                let trailView = UIView(frame: square.frame)
//                trailView.transform = square.transform
//                trailView.backgroundColor = .clear
//                trailView.alpha = 0.5
//                trailView.layer.borderColor = square.layer.presentation()?.backgroundColor
//                trailView.layer.borderWidth = 1
//                self.view.addSubview(trailView)
//            }
//            updateCount += 1
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if snap != nil {
            animator.removeBehavior(snap)
        }
        
        guard let touch = touches.first else { return }
        let point = touch.location(in: view)
        snap = UISnapBehavior(item: square, snapTo: point)
        animator.addBehavior(snap)
    }
}

extension ViewController: UICollisionBehaviorDelegate {
    
    public func collisionBehavior(_ behavior: UICollisionBehavior,
                                  beganContactFor item: UIDynamicItem,
                                  withBoundaryIdentifier identifier: NSCopying?,
                                  at p: CGPoint) {
        let identifier: String = String(describing: identifier != nil ? identifier as! NSString : "nil")
        print("Boundary contact occurred - \(identifier)")
        
        guard let collidingView = item as? UIView else { return }
        collidingView.backgroundColor = .yellow
        UIView.animate(withDuration: 0.3) {
            collidingView.backgroundColor = .gray
        }
        
//        if !firstContact {
//            firstContact = true
//
//            let square = UIView(frame: CGRect(x: 30, y: 0, width: 100, height: 100))
//            square.backgroundColor = .gray
//            view.addSubview(square)
//
//            collision.addItem(square)
//            gravity.addItem(square)
//
//            let attach = UIAttachmentBehavior(item: collidingView, attachedTo: square)
//            animator.addBehavior(attach)
//        }
    }
}
