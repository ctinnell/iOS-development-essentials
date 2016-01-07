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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextViews()
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
}
