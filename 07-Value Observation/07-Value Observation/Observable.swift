//
//  Observable.swift
//  07-Value Observation
//
//  Created by Clay Tinnell on 1/18/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class Observable<T> {
    typealias Observer = T -> Void
    private var observer: Observer?
    
    private var value: T {
        didSet {
            observer?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func observe(observer: Observer?) {
        self.observer = observer
        observer?(value)
    }
}
