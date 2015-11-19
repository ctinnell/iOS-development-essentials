//
//  Person+CoreDataProperties.swift
//  02-Swift-Multithreaded Core Data
//
//  Created by Clay Tinnell on 11/19/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var email: String?

}
