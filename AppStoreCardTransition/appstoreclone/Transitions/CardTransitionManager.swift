//
//  CardTransitionManager.swift
//  appstoreclone
//
//  Created by Andrei Blaj on 10/13/20.
//

import UIKit

enum CardTransitionType {
    case presentation
    case dismissal
    
    var isPresenting: Bool {  self == .presentation }
    
    var blurAlpha: CGFloat { isPresenting ? 1 : 0 }
    var dimAlpha: CGFloat { isPresenting ? 0.5 : 0 }
    var closeAlpha: CGFloat { isPresenting ? 1 : 0 }
    
    var cornerRadius: CGFloat { isPresenting ? 20 : 0 }
    
    var cardMode: CardViewMode { isPresenting ? .card : .full }
    var next: CardTransitionType { isPresenting ? .dismissal : .presentation }
}

class CardTransitionManager: NSObject {
    
    let transitionDuration: Double = 1.0
    var transition: CardTransitionType = .presentation
    let shrinkDuration: Double = 0.2
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        return visualEffectView
    }()
    
    lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Helper Methods
    private func addBackgroundViews(to containerView: UIView) {
        blurEffectView.frame = containerView.frame
        blurEffectView.alpha = transition.next.blurAlpha
        containerView.addSubview(blurEffectView)
        
        dimmingView.frame = containerView.frame
        dimmingView.alpha = transition.next.dimAlpha
        containerView.addSubview(dimmingView)
    }
    
    private func createCardViewCopy(cardView: CardView) -> CardView {
        let cardModel = cardView.cardModel
        cardModel.viewMode = transition.cardMode
        let appView = AppView(cardView.appView?.viewModel)
        let cardViewCopy = CardView(cardModel: cardModel, appView: appView)
        return cardViewCopy
    }
}

extension CardTransitionManager: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // remove all subviews from containerView
        let containerView = transitionContext.containerView
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        // add blurEffectView and dimmingView to containerView
        addBackgroundViews(to: containerView)
        
        // create a copy from tapped card
        let fromView = transitionContext.viewController(forKey: .from)
        let toView = transitionContext.viewController(forKey: .to)
        
        guard
            let cardView = (transition == .presentation) ? (fromView as? TodayView)?.selectedCellCardView() : (toView as? TodayView)?.selectedCellCardView()
        else { return }
        
        let cardViewCopy = createCardViewCopy(cardView: cardView)
        containerView.addSubview(cardViewCopy)
        cardView.isHidden = true
        
        let absoluteCardViewFrame = cardView.convert(cardView.frame, to: nil)
        cardViewCopy.frame = absoluteCardViewFrame
        cardViewCopy.layoutIfNeeded()
        
        // add white view
        whiteView.frame = transition.isPresenting ? cardViewCopy.containerView.frame : containerView.frame
        whiteView.layer.cornerRadius = transition.cornerRadius
        cardViewCopy.insertSubview(whiteView, aboveSubview: cardViewCopy.shadowView)
                
        // add close button
        if cardView.cardModel.backgroundType == .light {
            closeButton.setImage(UIImage(named: "darkOnLight"), for: .normal)
        } else {
            closeButton.setImage(UIImage(named: "lightOnDark"), for: .normal)
        }
        cardViewCopy.containerView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: cardViewCopy.topAnchor, constant: 20.0),
            closeButton.widthAnchor.constraint(equalToConstant: 30.0),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor, multiplier: 1.0),
            closeButton.rightAnchor.constraint(equalTo: cardViewCopy.rightAnchor, constant: -20.0)
        ])
        
        // start animation
        if transition == .presentation {
            let detailView = toView as! DetailView
            containerView.addSubview(detailView.view)
            detailView.viewsAreHidden = true
            closeButton.alpha = transition.next.closeAlpha
            
            moveAndConvertToCardView(cardView: cardViewCopy, containerView: containerView, yOriginToMoveTo: 0) {
                
                detailView.viewsAreHidden = false
                cardViewCopy.removeFromSuperview()
                cardView.isHidden = false
                
                detailView.createSnapshotOfView()
                
                transitionContext.completeTransition(true)
            }
        } else {
            // Dismissal
            let detailView = fromView as! DetailView
            detailView.viewsAreHidden = true
            
            cardViewCopy.frame = CGRect(x: 0,
                                        y: 0,
                                        width: detailView.cardView?.frame.size.width ?? 0,
                                        height: detailView.cardView?.frame.size.height ?? 0)
            
            cardViewCopy.transform = detailView.snapshotView.transform
            
            closeButton.alpha = transition.next.closeAlpha
            
            moveAndConvertToCardView(cardView: cardViewCopy, containerView: containerView, yOriginToMoveTo: absoluteCardViewFrame.origin.y) {
                
                cardView.isHidden = false
                transitionContext.completeTransition(true)
            }
        }
    }
    
    func makeShrinkAnimator(for cardView: CardView) -> UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: shrinkDuration, curve: .easeOut) {
            cardView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.dimmingView.alpha = 0.05
        }
    }
    
    func makeExpandContractAnimator(for cardView: CardView,
                                    in containerView: UIView,
                                    yOrigin: CGFloat) -> UIViewPropertyAnimator {
        
        let springTiming = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0, dy: 4))
        let animator = UIViewPropertyAnimator(duration: transitionDuration - shrinkDuration, timingParameters: springTiming)
        
        animator.addAnimations {
            cardView.transform = .identity
            cardView.containerView.layer.cornerRadius = self.transition.next.cornerRadius
            cardView.frame.origin.y = yOrigin
            
            self.blurEffectView.alpha = self.transition.blurAlpha
            self.dimmingView.alpha = self.transition.dimAlpha
            self.closeButton.alpha = self.transition.closeAlpha
            
            self.whiteView.layer.cornerRadius = self.transition.next.cornerRadius
            
            containerView.layoutIfNeeded()
            
            self.whiteView.frame = self.transition.isPresenting ? containerView.frame : cardView.containerView.frame
        }
        
        return animator
    }
    
    func moveAndConvertToCardView(cardView: CardView,
                                  containerView: UIView,
                                  yOriginToMoveTo: CGFloat,
                                  completion: @escaping () -> ()) {
        
        let expandContractAnimator = makeExpandContractAnimator(for: cardView, in: containerView, yOrigin: yOriginToMoveTo)
        
        expandContractAnimator.addCompletion { _ in
            completion()
        }
        
        if transition.isPresenting {
            
            let shrinkAnimator = makeShrinkAnimator(for: cardView)
            
            shrinkAnimator.addCompletion { _ in
                cardView.layoutIfNeeded()
                cardView.updateLayout(for: self.transition.next.cardMode)
                
                expandContractAnimator.startAnimation()
            }
            
            shrinkAnimator.startAnimation()
        } else {
            cardView.layoutIfNeeded()
            cardView.updateLayout(for: self.transition.next.cardMode)
            expandContractAnimator.startAnimation()
        }
    }
}

extension CardTransitionManager: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .presentation
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .dismissal
        return self
    }
}
