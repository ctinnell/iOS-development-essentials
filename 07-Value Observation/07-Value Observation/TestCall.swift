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
        
        
    }
    
    func execute(url: NSURL, index: Int, completion: (Int) -> ()) {
        self.testCallResult = TestCallResult(url: url, index: index)
        self.testCallResult?.index.observe(completion)
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if(error == nil) {
                if let data = data {
                    do {
                        let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        print("************************************************")
                        print("\(jsonData)")
                        print("************************************************")
                    }
                    catch let jsonError as NSError {
                        print("Error serializing response. Error: \(jsonError)")
                    }
                    self.testCallResult?.index.value = index
                }
            } else {
                print("Error: url:\(url) error\(error)")
            }
        }
        task.resume()
    }
}
