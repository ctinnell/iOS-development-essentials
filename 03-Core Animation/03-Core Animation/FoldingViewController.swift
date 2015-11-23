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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        towerImageView.hidden = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        splitImagesAcrossHorizontalAxis()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func splitImagesAcrossHorizontalAxis() {
        if let image = towerImageView.image {
            let frame = topFrameFromImage(towerImageView)
            let bottomFrame = bottomFrameFromImage(towerImageView)
            containerView.addSubview(viewFromImage(image, frame: frame, coordinates: CGRectMake(0.0, 0.0, 1.0, 0.5)))
            containerView.addSubview(viewFromImage(image, frame: bottomFrame, coordinates: CGRectMake(0.0, 0.5, 1.0, 0.5)))
        }
    }
    
    func viewFromImage(image: UIImage, frame: CGRect, coordinates: CGRect) -> UIView {
        let view = UIView(frame: frame)
        
        view.layer.contents = image.CGImage
        view.layer.contentsScale = image.scale
        view.layer.contentsGravity = kCAGravityResizeAspect
        view.layer.contentsRect = coordinates
        view.layer.masksToBounds = true
    
        return view
    }
    
    func topFrameFromImage(imageView: UIImageView) -> CGRect {
        return CGRectMake(0.0, 0.0, imageView.frame.size.width, imageView.frame.size.height/2)
    }

    func bottomFrameFromImage(imageView: UIImageView) -> CGRect {
        return CGRectMake(0.0, imageView.frame.size.height/2, imageView.frame.size.width, imageView.frame.size.height/2)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
