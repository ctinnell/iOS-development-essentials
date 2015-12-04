//
//  String+Encryption.swift
//  OAuth2Demo-04
//
//  Created by Clay Tinnell on 12/4/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//
import Foundation

extension String {
    func encrypt_HMAC_SHA1(encryptionKey: String) -> String {
        //A little help from this guy:
        //http://www.iteachcoding.com/how-to-hmac-sha1-sign-an-api-request-using-swift
        
        let dataToDigest = self.dataUsingEncoding(NSUTF8StringEncoding)
        let secretKey = encryptionKey.dataUsingEncoding(NSUTF8StringEncoding)
        
        let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLength)
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), secretKey!.bytes, secretKey!.length, dataToDigest!.bytes, dataToDigest!.length, result)
        
        return NSData(bytes: result, length: digestLength).base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
    }
}


