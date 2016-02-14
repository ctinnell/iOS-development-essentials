//
//  PersonDataObject.swift
//  02-Swift-Multithreaded Core Data
//
//  Created by Clay Tinnell on 11/19/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import Foundation
import CoreData

extension Person {
    
    class func entityName() -> String {
        return "Person"
    }
    
    class func loadTestData(coreDataManager: CoreDataManager, completion:(()->())?) {
        guard let context = coreDataManager.managedObjectContext, privateContext = coreDataManager.privateManagedObjectContext else {
            print("Error obtaining contexts")
            return
        }
        
        let (results, fetchError) = allObjects(context)
        if let error = fetchError {
            print("Error with Fetch Request: \(error.description)")
        }
        else if results?.count == 0 {
            createPerson("Bill Gates", email: "billgates@microsoft.com", managedObjectContext: privateContext)
            createPerson("Jimmy John", email: "jimmyjohn@gmail.com", managedObjectContext: privateContext)
            createPerson("Clark Kent", email: "clarkkent@gmail.com", managedObjectContext: privateContext)
            createPerson("Luke Skywalker", email: "skywalker@gmail.com", managedObjectContext: privateContext)
            createPerson("Rocky Balboa", email: "rockyb@gmail.com", managedObjectContext: privateContext)
            createPerson("Yoda", email: "yoda@gmail.com", managedObjectContext: privateContext)
            createPerson("Jason Stephens", email: "jasonstephens@gmail.com", managedObjectContext: privateContext)
            createPerson("Luke Bryan", email: "lukebryan@gmail.com", managedObjectContext: privateContext)
            createPerson("Bryan Adams", email: "bryanadams@gmail.com", managedObjectContext: privateContext)
            createPerson("Jim Smith", email: "jimsmith@gmail.com", managedObjectContext: privateContext)
            createPerson("Dawn Day", email: "dawnday@gmail.com", managedObjectContext: privateContext)
            createPerson("Alana Coryn", email: "alanacoryn@gmail.com", managedObjectContext: privateContext)
            createPerson("Elizabeth Deluth", email: "elizabethdeluth@gmail.com", managedObjectContext: privateContext)
            createPerson("Brandon Cooker", email: "brandoncooker@gmail.com", managedObjectContext: privateContext)
           coreDataManager.save(completion)
        }
        else {
            print("data already loaded")
        }
    }
    
    class func createPerson(name: String, email: String, managedObjectContext: NSManagedObjectContext?) {
        guard let moc = managedObjectContext else { return }

        let person = NSEntityDescription.insertNewObjectForEntityForName(entityName(), inManagedObjectContext: moc) as! Person
        person.name = name
        person.email = email
    }
    
    class func allObjects(moc: NSManagedObjectContext) -> ([Person]?, NSError?) {
        let fetchRequest = NSFetchRequest(entityName: entityName())
        let entityDescription = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: moc)
        fetchRequest.entity = entityDescription
        do {
            let results = try moc.executeFetchRequest(fetchRequest) as? [Person]
            return (results!, nil)
        }
        catch let fetchError as NSError {
            print("Error fetching records: \(fetchError)")
            return([],fetchError)
        }
    }
    
    class func deleteAllObjects(coreDataManager: CoreDataManager, completion:(()->())?) -> NSError? {
        guard let privateContext = coreDataManager.privateManagedObjectContext else { return nil }
        
        let (objects, error) = allObjects(privateContext)
        if error == nil && objects?.count > 0 {
            for object in objects! {
                privateContext.deleteObject(object)
            }
            coreDataManager.save(completion)
        }
        else {
            if let completion = completion {
                completion()
            }
        }
        return error
    }

}
