//
//  LetterPressViewController.swift
//  06-TextKit
//
//  Created by Clay Tinnell on 1/9/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class LetterPressViewController: UIViewController {
    
    var textTitle: String?
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureTextView()
    }
    
    private func configureTextView() {
        guard let text = textTitle else { return }

        let attributedString = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName:UIColor.blueColor(), NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1), NSTextEffectAttributeName:NSTextEffectLetterpressStyle])
        
        textView.attributedText = attributedString
        textView.backgroundColor = UIColor.brownColor()
    }
}
