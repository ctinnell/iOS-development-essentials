//
//  FlickrPhotoService.swift
//  08-WatchKit
//
//  Created by Clay Tinnell on 1/24/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import Foundation

class FlickrPhotoService: PhotoServiceProtocol {
   
    enum Endpoint {
        case InterestingPhotos
        case Photo(String,String)
        
        private func baseURL() -> NSURL {
            return NSURL(string: "https://www.flickr.com")!
        }
        
        private func serviceURL() -> NSURL {
            return baseURL().URLByAppendingPathComponent("/services/rest?")
        }
        
        private func apiKey() -> String {
            return "147953d5e702d2f304704bb4d44a4377"
        }
        
        private func resultsPerPage() -> Int {
            return 50
        }
        
        func url() -> NSURL {
            switch self {
            case .InterestingPhotos:
                return serviceURL().URLByAppendingPathComponent("&method=flickr.interestingness.getList&api_key=\(apiKey())&format=json&per_page=\(resultsPerPage())")
            case .Photo(let owner, let id):
                return baseURL().URLByAppendingPathComponent("/photos/\(owner)/\(id)")
            }
        }
    }
    
    func fetchPhotos(completion:([Photo]?, Error?) -> ()) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        let url = Endpoint.InterestingPhotos.url()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if(error == nil) {
                if let data = data {
                    do {
                        // parse the resonse and review just for fun...
                        let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                        let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments])
                        print("************************************************")
                        print("\(jsonData)")
                        print("************************************************")
                    }
                    catch let jsonError as NSError {
                        print("Error serializing response. Error: \(jsonError)")
                    }
                    
                    // This just forces the observer to be notified, triggering the completion closure to be called.
                    //TODO: Init new photo object arrays and Call completion block.
                }
            } else {
                print("Error: url:\(url) error\(error)")
            }
        }
        task.resume()
    }
}