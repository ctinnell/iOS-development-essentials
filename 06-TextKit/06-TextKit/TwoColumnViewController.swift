//
//  TwoColumnViewController.swift
//  06-TextKit
//
//  Created by Clay Tinnell on 1/6/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class TwoColumnViewController: UIViewController {

    var text: String?
    var leftTextView: UITextView?
    var rightTextView: UITextView?
    
    var imageView = UIImageView(image: UIImage(named: "butterfly"))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextViews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "presentActionSheet:")
        imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "imageViewMoved:"))
        imageView.userInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initializeTextViews() {
        initializeLeftTextView()
        initializeRightTextView()
    }

    private func initializeLeftTextView() {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width/2.0, height: view.frame.height)
        leftTextView = UITextView(frame: frame)
        leftTextView!.text = text
        leftTextView!.scrollEnabled = false
        leftTextView?.font = UIFont.systemFontOfSize(15)
        view.addSubview(leftTextView!)
    }
    
    private func initializeRightTextView() {
        let textContainer = NSTextContainer()
        leftTextView?.layoutManager.addTextContainer(textContainer)
        let frame = CGRect(x: view.frame.width/2.0, y: 0, width: view.frame.width/2.0, height: view.frame.height)
        rightTextView = UITextView(frame: frame, textContainer: textContainer)
        rightTextView?.font = UIFont.systemFontOfSize(15)
        rightTextView?.scrollEnabled = false
        view.addSubview(rightTextView!)
    }
    
    private func addImageToView(action: UIAlertAction) {
        imageView.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2)
        view.addSubview(imageView)
        setExclusionPaths()
    }
    
    private func setExclusionPaths() {
        setExclusionPath(leftTextView!)
        setExclusionPath(rightTextView!)
    }
    
    private func setExclusionPath(textView: UITextView) {
        var imageFrame = textView.convertRect(imageView.bounds, fromCoordinateSpace: self.imageView)
        imageFrame.origin.x -= textView.textContainerInset.left
        imageFrame.origin.y -= textView.textContainerInset.top
        let path = UIBezierPath(ovalInRect: imageFrame)
        textView.textContainer.exclusionPaths = [path]
    }
    
    private func removeImageFromView(action: UIAlertAction?) {
        imageView.removeFromSuperview()
        clearExclusionPaths()
    }
    
    private func clearExclusionPaths() {
        leftTextView?.textContainer.exclusionPaths = []
        rightTextView?.textContainer.exclusionPaths = []
    }
    
    private func viewContainsImage() -> Bool {
        return view.subviews.filter({$0 == imageView}).count > 0
    }
    
    func presentActionSheet(sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Select Action", message: nil, preferredStyle: .ActionSheet)
        if viewContainsImage() {
            actionSheet.addAction(UIAlertAction(title: "Remove Image", style: .Default, handler: removeImageFromView))
        }
        else {
            actionSheet.addAction(UIAlertAction(title: "Add Image", style: .Default, handler: addImageToView))
        }
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func imageViewMoved(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(self.view)
        gesture.view!.center = CGPointMake(gesture.view!.center.x + translation.x, gesture.view!.center.y + translation.y)
        gesture.setTranslation(CGPointZero, inView: self.view)
        setExclusionPaths()
    }
}
