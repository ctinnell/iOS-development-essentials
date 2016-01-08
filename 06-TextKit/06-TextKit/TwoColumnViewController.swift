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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeTextViews() {
        initializeLeftTextView()
        initializeRightTextView()
    }

    func initializeLeftTextView() {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width/2.0, height: view.frame.height)
        leftTextView = UITextView(frame: frame)
        leftTextView!.text = text
        leftTextView!.scrollEnabled = false
        leftTextView?.font = UIFont.systemFontOfSize(15)
        view.addSubview(leftTextView!)
    }
    
    func initializeRightTextView() {
        let textContainer = NSTextContainer()
        leftTextView?.layoutManager.addTextContainer(textContainer)

        let frame = CGRect(x: view.frame.width/2.0, y: 0, width: view.frame.width/2.0, height: view.frame.height)
        rightTextView = UITextView(frame: frame, textContainer: textContainer)
        rightTextView?.font = UIFont.systemFontOfSize(15)
        rightTextView?.scrollEnabled = false
        view.addSubview(rightTextView!)
    }
    
    func addImageToView(action: UIAlertAction) {
        removeImageFromView(nil)
        imageView.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2)
        view.addSubview(imageView)
    }
    
    func removeImageFromView(action: UIAlertAction?) {
        imageView.removeFromSuperview()
    }
    
    func presentActionSheet(sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Select Action", message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Add Image", style: .Default, handler: addImageToView))
        actionSheet.addAction(UIAlertAction(title: "Remove Image", style: .Default, handler: removeImageFromView))
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
}
