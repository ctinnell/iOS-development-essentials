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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureTextView()
        //addButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureTextView() {
        textView.text = text
    }
    
    private func addButton() {
        let button = RoundButtonView(frame: CGRectMake(100, 100, 25, 25), color: UIColor.blueColor(), text: "U", actionBlock: nil)
        view.addSubview(button)
    }

}
