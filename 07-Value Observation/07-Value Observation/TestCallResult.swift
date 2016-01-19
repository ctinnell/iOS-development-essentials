//
//  TestCallResult.swift
//  07-Value Observation
//
//  Created by Clay Tinnell on 1/16/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class TestCallResult: NSObject {
    var url: NSURL
    var index: Observable<Int>
    
    init (url: NSURL, index: Int) {
        self.url = url
        self.index = Observable(index)
    }
}
