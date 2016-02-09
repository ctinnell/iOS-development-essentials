//
//  Photo.swift
//  08-WatchKit
//
//  Created by Clay Tinnell on 1/23/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class Photo {
    var title: String
    var id: String
    var url: NSURL?
    var urlDetail: NSURL?
    var image: UIImage?
    
    init(title: String, id: String, url: NSURL?, urlDetail: NSURL?, image: UIImage?) {
        self.title = title
        self.id = id
        self.url = url
        self.urlDetail = urlDetail
        self.image = image
    }
    
    init(dictionary: [String:AnyObject]) {
        
        if let title = dictionary["title"] as? String {
            self.title = title
        }
        else {
            self.title = " "
        }
        
        if let id = dictionary["id"] as? String {
            self.id = id
        }
        else {
            self.id = " "
        }
        
        if let image = dictionary["image"] as? NSData {
            self.image = UIImage(data: image)
        }
    }
    
    func toDictionary() -> [String:AnyObject] {
        var dict: [String:AnyObject] = ["title":title, "id":id]
        if let image = image {
            dict["image"] = UIImageJPEGRepresentation(image, 0.1)
        }
        return dict
    }
}

