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
        
        func baseURL() -> NSURL {
            return NSURL(string: "https://www.flickr.com")!
        }
        
        func serviceURL() -> NSURL {
            return baseURL().URLByAppendingPathComponent("/services/rest?")
        }
        
        func apiKey() -> String {
            return "147953d5e702d2f304704bb4d44a4377"
        }
        
        func resultsPerPage() -> Int {
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
    
    func fetchPhotos(completion:([Photo]?, Error?) -> Void) {
        
    }
    
}