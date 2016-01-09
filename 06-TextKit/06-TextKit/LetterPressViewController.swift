//
//  LetterPressViewController.swift
//  06-TextKit
//
//  Created by Clay Tinnell on 1/9/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class LetterPressViewController: UIViewController {
    
    var text: String?
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureTextView()
    }
    
    private func configureTextView() {
        if let text = text {
            let attributedString = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName:UIColor.blueColor(), NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1), NSTextEffectAttributeName:NSTextEffectLetterpressStyle])
            textView.attributedText = attributedString
            textView.backgroundColor = UIColor.brownColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
