//
//  ViewController.swift
//  06-TextKit
//
//  Created by Clay Tinnell on 1/2/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    enum TextViewControllerType: String {
        case LetterPress = "letterPressViewController"
        case WordFlow = "wordFlowViewController"
        case MovableWord = "movableWordFlowViewController"
        case TwoColumn = "twoColumnViewController"
        case TextViewer = "textViewerViewController"
        
        static let values: [TextViewControllerType] = [.LetterPress, .WordFlow, .MovableWord, .TwoColumn, .TextViewer]
        
        func title() -> String {
            var title = " "
            switch self {
            case .LetterPress:
                title = "Letter Press Text Effect"
            case .WordFlow:
                title = "Word Flow"
            case .MovableWord:
                title = "Movable Word Flow"
            case .TwoColumn:
                title = "Two Column Text"
            case .TextViewer:
                title = "Text Viewer"
            }
            
            return title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let actionSheetButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "presentActionSheet")
        self.navigationItem.rightBarButtonItem = actionSheetButton
    }
    
    
    func presentTextDisplayViewController(textViewController: TextViewControllerType) {
        guard let vc = storyboard?.instantiateViewControllerWithIdentifier(textViewController.rawValue) else { return }
        
        if vc.respondsToSelector(Selector("setText:")) {
           vc.performSelector(Selector("setText:"), withObject: textView.text)
        }
        
        if vc.respondsToSelector(Selector("setTextTitle:")) {
            vc.performSelector(Selector("setTextTitle:"), withObject: textViewController.title())
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }

    func presentActionSheet() {
        let actionSheet = UIAlertController(title: "Choose Action", message: nil, preferredStyle: .ActionSheet)
        
        for vcType in TextViewControllerType.values {
            let action = UIAlertAction(title: vcType.title(), style: .Default, handler: { (action) -> Void in
                self.presentTextDisplayViewController(vcType)
            })
            actionSheet.addAction(action)
        }
        presentViewController(actionSheet, animated: true, completion: nil)
    }
}

