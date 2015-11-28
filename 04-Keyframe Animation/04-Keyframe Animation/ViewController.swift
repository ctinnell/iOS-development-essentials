//
//  ViewController.swift
//  04-Keyframe Animation
//
//  Created by Clay Tinnell on 11/27/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let passwordText = passwordTextField.text {
            authenticate(passwordText)
        }
        return true
    }
    
    // MARK - Authentication
    func authenticate(password: String) -> Bool {
        return password == "password1234"
    }

}

