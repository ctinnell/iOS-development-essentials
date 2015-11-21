//
//  PersonListViewControllerTableViewController.swift
//  02-Swift-Multithreaded Core Data
//
//  Created by Clay Tinnell on 11/20/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//
//  This sample app demonstrates performing Core Data writes on a private thread, 
//  while retrieiving objects for the UI on the main thread.

import UIKit

class PersonListViewControllerTableViewController: UITableViewController {

    let application = UIApplication.sharedApplication().delegate as? AppDelegate
    var people: [Person]?
    var coreDataManager: CoreDataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        coreDataManager = CoreDataManager() {
            self.initializePeople()
        }
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
        // because this calls an asynchronous write, a completion block is required
        if let coreDataManager = coreDataManager {
            Person.deleteAllObjects(coreDataManager) {
                Person.loadTestData(coreDataManager) {
                    self.loadPeople()
                }
            }
        }
    }
    
    func loadPeople() {
        if let coreDataManager = coreDataManager, moc = coreDataManager.managedObjectContext {
            (people,_) = Person.allObjects(moc)
        }
        self.tableView.reloadData()
    }

}
