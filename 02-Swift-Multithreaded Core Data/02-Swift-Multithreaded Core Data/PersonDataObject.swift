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
    
    class func loadTestData(managedObjectContext: NSManagedObjectContext?) {
        if let moc = managedObjectContext {
            let (results, fetchError) = allObjects(moc)
            if let error = fetchError {
                print("Error with Fetch Request: \(error.description)")
            }
            else if results.count == 0 {
                createPerson("Bill Gates", email: "billgates@microsoft.com", managedObjectContext: moc)
                createPerson("Tim Cook", email: "timcook@apple.com", managedObjectContext: moc)
            }
            else {
                print("data already loaded")
            }
        }
    }
    
    class func createPerson(name: String, email: String, managedObjectContext: NSManagedObjectContext?) {
        if let moc = managedObjectContext {
            let person = NSEntityDescription.insertNewObjectForEntityForName(entityName(), inManagedObjectContext: moc) as! Person

            person.name = name
            person.email = email
            
            do {
                try moc.save()
            }
            catch let saveError as NSError {
                print("Error with managed object context: \(saveError)")
                return
            }
        }
    }
    
    class func allObjects(moc: NSManagedObjectContext) -> ([Person], NSError?) {
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
    
    class func deleteAllObjects(moc: NSManagedObjectContext) -> NSError? {
        let (objects, error) = allObjects(moc)
        if error == nil && objects.count > 0 {
            for object in objects {
                moc.deleteObject(object)
            }
            do {
                try moc.save()
            }
            catch let saveError as NSError {
                print("Error with managed object context: \(saveError)")
                return saveError
            }
        }
        return error
    }
}
