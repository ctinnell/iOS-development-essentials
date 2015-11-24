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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        towerImageView.hidden = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        addPespective()
        splitImagesAcrossHorizontalAxis()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addPespective() {
        var perspective = CATransform3DIdentity
//        perspective.m34 = -1.0 / 500.0
        perspective.m34 = -1.0 / 800.0
        containerView.layer.sublayerTransform = perspective
    }
    
    func foldTopView(degrees: Double) {
        let radians = CGFloat(degrees * M_PI/180)
        if let view = topView {
            if degrees >= 90 && view.layer.contents != nil {
                topImage = view.layer.contents
                view.layer.contents = nil
                view.layer.backgroundColor = UIColor.grayColor().CGColor
            }
            else if degrees < 90 && view.layer.contents == nil {
                view.layer.contents = topImage
            }

            let transform = CATransform3DMakeTranslation(0, 0, 0)
            view.layer.transform = CATransform3DRotate(transform, radians, -1, 0, 0)
        }

    }
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    func splitImagesAcrossHorizontalAxis() {
        if let image = towerImageView.image {
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
            setAnchorPoint(CGPoint(x: 1.0, y: 1.0), forView: topView!)
            
        }
    }
    
    func viewFromImage(image: UIImage, frame: CGRect, coordinates: CGRect) -> UIView {
        let view = UIView(frame: frame)
        
        view.layer.contents = image.CGImage
        view.layer.contentsScale = image.scale
        view.layer.contentsGravity = kCAGravityResizeAspect
        view.layer.contentsRect = coordinates
        view.layer.masksToBounds = false
    
        return view
    }
    
    func topFrameFromImage(imageView: UIImageView) -> CGRect {
        return CGRectMake(0.0, 0.0, imageView.frame.size.width, imageView.frame.size.height/2)
    }

    func bottomFrameFromImage(imageView: UIImageView) -> CGRect {
        return CGRectMake(0.0, imageView.frame.size.height/2, imageView.frame.size.width, imageView.frame.size.height/2)
    }


    @IBAction func foldSliderValueChanged(sender: UISlider) {
        let sliderValue = Double(sender.value)
        foldTopView(sliderValue)
    }

}
