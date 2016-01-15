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
    private var isInitalAppearance = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureTextView()
        presentInitialAlert()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK - Initial Alert
    private func presentInitialAlert() {
        if isInitalAppearance {
            let vc = UIAlertController(title: "Tip", message: "When you select text, you will be presented with formatting options.", preferredStyle: .Alert)
            vc.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(vc, animated: true, completion: nil)
            isInitalAppearance = false
        }
    }
    
    //MARK - Button Configuration
    private func buttonXLocation() -> CGFloat {
        return view.frame.size.width - (buttonSize + 25.0)
    }
    
    private func buttonYLocation() -> CGFloat {
        return (view.frame.size.height - (buttonSize / 2)) / 2
    }
    
    private func buttonInitialOffset() -> CGFloat {
        return CGFloat(view.frame.size.height + buttonSize + buttonPadding)
    }
    private func addButton(text: String, color: UIColor, actionBlock: (()->())?) {
        let button = RoundButtonView(frame: CGRectMake(buttonXLocation(), buttonInitialOffset(), buttonSize, buttonSize), color: color, text: text, actionBlock: actionBlock)
        view.addSubview(button)
        buttons.append(button)
    }
    
    private func positionButton(index: Int, yPosition: CGFloat) {
        let button = buttons[index]
        button.frame = CGRectMake(button.frame.origin.x, yPosition, button.frame.size.width, button.frame.size.height)
    }
    
    private func positionButtons() {
        for (var index=0; index<self.buttons.count; index++) {
            let yPosition = buttonYLocation() + ((buttonSize + buttonPadding) * CGFloat(index + 1))
            self.positionButton(index, yPosition: yPosition)
        }
    }
    
    private func hideButtons() {
        for (var index=0; index<self.buttons.count; index++) {
            self.positionButton(index, yPosition: buttonInitialOffset())
        }
    }
    
    private func animationButtons(animationBlock: (()->()), completionBlock: (()->())? ) {
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.CurveEaseIn], animations: { () -> Void in
                animationBlock()
            }, completion: { (animationsComleted) -> Void in
                if let completionBlock = completionBlock {
                    completionBlock()
                }
        })
    }
    
    private func removeButtons() {
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons = []
    }

    //MARK - UITextView Delegate
    func textViewDidChangeSelection(textView: UITextView) {
        if let selectedRange = textView.selectedTextRange, selectedText = textView.textInRange(selectedRange) {
            if selectedText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                if buttons.count == 0 {
                    addButton("N", color: UIColor.blackColor(), actionBlock: removeAttributes)
                    addButton("U", color: UIColor.blueColor(), actionBlock: applyUnderlineFormatting)
                    addButton("I", color: UIColor.greenColor(), actionBlock: applyItalicsFormatting)
                    addButton("B", color: UIColor.redColor(), actionBlock: applyBoldFormatting)
                    animationButtons(positionButtons, completionBlock: nil)
                }
            }
            else if buttons.count > 0 {
                animationButtons(hideButtons, completionBlock: removeButtons)
            }
        }
    }
    
    //MARK - Text Actions
    private func applyAttribute(attributeName: String, attributeValue: AnyObject, range: NSRange) {
        let mutableText = NSMutableAttributedString(attributedString: textView.attributedText)
        mutableText.addAttribute(attributeName, value: attributeValue, range: range)
        textView.attributedText = mutableText
    }
    
    private func initializeAttributes() {
        let range = NSMakeRange(0, textView.attributedText.length)
        applyAttribute(NSFontAttributeName, attributeValue: UIFont.systemFontOfSize(14), range: range)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        applyAttribute(NSParagraphStyleAttributeName, attributeValue: paragraphStyle, range: range)
    }
    
    private func configureTextView() {
        if let text = text {
            textView.attributedText = NSAttributedString(string: text)
            initializeAttributes()
        }
    }
    
    private func removeAttributes() {
        let mutableText = NSMutableAttributedString(attributedString: textView.attributedText)
        mutableText.removeAttribute(NSUnderlineStyleAttributeName, range: textView.selectedRange)
        mutableText.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(15), range: textView.selectedRange)
        textView.attributedText = mutableText
    }
    
    private func applyBoldFormatting() {
        let font = UIFont.boldSystemFontOfSize(14)
        applyAttribute(NSFontAttributeName, attributeValue: font, range: textView.selectedRange)
    }
    
    private func applyUnderlineFormatting() {
        applyAttribute(NSUnderlineStyleAttributeName, attributeValue: 1, range: textView.selectedRange)
    }
    
    private func applyItalicsFormatting() {
        let font = UIFont.italicSystemFontOfSize(14)
        applyAttribute(NSFontAttributeName, attributeValue: font, range: textView.selectedRange)
    }
}