//
//  View.swift
//

import Foundation
import UIKit

class DashedBorderView: UIView {
    
    let _border = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    func setup() {
        _border.strokeColor = #colorLiteral(red: 0.3529411765, green: 0, blue: 0.6196078431, alpha: 1)
        _border.fillColor = #colorLiteral(red: 0.9843137255, green: 0.9725490196, blue: 1, alpha: 1)
        _border.lineWidth = 2
        _border.lineDashPattern = [4, 4]
        self.layer.addSublayer(_border)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:6).cgPath
        _border.frame = self.bounds
    }
}

//class CustomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 2.5
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        
//        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
//        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
//        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
//        let containerView = transitionContext.containerView
//        let bounds = UIScreen.main.bounds
////        toViewController.view.frame = CGRectOffset(finalFrameForVC, 0, bounds.size.height)
//        toViewController.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: -bounds.size.height)
//        containerView.addSubview(toViewController.view)
//        
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
//            fromViewController.view.alpha = 0.5
//            toViewController.view.frame = finalFrameForVC
//            }, completion: {
//                finished in
//                transitionContext.completeTransition(true)
//                fromViewController.view.alpha = 1.0
//        })
//    }
//    
//}
