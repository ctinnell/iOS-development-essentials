//
//  FoldingViewController.swift
//  03-Core Animation
//
//  Created by Clay Tinnell on 11/22/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class FoldingViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var towerImageView: UIImageView!
    
    var topImage: AnyObject?
    var topView: UIView?
    var bottomView: UIView?
    var viewHasCoverImage = false
    
    var coverImageView = UIImageView(image: UIImage(named: "parisPeace"))
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        towerImageView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initialize()
    }


    // MARK: - Initialization
    private func initialize() {
        addPespective()
        splitImagesAcrossHorizontalAxis()
    }
    
    // MARK: - Core Graphics
    private func addPespective() {
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 800.0
        containerView.layer.sublayerTransform = perspective
    }
    
    private func addCoverImage() {
        if let view = topView {
            viewHasCoverImage = true
            topImage = view.layer.contents
            view.addSubview(coverImageView)
            view.layer.backgroundColor = UIColor.whiteColor().CGColor
            view.clipsToBounds = true
            coverImageView.contentMode = .ScaleAspectFit
            coverImageView.frame = CGRectMake(0, 0, containerView.bounds.size.width, containerView.bounds.size.height/2)
            coverImageView.center = CGPoint(x: view.frame.size.width / 2, y: coverImageView.center.y)
            let transform = CATransform3DMakeTranslation(0, 0, 0)
            coverImageView.layer.transform = CATransform3DRotate(transform, CGFloat(180 * M_PI/180), 1, 0, 0)
            view.layer.contents = nil
        }
    }
    
    private func removeCoverImage() {
        if let view = topView {
            view.layer.contents = topImage
            coverImageView.removeFromSuperview()
            viewHasCoverImage = false
        }
    }
    
    private func foldTopView(degrees: Double) {
        if let view = topView {
            //only add the cover image when it becomes visible
            if degrees >= 90 && !viewHasCoverImage {
                addCoverImage()
            }
            //remove the cover image when it passes the visibility point
            else if degrees < 90 && viewHasCoverImage  {
                removeCoverImage()
            }
            
            //Convert degrees to radians and incrementally fold the view.
            let radians = CGFloat(degrees * M_PI/180)
            let transform = CATransform3DMakeTranslation(0, 0, 0)
            view.layer.transform = CATransform3DRotate(transform, radians, -1, 0, 0)
        }
    }
    
    private func setHorizontalAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var viewPosition = view.layer.position
        viewPosition.x -= oldPoint.x
        viewPosition.x += newPoint.x
        
        viewPosition.y -= oldPoint.y
        viewPosition.y += newPoint.y
        view.layer.position = viewPosition
        view.layer.anchorPoint = anchorPoint
    }
    
    private func removeSplitImages() {
        if let topView = topView, bottomView = bottomView {
            topView.removeFromSuperview()
            bottomView.removeFromSuperview()
        }
    }
    
    private func splitImagesAcrossHorizontalAxis() {
        if let image = towerImageView.image {
            removeSplitImages()
            let frame = topFrameFromImage(towerImageView)
            let bottomFrame = bottomFrameFromImage(towerImageView)
            
            topView = viewFromImage(image, frame: frame, coordinates: CGRectMake(0.0, 0.0, 1.0, 0.5))

            bottomView = viewFromImage(image, frame: bottomFrame, coordinates: CGRectMake(0.0, 0.5, 1.0, 0.5))
            containerView.addSubview(bottomView!)
            containerView.addSubview(topView!)
            
            topView?.layer.borderColor = UIColor.blackColor().CGColor
            bottomView?.layer.borderColor = UIColor.blackColor().CGColor
            topView?.layer.borderWidth = 1.0
            bottomView?.layer.borderWidth = 1.0
            setHorizontalAnchorPoint(CGPoint(x: 1.0, y: 1.0), forView: topView!)
            
        }
    }
    
    private func viewFromImage(image: UIImage, frame: CGRect, coordinates: CGRect) -> UIView {
        let view = UIView(frame: frame)
        
        view.layer.contents = image.CGImage
        view.layer.contentsScale = image.scale
        view.layer.contentsGravity = kCAGravityResizeAspect
        view.layer.contentsRect = coordinates
        view.layer.masksToBounds = false
    
        return view
    }
    
    private func topFrameFromImage(imageView: UIImageView) -> CGRect {
        return CGRectMake(0.0, 0.0, imageView.frame.size.width, imageView.frame.size.height/2)
    }

    private func bottomFrameFromImage(imageView: UIImageView) -> CGRect {
        return CGRectMake(0.0, imageView.frame.size.height/2, imageView.frame.size.width, imageView.frame.size.height/2)
    }

    // MARK: - IBActions
    @IBAction func foldSliderValueChanged(sender: UISlider) {
        let sliderValue = Double(sender.value)
        foldTopView(sliderValue)
    }

}
