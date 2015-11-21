//
//  CoreDataManager.swift
//  CoreDataModel
//
//  Created by Clay Tinnell on 2/23/15.
//  Copyright (c) 2015 Clay Tinnell. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataManager {

    public var managedObjectModel: NSManagedObjectModel?
    public var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    public var managedObjectContext: NSManagedObjectContext?
    public var privateManagedObjectContext: NSManagedObjectContext?
    
    private let modelName = "CoreDataModel"

    public init(completion: (()->())?) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            self.managedObjectModel = self.initializeManagedObjectModel()
            self.persistentStoreCoordinator = self.initializePersistentStoreCoordinator()
            self.managedObjectContext = self.initializeManagedObjectContext()
            self.privateManagedObjectContext = self.initializePrivateManagedObjectContext()
            if let completion = completion {
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    completion()
                })
            }
        }
    }
    
    public func save(completion: (()->())?) {
        if let privateManagedObjectContext = privateManagedObjectContext, managedObjectContext = managedObjectContext {
            if privateManagedObjectContext.hasChanges || managedObjectContext.hasChanges {
                managedObjectContext.performBlockAndWait({ () -> Void in
                    do {
                        try managedObjectContext.save()
                    }
                    catch let saveError as NSError {
                        print("Error with managed object context: \(saveError)")
                        return
                    }
                })
                
                privateManagedObjectContext.performBlock({ () -> Void in
                    do {
                        try privateManagedObjectContext.save()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if let completion = completion {
                                completion()
                            }
                        })
                    }
                    catch let asynchSaveError as NSError {
                        print("Error with managed object context: \(asynchSaveError)")
                        return
                    }
                    
                })
            }
        }
    }
    
    private func initializeManagedObjectModel() -> NSManagedObjectModel? {
        var model: NSManagedObjectModel?
        if let modelURL = NSBundle.mainBundle().URLForResource(modelName, withExtension: "momd") {
            model = NSManagedObjectModel(contentsOfURL: modelURL)
        }
        return model
    }
    
    private func initializePersistentStoreCoordinator() -> NSPersistentStoreCoordinator? {
        let url = NSURL.fileURLWithPath((self.applicationDocumentsDirectory() as NSString).stringByAppendingPathComponent("\(modelName).sqlite"))
        let options = [NSMigratePersistentStoresAutomaticallyOption:1, NSInferMappingModelAutomaticallyOption:1]
        var storeCoordinator: NSPersistentStoreCoordinator?
        
        if let mom = managedObjectModel {
            storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
            do {
                try storeCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
            }
            catch let persistentStoreError as NSError {
                print("Unable to add Persistent Store!!!")
                print("\(persistentStoreError)")
                return nil
            }
        }
        else {
            print("Unable to create Persistent Store Coordator - managed object context is nil!!!")
        }
        
        //encrypt data store
        let fileAttributes = [NSFileProtectionKey:NSFileProtectionComplete]
        if let urlPath = url.path {
            do {
                try NSFileManager.defaultManager().setAttributes(fileAttributes, ofItemAtPath: urlPath)
            }
            catch let error as NSError {
                print("Unable to encrypt database: \(error): \(error.userInfo)")
                return nil
            }
        }
        return storeCoordinator
    }
    
    private func initializeManagedObjectContext() -> NSManagedObjectContext {
        let objectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        objectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return objectContext
    }
    
    private func initializePrivateManagedObjectContext() -> NSManagedObjectContext {
        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return privateContext
    }
    
    private func applicationDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        return paths[paths.count - 1]
    }
}
