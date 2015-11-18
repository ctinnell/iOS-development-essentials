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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func queryCompleted(result: TestCallResult) {
        print("Result: \(result.url)")
    }

    func activityIndicator(tag: Int) -> UIActivityIndicatorView? {
        return self.view.viewWithTag(tag) as? UIActivityIndicatorView
    }
    
    func startAnimateActivityIndicator(tag: Int) {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator(tag)?.startAnimating()
        }
    }

    func stopAnimatingActivityIndicator(tag: Int) {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator(tag)?.stopAnimating()
        }
    }

    @IBAction func processRequests(sender: AnyObject) {
        for var x=1; x<=10; x++ {
            startAnimateActivityIndicator(tagStart + x)
            let testURL = TestCall.Endpoint.Delay(2).url()
            TestCall.execute(testURL, index:x) {(result, index) in
                print("Result: \(result.url)")
                self.stopAnimatingActivityIndicator(self.tagStart + index)
                print ("Stop Animating: \(index)")
            }
        }
    }
}

