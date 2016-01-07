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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let actionSheetButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "presentActionSheet")
        self.navigationItem.rightBarButtonItem = actionSheetButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentWordFlowViewController(action: UIAlertAction) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("wordFlowViewController") as? WordFlowViewController {
            vc.text = textView.text
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func presentMovableWordFlowViewController(action: UIAlertAction) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("movableWordFlowViewController") as? MovableWordFlowViewController {
            vc.text = textView.text
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func presentTwoColumnViewController(action: UIAlertAction) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("twoColumnViewController") as? TwoColumnViewController {
            vc.text = textView.text
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func presentActionSheet() {
        let actionSheet = UIAlertController(title: "Choose Action", message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Word Flow", style: .Default, handler: presentWordFlowViewController))
        actionSheet.addAction(UIAlertAction(title: "Movable Word Flow", style: .Default, handler: presentMovableWordFlowViewController))
        actionSheet.addAction(UIAlertAction(title: "Two Column Text", style: .Default, handler: presentTwoColumnViewController))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(actionSheet, animated: true, completion: nil)
    }
}

