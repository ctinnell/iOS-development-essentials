//
//  PersonListViewControllerTableViewController.swift
//  02-Swift-Multithreaded Core Data
//
//  Created by Clay Tinnell on 11/20/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class PersonListViewControllerTableViewController: UITableViewController {

    let application = UIApplication.sharedApplication().delegate as? AppDelegate
    var people: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePeople()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadPeople()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = people?[indexPath.row].name
        cell.detailTextLabel?.text = people?[indexPath.row].email
        
        return cell
    }
    
    func initializePeople() {
        application?.coreDataManager
        if let moc = application?.coreDataManager.managedObjectContext {
            Person.deleteAllObjects(moc)
            Person.loadTestData(moc)
        }
    }
    
    func loadPeople() {
        if let moc = application?.coreDataManager.managedObjectContext {
            (people,_) = Person.allObjects(moc)
        }
        self.tableView.reloadData()
    }

}
