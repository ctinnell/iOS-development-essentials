//
//  ViewController.swift
//  01-Swift-Asynchronous Network Access
//
//  Created by Clay Tinnell on 11/12/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // http://httpbin.org/delay/5
        let testURL = TestCall.Endpoint.Delay(2).url()
        TestCall.execute(testURL, completion: queryCompleted)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func queryCompleted(result: TestCallResult) {
        print("Result: \(result.url)")
    }

}

