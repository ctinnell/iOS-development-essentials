//
//  ViewController.swift
//  02-Swift-Multithreaded Core Data
//
//  Created by Clay Tinnell on 11/18/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let application = UIApplication.sharedApplication().delegate as? AppDelegate
        application?.coreDataManager
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

