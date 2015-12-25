//
//  WordCloudViewController.swift
//  05-CoreText
//
//  Created by Clay Tinnell on 12/22/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class WordCloudViewController: UIViewController {

    var wordCloudItems: [WordCloudParser.WordCloudElement]?

    @IBOutlet var wordCloudView: WordCloudView!
     
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        wordCloudView.wordCloudItems = wordCloudItems
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
