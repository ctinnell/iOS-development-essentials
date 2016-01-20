//
//  ViewController.swift
//  07-Value Observation
//
//  Created by Clay Tinnell on 1/16/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let tagStart = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Activity Indicator
    private func activityIndicator(tag: Int) -> UIActivityIndicatorView? {
        return self.view.viewWithTag(tag) as? UIActivityIndicatorView
    }
    
    private func startAnimateActivityIndicator(tag: Int) {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator(self.tagStart + tag)?.startAnimating()
        }
    }
    
    private func stopAnimatingActivityIndicator(tag: Int) {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator(self.tagStart + tag)?.stopAnimating()
        }
    }

    // MARK: - IBActions
    @IBAction func processRequests(sender: AnyObject) {
        for var x=1; x<=10; x++ {
            startAnimateActivityIndicator(x)
            let randomUnit: UInt32 = 11
            let testURL = TestCall.Endpoint.Delay(Int(arc4random_uniform(randomUnit))).url()
            
            TestCall().execute(testURL, index: x, completion: stopAnimatingActivityIndicator)
        }
    }
}

