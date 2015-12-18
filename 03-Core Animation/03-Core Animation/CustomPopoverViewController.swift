//
//  CustomPopoverViewController.swift
//  03-Core Animation
//
//  Created by Clay Tinnell on 12/13/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

protocol CustomPopoverViewControllerDelegate {
    func okButtonPressed()
    func cancelButtonPressed()
}

class CustomPopoverViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var delegate: CustomPopoverViewControllerDelegate?
    private let presentationAnimationController = CustomPopoverAnimationTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let toViewController = segue.destinationViewController as UIViewController
            toViewController.transitioningDelegate = self
    }
    
    @IBAction func okButtonPressed(sender: AnyObject) {
        delegate?.okButtonPressed()
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        delegate?.cancelButtonPressed()
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentationAnimationController
    }

    private class CustomPopoverAnimationTransition: NSObject, UIViewControllerAnimatedTransitioning {
        @objc private func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
            return 2.0
        }
        
        @objc private func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
            let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
            let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
            let containerView = transitionContext.containerView()!
            let bounds = UIScreen.mainScreen().bounds
            toViewController.view.frame = CGRectOffset(finalFrameForVC, 0, bounds.size.height)
            containerView.addSubview(toViewController.view)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .CurveLinear, animations: {
                fromViewController.view.alpha = 0.5
                toViewController.view.frame = finalFrameForVC
                }, completion: {
                    finished in
                    transitionContext.completeTransition(true)
                    fromViewController.view.alpha = 1.0
            })
        }

    }
}
