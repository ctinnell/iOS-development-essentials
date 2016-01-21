//
//  ViewController.swift
//  07-Value Observation
//
//  Created by Clay Tinnell on 1/16/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Stop/Start Activity Indicator
    private func tagFromIndex(index: Int) -> Int {
        return index + 1000
    }
    
    private func activityIndicator(tag: Int) -> UIActivityIndicatorView? {
        return self.view.viewWithTag(tag) as? UIActivityIndicatorView
    }
    
    private func startAnimateActivityIndicator(index: Int) {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator(self.tagFromIndex(index))?.startAnimating()
        }
    }
    
    private func stopAnimatingActivityIndicator(index: Int) {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator(self.tagFromIndex(index))?.stopAnimating()
        }
    }

    // MARK: - IBAction
    @IBAction func processRequests(sender: AnyObject) {
        for var x=1; x<=10; x++ {
            startAnimateActivityIndicator(x)
            TestCall().execute(TestCall.Endpoint.randomURL(), index: x, completion: stopAnimatingActivityIndicator)
        }
    }
}

