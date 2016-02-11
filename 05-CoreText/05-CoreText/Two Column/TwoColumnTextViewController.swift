//
//  TwoColumnTextViewController.swift
//  05-CoreText
//
//  Created by Clay Tinnell on 1/1/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class TwoColumnTextViewController: UIViewController {

    var text: String?
    
    @IBOutlet var twoColumnTextView: TwoColumnTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        twoColumnTextView.text = text
    }
}
