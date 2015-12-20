//
//  CustomPopoverAnimationViewController.swift
//  03-Core Animation
//
//  Created by Clay Tinnell on 11/30/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class CustomPopoverAnimationViewController: UIViewController, CustomPopoverViewControllerDelegate, UIViewControllerTransitioningDelegate {

    private var popoverViewController: CustomPopoverViewController?
    private let presentationAnimationController = CustomPopoverPresentationAnimationTransition()
    private let dismissalAnimationController = CustomPopoverDismissalAnimationTransition()

    //MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions
    @IBAction func showPopover(sender: AnyObject) {
        popoverViewController = storyboard?.instantiateViewControllerWithIdentifier("customPopoverViewController") as?CustomPopoverViewController
        
        if let popoverViewController = popoverViewController {
            popoverViewController.delegate = self
            popoverViewController.modalPresentationStyle = .OverCurrentContext
            popoverViewController.transitioningDelegate = self
            presentViewController(popoverViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - CustomPopoverViewControllerDelegate
    func okButtonPressed() {
        dismissalAnimationController.animationMultiplier = -1.0
        self.popoverViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    func cancelButtonPressed() {
        dismissalAnimationController.animationMultiplier = 1.0
        self.popoverViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentationAnimationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissalAnimationController
    }
    
    // MARK: - CustomPopoverPresentationAnimationTransition
    
    private class CustomPopoverPresentationAnimationTransition: NSObject, UIViewControllerAnimatedTransitioning {
        @objc private func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
            return 2.0
        }
        
        @objc private func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
            
            let finalFrame = transitionContext.finalFrameForViewController(toViewController)
            let containerView = transitionContext.containerView()!
            let bounds = UIScreen.mainScreen().bounds
            toViewController.view.frame = CGRectOffset(finalFrame, 0, bounds.size.height)
            containerView.addSubview(toViewController.view)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .CurveLinear, animations: {
                    toViewController.view.frame = finalFrame
                }, completion: {
                    finished in
                    transitionContext.completeTransition(true)
            })
        }
    }
    
    // MARK: - CustomPopoverDismissalAnimationTransition
    private class CustomPopoverDismissalAnimationTransition: NSObject, UIViewControllerAnimatedTransitioning {
        var animationMultiplier = -1.0

        @objc private func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
            return 3.0
        }
        
        @objc private func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
            let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
            
            var finalFrame = transitionContext.finalFrameForViewController(fromViewController)
            let bounds = UIScreen.mainScreen().bounds
            finalFrame = CGRectMake(finalFrame.origin.x, bounds.size.height, finalFrame.size.width, finalFrame.size.height)
            let containerView = transitionContext.containerView()!
            containerView.addSubview(fromViewController.view)
            
            // The view will animate either left or right on dismissal depending on which button is pressed.
            let radians = CGFloat((90.0 * animationMultiplier) * M_PI/180)
            let transform = CGAffineTransformRotate(CGAffineTransformIdentity, radians)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .CurveLinear, animations: {
                    fromViewController.view.frame = finalFrame
                    fromViewController.view.transform = transform
                }, completion: {
                    finished in
                    transitionContext.completeTransition(true)
            })
        }
    }
}
