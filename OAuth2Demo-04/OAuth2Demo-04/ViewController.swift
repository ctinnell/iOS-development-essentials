//
//  ViewController.swift
//  OAuth2Demo-04
//
//  Created by Clay Tinnell on 11/29/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    let oauthapi = Twitter(oauthConsumerKey: "xlL6qvKwhfIq74kpYm5Xpwque", oauthConsumerSecret: "NguEuRRTGnlvs9BM8oL5uSHcBVMuB8UKGwhNUtICusJT1cFxb4", oauthCallback: "myapp://twitter_access_tokens/")

    //PRAGMA: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if let _ = oauthapi.oauthRequestToken {
            return true
        }
        else {
            let alertController = UIAlertController(title: "Authentication Missing", message: "You must first authenticate to view timeline.", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(alertAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let tweetTimelineViewController = segue.destinationViewController as? TweetTimelineTableViewController {
            tweetTimelineViewController.oauthapi = oauthapi
        }
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
        oauthapi.authenticate { (token) in
            print(token)
            let endpoint = Twitter.TwitterEndpoint.Authorize(token)
            let url = endpoint.url()
            print("Authorize URL\n\(url)")
            let vc = SFSafariViewController(URL: url)
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    
    
    
}

