//
//  CustomPopoverAnimationViewController.swift
//  03-Core Animation
//
//  Created by Clay Tinnell on 11/30/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class CustomPopoverAnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showPopover(sender: AnyObject) {
        let popoverViewController = storyboard?.instantiateViewControllerWithIdentifier("customPopoverViewController") as! CustomPopoverViewController
        popoverViewController.modalPresentationStyle = .OverCurrentContext
        popoverViewController.view.backgroundColor = UIColor(red: 38/255, green: 41/255, blue: 44/255, alpha: 0.5)
        presentViewController(popoverViewController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
