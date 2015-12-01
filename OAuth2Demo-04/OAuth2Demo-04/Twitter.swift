//
//  Twitter.swift
//  OAuth2Demo-04
//
//  Created by Clay Tinnell on 11/30/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class Twitter: NSObject {

    enum TwitterEndpoint {
        case Authorization
        
        func baseURL() -> NSURL {
            return NSURL(string: "http://api.twitter.com")!
        }
        
        func url() -> NSURL {
            switch self {
            case .Authorization:
                return baseURL().URLByAppendingPathComponent("/oauth/authorization")
            }
        }
    }
}
