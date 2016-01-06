//
//  MovableWordFlowViewController.swift
//  06-TextKit
//
//  Created by Clay Tinnell on 1/5/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class MovableWordFlowViewController: UIViewController {
 
    var text: String?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: "imageViewMoved:")
        imageView.addGestureRecognizer(panGesture)
        imageView.userInteractionEnabled = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureTextView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureTextView() {
        textView.text = text
        setExclusionPath()
    }
    
    private func setExclusionPath() {
        if let textView = textView, imageView = imageView {
            var imageFrame = textView.convertRect(imageView.bounds, fromCoordinateSpace: self.imageView)
            imageFrame.origin.x -= textView.textContainerInset.left
            imageFrame.origin.y -= textView.textContainerInset.top
            let path = UIBezierPath(rect: imageFrame)
            self.textView.textContainer.exclusionPaths = [path]
        }
    }
    
    func imageViewMoved(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(self.view)
        gesture.view!.center = CGPointMake(gesture.view!.center.x + translation.x, gesture.view!.center.y + translation.y)
        gesture.setTranslation(CGPointZero, inView: self.view)
        setExclusionPath()
    }

}
