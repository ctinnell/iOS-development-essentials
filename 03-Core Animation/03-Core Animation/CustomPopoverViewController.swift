//
//  CustomPopoverViewController.swift
//  03-Core Animation
//
//  Created by Clay Tinnell on 12/13/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

protocol CustomPopoverViewControllerDelegate {
    func okButtonPressed()
    func cancelButtonPressed()
}

class CustomPopoverViewController: UIViewController {

    var delegate: CustomPopoverViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonPressed(sender: AnyObject) {
        delegate?.okButtonPressed()
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        delegate?.cancelButtonPressed()
    }

}
