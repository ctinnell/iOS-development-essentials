//
//  WordCloudParser.swift
//  05-CoreText
//
//  Created by Clay Tinnell on 12/20/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class WordCloudParser: NSObject {
    struct WordCloudElement {
        var word: String
        var count: Int
        var bounds: CGRect?
    }
    
    static func wordCloudElements(text: String) -> [WordCloudElement] {
        let words = text.stripSpecialCharacters().trimExtraWhiteSpace().componentsSeparatedByWhiteSpace().sort()
        var wordCloudElements = [WordCloudElement]()
        var previousWord = ""
        
        var wordCloudElement: WordCloudElement?
        
        for word in words {
            if word == previousWord {
                wordCloudElement?.count++
            }
            else {
                if let safeWordCloudElement = wordCloudElement {
                    wordCloudElements.append(safeWordCloudElement)
                }
                wordCloudElement = WordCloudElement(word: word, count: 1, bounds: nil)
                previousWord = word
            }
        }
        return wordCloudElements.sort{$0.count > $1.count}
    }
}

extension String {
    func stripSpecialCharacters() -> String {
        return self.componentsSeparatedByCharactersInSet(NSCharacterSet.letterCharacterSet().invertedSet).joinWithSeparator(" ").lowercaseString
    }
    
    func componentsSeparatedByWhiteSpace() -> [String] {
        return self.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    func trimExtraWhiteSpace() -> String {
        return self.componentsSeparatedByWhiteSpace().filter({!$0.isEmpty}).joinWithSeparator(" ")
    }
}
