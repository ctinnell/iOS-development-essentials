//
//  PhotoServiceProtocol.swift
//  08-WatchKit
//
//  Created by Clay Tinnell on 1/23/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import Foundation
typealias PhotoServiceCompletionHandler = ([Photo]?, Error?) -> ()

protocol PhotoServiceProtocol {
    func fetchPhotos(completion:PhotoServiceCompletionHandler)
}