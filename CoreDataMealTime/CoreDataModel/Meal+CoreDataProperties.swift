//
//  Meal+CoreDataProperties.swift
//  CoreDataMealTime
//
//  Created by Admin on 11.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var date: Date?
    @NSManaged public var person: Person?

}
