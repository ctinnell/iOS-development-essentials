//
//  PhotoServiceProtocol.swift
//  08-WatchKit
//
//  Created by Clay Tinnell on 1/23/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import Foundation
import UIKit

typealias PhotoServiceCompletionHandler = ([Photo]?, Error?) -> ()
typealias PhotoServiceImageRetrievalCompletionHandler = (Photo) -> ()

protocol PhotoServiceProtocol {
    func fetchPhotos(completion:PhotoServiceCompletionHandler)
    func fetchImagesForPhotos(photos:[Photo], completion:PhotoServiceImageRetrievalCompletionHandler)
}