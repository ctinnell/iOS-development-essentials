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
    
    var oauthTokenSecret: String?
    
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
    private func parametersByAddingOauthParameters(parameters: [String:String]) -> [String:String]  {
        var updatedParms = parameters
        updatedParms["oauth_callback"] = oauthCallback
        updatedParms["oauth_consumer_key"] = oauthConsumerKey
        updatedParms["oauth_nonce"] = NSUUID().UUIDString
        updatedParms["oauth_signature_method"] = "HMAC-SHA1"
        updatedParms["oauth_timestamp"] = "\(Int(NSDate().timeIntervalSince1970))"
        updatedParms["oauth_version"] = "1.0"
        
        if let oauthAccessToken = oauthAccessToken {
            updatedParms["oauth_token"] = oauthAccessToken
        }
        else if let oauthRequestToken = oauthRequestToken {
            updatedParms["oauth_token"] = oauthRequestToken
        }
        return updatedParms
    }
    
    private func parametersString(parameters: [String:String]) -> String {
        var updatedParms = [String:String]()
        var parmsString = ""
        
        //1. Percent encode every key and value that will be signed
        for (key,value) in parameters {
            if let encodedKey = encodedString(key), encodedValue = encodedString(value) {
                updatedParms[encodedKey] = encodedValue
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
            }
            parmsString = "\(parmsString)\(key)=\(value)"
            loopCounter++
        }
        return parmsString
    }

    private func encodedString(str: String) -> String? {
        return str.stringByAddingPercentEncodingWithAllowedCharacters(rfc3986AllowableCharacterSet())
    }
    
    private func oauthSignatureBaseString(requestMethod: String, url: String, paramsString: String) -> String {
        var baseString = ""
        if let encodedUrl = encodedString(url), encodedParamsString = encodedString(paramsString) {
            baseString = "\(requestMethod)&\(encodedUrl)&\(encodedParamsString)"
        }
        return baseString
    }
    
    private func oauthSignatureSigningKey() -> String {
        var signingKey = "\(encodedString(oauthConsumerSecret)!)&"
        if let oauthTokenSecret = oauthTokenSecret, encodedSecret = encodedString(oauthTokenSecret) {
            signingKey += encodedSecret
        }
        return signingKey
    }
    
    private func oauthSignature(baseString: String, signingKey: String) -> String {
        return baseString.encrypt_HMAC_SHA1(signingKey)
    }
    
    private func rfc3986AllowableCharacterSet() -> NSCharacterSet {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._~")
        return characterSet
    }
    
    private func oauthAuthorization(endpoint: TwitterEndpoint, parameters: [String:String]) -> String {
        let oAuthSignature = " "
        
        //https://dev.twitter.com/oauth/overview/creating-signatures

        //Collecting the request method and URL
        let requestMethod = "POST"
        let urlString = "\(endpoint.url())"
        
        //Collecting parameters
        let paramsString = parametersString(parameters)
        
        //Creating the signature base string
        let signatureBaseString = oauthSignatureBaseString(requestMethod, url: urlString, paramsString: paramsString)
        print("Signature Base String\n\(signatureBaseString)\n")
        //Get the signing key
        let signingKey = oauthSignatureSigningKey()
        print("Signing Key\n\(signingKey)\n")
        
        //Calculate the signature
        let signature = oauthSignature(signatureBaseString, signingKey: signingKey)
        print("Signature\n\(signature)\n")
        
        return oAuthSignature
        
    }
    
    func authenticate() {
        let parameters = parametersByAddingOauthParameters([String : String]())
        let twitterEndpoint = TwitterEndpoint.RequestToken
        let authentication = oauthAuthorization(twitterEndpoint, parameters: parameters)
        
    }
    
}
