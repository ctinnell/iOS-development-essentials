//
//  CustomPopoverAnimationViewController.swift
//  03-Core Animation
//
//  Created by Clay Tinnell on 11/30/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class CustomPopoverAnimationViewController: UIViewController, CustomPopoverViewControllerDelegate {

    var popoverViewController: CustomPopoverViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showPopover(sender: AnyObject) {
        popoverViewController = storyboard?.instantiateViewControllerWithIdentifier("customPopoverViewController") as?CustomPopoverViewController
        
        if let popoverViewController = popoverViewController {
            popoverViewController.delegate = self
            popoverViewController.modalPresentationStyle = .OverCurrentContext
            presentViewController(popoverViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - CustomPopoverViewControllerDelegate
    func okButtonPressed() {
        self.popoverViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    func cancelButtonPressed() {
        self.popoverViewController?.dismissViewControllerAnimated(true, completion: nil)
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
