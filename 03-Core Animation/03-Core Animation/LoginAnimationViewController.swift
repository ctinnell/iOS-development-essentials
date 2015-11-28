//
//  LoginAnimationViewController.swift
//  03-Core Animation
//
//  Created by Clay Tinnell on 11/28/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class LoginAnimationViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let passwordText = passwordTextField.text {
            if !authenticate(passwordText) {shake(passwordTextField)}
        }
        return true
    }
    
    // MARK: - Authentication
    private func authenticate(password: String) -> Bool {
        return password == "password1234"
    }
    
    // MARK: - Animation
    private func shake(textField: UITextField) {
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.values = [0,25,-25,25,0]
        animation.keyTimes = [0,0.25,0.5,0.75,1]
        animation.duration = 0.5
        animation.additive = true
        textField.layer.addAnimation(animation, forKey: "shakeAnimation")
    }

}
