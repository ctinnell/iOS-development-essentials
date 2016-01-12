//
//  TextViewerViewController.swift
//  06-TextKit
//
//  Created by Clay Tinnell on 1/10/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class TextViewerViewController: UIViewController {

    var text: String?
    @IBOutlet weak var textView: UITextView!
    
    private var buttons: [RoundButtonView] = []
    private let buttonSize = CGFloat(25.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureTextView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureTextView() {
        textView.text = text
    }
    
    private func addButton(text: String, color: UIColor, actionBlock: (()->())?) {
        let button = RoundButtonView(frame: CGRectMake(100, 100, buttonSize, buttonSize), color: color, text: text, actionBlock: actionBlock)
        view.addSubview(button)
        buttons.append(button)
    }
    
    private func removeButtons() {
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons = []
    }

    func textViewDidChangeSelection(textView: UITextView) {
        if let selectedRange = textView.selectedTextRange, selectedText = textView.textInRange(selectedRange) {
            if selectedText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                print("text selected: \(selectedText)")
                if buttons.count == 0 {
                    addButton("U", color: UIColor.blueColor(), actionBlock: nil)
                }
            }
            else if buttons.count > 0 {
                removeButtons()
            }
        }
    }
}