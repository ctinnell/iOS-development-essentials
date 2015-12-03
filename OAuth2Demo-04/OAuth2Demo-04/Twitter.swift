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
    var oauthCallback: String
    
    var oauthAccessToken: String?
    var oauthRequestToken: String?
    
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
    
    // MARK: - Initialization
    init(oauthConsumerKey: String, oauthConsumerSecret: String, oauthCallback: String) {
        self.oauthConsumerKey = oauthConsumerKey
        self.oauthConsumerSecret = oauthConsumerSecret
        self.oauthCallback = oauthCallback
    }
    
    // MARK: -
    func parametersByAddingOauthParameters(parameters: [String:String]) -> [String:String]  {
        var updatedParms = parameters
        updatedParms["oauth_callback"] = oauthCallback
        updatedParms["oauth_consumer_key"] = oauthConsumerKey
        updatedParms["oauth_nonce"] = NSUUID().UUIDString
        updatedParms["oauth_signature_method"] = "HMAC-SHA1"
        updatedParms["oauth_timestamp"] = "\(NSDate().timeIntervalSince1970)"
        updatedParms["oauth_version"] = "1.0"
        
        if let oauthAccessToken = oauthAccessToken {
            updatedParms["oauth_token"] = oauthAccessToken
        }
        else if let oauthRequestToken = oauthRequestToken {
            updatedParms["oauth_token"] = oauthRequestToken
        }
        return updatedParms
    }
    
    func parametersString(parameters: [String:String]) -> String {
        var updatedParms = [String:String]()
        var parmsString = ""
        
        //1. Percent encode every key and value that will be signed
        for (key,value) in parameters {
            if let encodedKey = encodedString(key), encodedValue = encodedString(value) {
                updatedParms[encodedKey] = updatedParms[encodedValue]
            }
        }
        
        //2. Sort the list of parameters alphabetically by encoded key
        let sortedParms = updatedParms.sort {$0.0 < $1.0}
        
        //3. Append the encoded key, =, and &
        var loopCounter = 0
        for (key,value) in sortedParms {
            if loopCounter > 0
            {
                parmsString = parmsString + "&"
                loopCounter++
            }
            parmsString = "(\(parmsString)\(key)=\(value)"
        }
        return parmsString
    }

    func encodedString(str: String) -> String? {
        let allowedCS = NSCharacterSet.URLQueryAllowedCharacterSet()
        return str.stringByAddingPercentEncodingWithAllowedCharacters(allowedCS)
    }
    
    func oauthSignature(endpoint: TwitterEndpoint, parameters: [String:String]) -> String {
        var oAuthSignature = " "
        
        //https://dev.twitter.com/oauth/overview/creating-signatures

        //Collecting the request method and URL
        let requestMethod = "POST"
        let url = endpoint.url()
        
        //Collecting parameters
        let paramsString = parametersString(parameters)
        
        //Creating the signature base string
        return oAuthSignature
        
    }
    
}
