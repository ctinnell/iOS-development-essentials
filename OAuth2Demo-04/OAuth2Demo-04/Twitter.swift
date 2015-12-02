//
//  Twitter.swift
//  OAuth2Demo-04
//
//  Created by Clay Tinnell on 11/30/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class Twitter: NSObject {

    var oauthConsumerKey: String
    var oauthConsumerSecret: String
    
    var oauthSignatureMethod = "HMAC-SHA1"
    var oauthVersion = "1.0"
    
    enum TwitterEndpoint {
        case Authorization
        case RequestToken
        
        func baseURL() -> NSURL {
            return NSURL(string: "https://api.twitter.com")!
        }
        
        func url() -> NSURL {
            switch self {
            case .RequestToken:
                return baseURL().URLByAppendingPathComponent("/oauth/request_token")
            case .Authorization:
                return baseURL().URLByAppendingPathComponent("/oauth/authorization")
            }
        }
    }
    
    init(oauthConsumerKey: String, oauthConsumerSecret: String) {
        self.oauthConsumerKey = oauthConsumerKey
        self.oauthConsumerSecret = oauthConsumerSecret
    }
    
    
}
