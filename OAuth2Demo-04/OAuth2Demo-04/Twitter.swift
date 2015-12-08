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
    
    var screenName: String?
    var userId: String?
    var oauthAccessTokenSecret: String?
    
    enum TwitterEndpoint {
        case Authorize(String)
        case RequestToken
        case AccessToken
        case HomeTimeline
        
        func baseURL() -> NSURL {
            return NSURL(string: "https://api.twitter.com")!
        }
        
        func url() -> NSURL {
            switch self {
            case .RequestToken:
                return baseURL().URLByAppendingPathComponent("/oauth/request_token")
            case .Authorize(let oauthToken):
               var urlString = String(baseURL())
               urlString += "/oauth/authorize?oauth_token=\(oauthToken)"
               return NSURL(string: urlString)!
            case .AccessToken:
                return baseURL().URLByAppendingPathComponent("/oauth/access_token")
            case .HomeTimeline:
                return baseURL().URLByAppendingPathComponent("/1.1/statuses/home_timeline.json")
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
            updatedParms["oauth_callback"] = oauthCallback
        }
        else {
            updatedParms["oauth_callback"] = oauthCallback
        }
        
        return updatedParms
    }
    
    private func parametersAuthorizationString(parameters: [String:String]) -> String {
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
    
    private func oauthSignature(endpoint: TwitterEndpoint, parameters: [String:String]) -> String {
        
        //https://dev.twitter.com/oauth/overview/creating-signatures

        //Collecting the request method and URL
        let requestMethod = "POST"
        let urlString = "\(endpoint.url())"
        
        //Collecting parameters
        let paramsString = parametersAuthorizationString(parameters)
        
        //Creating the signature base string
        let signatureBaseString = oauthSignatureBaseString(requestMethod, url: urlString, paramsString: paramsString)
        print("Signature Base String\n\(signatureBaseString)\n")
        //Get the signing key
        let signingKey = oauthSignatureSigningKey()
        print("Signing Key\n\(signingKey)\n")
        
        //Calculate the signature
        let signature = oauthSignature(signatureBaseString, signingKey: signingKey)
        print("Signature\n\(signature)\n")
        
        return signature
    }
    
    private func parameterStringForHeader(parameters: [String:String]) -> String {
        var parameterString = "OAuth "
        var loopCounter = 0

        let sortedParms = parameters.sort {$0.0 < $1.0}

        for (key, value) in sortedParms {
            if let encodedKey = encodedString(key), let encodedValue = encodedString(value) {
                if loopCounter > 0 { parameterString += "," }
                parameterString = "\(parameterString)\(encodedKey)=\"\(encodedValue)\""
            }
            loopCounter++
        }
        return parameterString
    }
    
    func tokenDictionaryFromResponse(str: String) -> [String:String] {
        var dict = [String:String]()
        let components = str.componentsSeparatedByString("&")
        for component in components {
            let keysAndValues = component.componentsSeparatedByString("=")
            dict[keysAndValues[0]] = keysAndValues[1]
        }
        return dict
    }
    
    func generateAccessToken(verifier: String, completion: (String,String)->()) {
        var parameters = ["oauth_verifier":verifier]
        parameters = parametersByAddingOauthParameters(parameters)
        
        let twitterEndpoint = TwitterEndpoint.AccessToken
        let signature = oauthSignature(twitterEndpoint, parameters: parameters)
        parameters["oauth_signature"] = signature
        
        //Need to generate header parameters
        let parametersString = parameterStringForHeader(parameters)
        print("Parameter String\n\(parametersString)\n")
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let request = NSMutableURLRequest(URL: twitterEndpoint.url())
        request.HTTPMethod = "POST"
        request.setValue(parametersString, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if(error == nil) {
                if let data = data, dataString = String(data: data, encoding: NSUTF8StringEncoding) {
                    do {
                        let dict = self.tokenDictionaryFromResponse(dataString)
                        self.oauthAccessToken = dict["oauth_token"]
                        self.oauthAccessTokenSecret = dict["oauth_token_secret"]
                        self.screenName = dict["screen_name"]
                        self.userId = dict["user_id"]
                        if let oauthAccessToken = self.oauthAccessToken, oauthAccessTokenSecret = self.oauthAccessTokenSecret,
                            screenName = self.screenName, userId = self.userId {
                                print("\n************************************************")
                                print("Access Token\n\(oauthAccessToken)\n")
                                print("Token Secret\n\(oauthAccessTokenSecret)\n")
                                print("User Id\n\(userId)\n")
                                print("Screen Name\n\(screenName)")
                                print("************************************************")
                        }

                    }
                }
            } else {
                print("Error: url:\(twitterEndpoint) error\(error)")
            }
            
        }
        
        task.resume()
        
    }
    
    func authenticate(completion: (String)->()) {
        var parameters = parametersByAddingOauthParameters([String : String]())

        let twitterEndpoint = TwitterEndpoint.RequestToken
        let signature = oauthSignature(twitterEndpoint, parameters: parameters)
        parameters["oauth_signature"] = signature

        //Need to generate header parameters
        let parametersString = parameterStringForHeader(parameters)
        print("Parameter String\n\(parametersString)\n")
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let request = NSMutableURLRequest(URL: twitterEndpoint.url())
        request.HTTPMethod = "POST"
        request.setValue(parametersString, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if(error == nil) {
                if let data = data, dataString = String(data: data, encoding: NSUTF8StringEncoding) {
                    do {
                        print("\n************************************************")
                        print("We got Tokens!\n\(dataString)")
                        print("************************************************")
                        let tokens = self.tokenDictionaryFromResponse(dataString)
                        if let oathToken = tokens["oauth_token"] {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(oathToken)
                            })                            
                        }
                    }
                }
            } else {
                print("Error: url:\(twitterEndpoint) error\(error)")
            }
            
        }
        
        task.resume()
    }
    
    func homeTimeline(completion: (String)->()) {
        var parameters = parametersByAddingOauthParameters([String : String]())
        
        let twitterEndpoint = TwitterEndpoint.HomeTimeline
        let signature = oauthSignature(twitterEndpoint, parameters: parameters)
        parameters["oauth_signature"] = signature
        
        //Need to generate header parameters
        let parametersString = parameterStringForHeader(parameters)
        print("Parameter String\n\(parametersString)\n")
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let request = NSMutableURLRequest(URL: twitterEndpoint.url())
        request.HTTPMethod = "GET"
        request.setValue(parametersString, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if(error == nil) {
                if let data = data, dataString = String(data: data, encoding: NSUTF8StringEncoding) {
                    do {
                        print("\n************************************************")

                    }
                }
            } else {
                print("Error: url:\(twitterEndpoint) error\(error)")
            }
            
        }
        
        task.resume()
    }
    
}
