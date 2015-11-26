//
//  MenuTableViewController.swift
//  03-Core Animation
//
//  Created by Clay Tinnell on 11/22/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Rotating Cube"
        case 1:
            cell.textLabel?.text = "Folding View"
        default:
            cell.textLabel?.text = " "
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            presentViewController("boxViewController")
        case 1:
            presentViewController("foldingViewController")
            
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
