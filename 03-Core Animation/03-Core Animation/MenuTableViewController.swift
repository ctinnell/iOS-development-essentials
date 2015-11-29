//
//  MenuTableViewController.swift
//  03-Core Animation
//
//  Created by Clay Tinnell on 11/22/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    //MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Rotating Cube"
        case 1:
            cell.textLabel?.text = "Folding View"
        case 2:
            cell.textLabel?.text = "Login Keyframe Animation"
        default:
            cell.textLabel?.text = " "
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            presentViewController("boxViewController")
        case 1:
            presentViewController("foldingViewController")
        case 2:
            presentViewController("loginAnimationViewController")
        default:
            print("Unexpected: Index not found...")
        }
    }
    
    // MARK: - Navigation
    private func presentViewController(identifier: String) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier(identifier) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
