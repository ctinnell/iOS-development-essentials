//
//  ViewController.swift
//  OAuth2Demo-04
//
//  Created by Clay Tinnell on 11/29/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //PRAGMA: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //PRAGMA: - Private
    private func authenticate() {
        
    }
    
    //PRAGMA: - IBActions
    @IBAction func authenticationButtonPressed(sender: AnyObject) {
        let oauthapi = Twitter(oauthConsumerKey: "xlL6qvKwhfIq74kpYm5Xpwque", oauthConsumerSecret: "NguEuRRTGnlvs9BM8oL5uSHcBVMuB8UKGwhNUtICusJT1cFxb4", oauthCallback: "myapp://twitter_access_tokens/")
        oauthapi.authenticate()
    }
}

