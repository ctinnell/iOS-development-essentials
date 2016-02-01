//
//  Photo.swift
//  08-WatchKit
//
//  Created by Clay Tinnell on 1/23/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import Foundation
import UIKit

struct Photo {
    var title: String
    var id: String
    var url: NSURL
    var urlDetail: NSURL
    var image: UIImage?
    
    func toDictionary() -> Dictionary<String,AnyObject> {
        var dict = ["title":title, "id":id, "url":url, "urlDetail":urlDetail]
        if let image = image {
            dict["image"] = image
        }
        return dict
    }
}

