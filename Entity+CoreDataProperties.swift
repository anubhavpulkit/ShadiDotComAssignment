//
//  Entity+CoreDataProperties.swift
//  ShadiDotComAssignment
//
//  Created by Anubhav Singh on 31/07/24.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var id: String?
    @NSManaged public var status: String?

}

extension Entity : Identifiable {

}
