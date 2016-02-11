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
        let actionSheetButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "presentActionSheet")
        self.navigationItem.rightBarButtonItem = actionSheetButton
    }

    func generateWordCloud(action: UIAlertAction) {
        let wordCloudItems = WordCloudParser.wordCloudElements(textView.text)
        for item in wordCloudItems {
            print("\(item.word) (\(item.count))")
        }
        presentWordCloudViewController(wordCloudItems)
    }
    
    func presentWordCloudViewController(words: [WordCloudParser.WordCloudElement]) {
        guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("wordCloudViewController") as? WordCloudViewController else { return }
        
        vc.wordCloudItems = words
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentTwoColumnTextViewController(action: UIAlertAction) {
        guard let vc = storyboard?.instantiateViewControllerWithIdentifier("twoColumnTextViewController") as? TwoColumnTextViewController else { return }

        vc.text = textView.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentActionSheet() {
        let actionSheet = UIAlertController(title: "Choose Action", message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Word Cloud", style: .Default, handler: generateWordCloud))
        actionSheet.addAction(UIAlertAction(title: "Two Column Text", style: .Default, handler: presentTwoColumnTextViewController))
        presentViewController(actionSheet, animated: true, completion: nil)
    }
}

