//
//  ViewController.swift
//  01-Swift-Asynchronous Network Access
//
//  Created by Clay Tinnell on 11/12/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let tagStart = 1000
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Activity Indicator
    private func activityIndicator(tag: Int) -> UIActivityIndicatorView? {
        return self.view.viewWithTag(tag) as? UIActivityIndicatorView
    }
    
    private func startAnimateActivityIndicator(tag: Int) {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator(tag)?.startAnimating()
        }
    }

    private func stopAnimatingActivityIndicator(tag: Int) {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator(tag)?.stopAnimating()
        }
    }
    
    // MARK: - IBActions
    @IBAction func processRequests(sender: AnyObject) {
        for var x=1; x<=10; x++ {
            startAnimateActivityIndicator(tagStart + x)
            let randomUnit: UInt32 = 11 
            let testURL = TestCall.Endpoint.Delay(Int(arc4random_uniform(randomUnit))).url()
            TestCall.execute(testURL, index:x) {(result, index) in
                print("Result: \(result.url)")
                self.stopAnimatingActivityIndicator(self.tagStart + index)
            }
        }
    }
}

