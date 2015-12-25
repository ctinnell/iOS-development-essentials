//
//  ViewController.swift
//  05-CoreText
//
//  Created by Clay Tinnell on 12/20/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parseButton = UIBarButtonItem(title: "Word Cloud", style: .Plain, target: self, action: "generateWordCloud")
        self.navigationItem.rightBarButtonItem = parseButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func generateWordCloud() {
        let wordCloudItems = WordCloudParser.wordCloudElements(textView.text)
        for item in wordCloudItems {
            print("\(item.word) (\(item.count))")
        }
        presentWordCloudViewController(wordCloudItems)
    }
    
    func presentWordCloudViewController(words: [WordCloudParser.WordCloudElement]) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("wordCloudViewController") as! WordCloudViewController
        vc.wordCloudItems = words
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

