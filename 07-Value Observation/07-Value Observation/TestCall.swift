//
//  TestCall.swift
//  01-Swift-Asynchronous Network Access
//
//  Created by Clay Tinnell on 11/16/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class TestCall {
    var testCallResult: TestCallResult?
    
    enum Endpoint {
        case Delay(Int)
        case ImagePNG
        case Get
        
        func baseURL() -> NSURL {
            return NSURL(string: "https://httpbin.org")!
        }
        
        func url() -> NSURL {
            switch self {
            case .Delay(let seconds):
                return baseURL().URLByAppendingPathComponent("/delay/\(seconds)")
            case .ImagePNG:
                return baseURL().URLByAppendingPathComponent("/get/image/png")
            case .Get:
                return baseURL().URLByAppendingPathComponent("/get")
            }
        }
        
        static func randomURL() -> NSURL {
            let randomUnit: UInt32 = 11
            return Delay(Int(arc4random_uniform(randomUnit))).url()
        }
    }
    
    func execute(url: NSURL, index: Int, completion: (Int) -> ()) {
        //set up result... add an observer for the completion closure
        self.testCallResult = TestCallResult(url: url, index: index)
        self.testCallResult?.index.observe(completion)
        
        //just a dummy asynchronous call to simulate varying response times
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if(error == nil) {
                if let data = data {
                    do {
                        // parse the resonse and review just for fun...
                        let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        print("************************************************")
                        print("\(jsonData)")
                        print("************************************************")
                    }
                    catch let jsonError as NSError {
                        print("Error serializing response. Error: \(jsonError)")
                    }
                    
                    // This just forces the observer to be notified, triggering the completion closure to be called.
                    self.testCallResult?.index.value = index
                }
            } else {
                print("Error: url:\(url) error\(error)")
            }
        }
        task.resume()
    }
}
