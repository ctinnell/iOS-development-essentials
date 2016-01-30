//
//  FlickrPhotoService.swift
//  08-WatchKit
//
//  Created by Clay Tinnell on 1/24/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import Foundation
import UIKit

class FlickrPhotoService: NSObject, PhotoServiceProtocol {
   
    var session: NSURLSession?
    
    var photos = [Photo]()
    
    var completionHandler: PhotoServiceCompletionHandler?
    
    enum Endpoint {
        case InterestingPhotos
        case Photo(String,String)
        case PhotoSizes(String)
        
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
            case .PhotoSizes(let id):
                return serviceURL().URLByAppendingPathComponent("&method=flickr.photos.getSizes&api_key=\(apiKey())&format=json&photo_id=\(id)")
            }
        }
    }
    
    //MARK: - Photo Retrieval
    private func parsePhotoSizes(data: NSData, photo: Photo) {
        do {
            var updatedPhoto = photo
            let json = try NSJSONSerialization.JSONObjectWithData(data.correctedFlickrJSON()!, options: [.AllowFragments])
            if let sizesDict = json["sizes"] as? [String:AnyObject],
                sizes = sizesDict["size"] as? [[String:AnyObject]] {
                    for size in sizes {
                        if let height = size["height"] as? Int, url = size["source"] as? String {
                            if height > 500 {
                                updatedPhoto.url = NSURL(string: url)!
                                self.photos.append(updatedPhoto)
                                print(url)
                                break
                            }
                        }
                    }
            }
        }
        catch let jsonError as NSError {
            print("Error serializing response. Error: \(jsonError)")
        }
    }
    
    private func fetchPhotoSizes(photo: Photo) {
        let url = Endpoint.PhotoSizes(photo.id).url()
        print(url)
        let request = NSURLRequest(URL: url)
        let task = session!.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if(error == nil) {
                if let data = data {
                    self.parsePhotoSizes(data, photo: photo)
                }
            } else {
                print("Error: url:\(url) error\(error)")
            }
        }
        task.resume()
    }
    
    private func parsePhotos(photoData: NSData) {
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(photoData.correctedFlickrJSON()!, options: [.AllowFragments])
            
            if let photosDict = jsonData["photos"] as? [String:AnyObject],
                    photoArray = photosDict["photo"] as? [[String:AnyObject]] {
                
                for item in photoArray {
                    if let title = item["title"] as? String, id = item["id"] as? String, owner = item["owner"] as? String {
                        let photo = Photo(title: title, id: id, url: Endpoint.Photo(owner, id).url())
                        fetchPhotoSizes(photo)
                        // this url will not work... need to do this: https://www.flickr.com/services/api/flickr.photos.getSizes.html
                    }
                }
            }
        }
        catch let jsonError as NSError {
            print("Error serializing response. Error: \(jsonError)")
        }
    }
    
    func fetchPhotos(completion:PhotoServiceCompletionHandler) {
        completionHandler = completion
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
        let url = Endpoint.InterestingPhotos.url()
        let request = NSURLRequest(URL: url)
        let task = session!.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if(error == nil) {
                if let data = data {
                    self.parsePhotos(data)
                    self.session!.finishTasksAndInvalidate()
                }
            } else {
                print("Error: url:\(url) error\(error)")
            }
        }
        task.resume()
    }
    
    //MARK: - Photo Image Retrieval

    func fetchImagesForPhotos(photos:[Photo], completion:PhotoServiceImageRetrievalCompletionHandler) {
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
        for photo in photos {
            let request = NSURLRequest(URL: photo.url)
            let task = session!.dataTaskWithRequest(request) { (data, response, error) -> Void in
                if(error == nil) {
                    if let data = data, image = UIImage(data: data) {
                        completion(photo, image)
                    }
                } else {
                    print("Error: url:\(photo.url) error\(error)")
                }
            }
            task.resume()
        }
    }
}

extension FlickrPhotoService:NSURLSessionDelegate {
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        if photos.count > 0 {
            completionHandler?(photos, nil)
        }
        else {
            completionHandler?(nil,Error(code:"100", name:"Error Retrieving Photos"))
        }
    }
}

extension NSData {
    func correctedFlickrJSON() -> NSData? {
        var correctedJSON: NSData?
        if let invalidJSONString = String(data: self, encoding: NSUTF8StringEncoding) {
            let startIndex = invalidJSONString.startIndex.advancedBy("jsonFlickrApi(".lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            let endIndex = invalidJSONString.endIndex.advancedBy(-1)
            let invalidRange = Range(start: startIndex, end: endIndex)
            let correctedJSONString = invalidJSONString.substringWithRange(invalidRange).stringByReplacingOccurrencesOfString("\\'", withString: "'").stringByRemovingPercentEncoding!
             correctedJSON = correctedJSONString.dataUsingEncoding(NSUTF8StringEncoding)
        }
        return correctedJSON
    }
}