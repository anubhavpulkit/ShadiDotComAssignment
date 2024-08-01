//
//  UserEntity.swift
//  ShadiDotComAssignment
//
//  Created by Anubhav Singh on 01/08/24.
//

import Foundation
import CoreData

public class UserEntity: NSManagedObject {
//    @NSManaged public var id: String?
//    @NSManaged public var status: String?
}

extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var status: String?

}

extension UserEntity : Identifiable {

}
