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
    private let buttonPadding = CGFloat(20.0)
    
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
    
    private func buttonXLocation() -> CGFloat {
        return view.frame.size.width - (buttonSize + 25.0)
    }
    
    private func buttonYLocation() -> CGFloat {
        return (view.frame.size.height - (buttonSize / 2)) / 2
    }
    
    private func addButton(text: String, color: UIColor, actionBlock: (()->())?) {
        let buttonInitialOffset = CGFloat(view.frame.size.height + buttonSize + buttonPadding)
        let button = RoundButtonView(frame: CGRectMake(buttonXLocation(), buttonInitialOffset, buttonSize, buttonSize), color: color, text: text, actionBlock: actionBlock)
        view.addSubview(button)
        buttons.append(button)
    }
    
    private func positionButton(index: Int) {
        let yPosition = buttonYLocation() + ((buttonSize + buttonPadding) * CGFloat(index + 1))
        let button = buttons[index]
        button.frame = CGRectMake(button.frame.origin.x, yPosition, button.frame.size.width, button.frame.size.height)
    }
    
    private func positionButtons() {
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.CurveEaseIn], animations: { () -> Void in
            for (var index=0; index<self.buttons.count; index++) {
                self.positionButton(index)
            }
           
        }, completion: nil)
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
                    addButton("I", color: UIColor.greenColor(), actionBlock: nil)
                    addButton("B", color: UIColor.redColor(), actionBlock: nil)
                    positionButtons()
                }
            }
            else if buttons.count > 0 {
                removeButtons()
            }
        }
    }
}