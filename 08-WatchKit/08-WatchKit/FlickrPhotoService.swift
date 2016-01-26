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
            return 25
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
    
    private func parsePhotos(photoData: NSData) {
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(photoData.correctedFlickrJSON()!, options: [.AllowFragments])
            if let photosDict = jsonData["photos"] as? [String:AnyObject],
                   photos = photosDict["photo"] as? [[String:AnyObject]] {
                print(photos)
            }
        }
        catch let jsonError as NSError {
            print("Error serializing response. Error: \(jsonError)")
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
                    self.parsePhotos(data)
                }
            } else {
                print("Error: url:\(url) error\(error)")
            }
        }
        task.resume()
    }
}

extension NSData {
    func correctedFlickrJSON() -> NSData? {
        var correctedJSON: NSData?
        if let invalidJSONString = String(data: self, encoding: NSUTF8StringEncoding) {
            let startIndex = invalidJSONString.startIndex.advancedBy("jsonFlickrApi(".lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            let endIndex = invalidJSONString.endIndex.advancedBy(-1)
            let invalidRange = Range(start: startIndex, end: endIndex)
            let correctedJSONString = invalidJSONString.substringWithRange(invalidRange).stringByReplacingOccurrencesOfString("\\'", withString: "'")
             correctedJSON = correctedJSONString.dataUsingEncoding(NSUTF8StringEncoding)
        }
        return correctedJSON
    }
}