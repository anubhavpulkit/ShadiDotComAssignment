//
//  UserEntity.swift
//  ShadiDotComAssignment
//
//  Created by Anubhav Singh on 01/08/24.
//

import Foundation
import CoreData

public class UserEntity: NSManagedObject {
}

extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var status: String?
    @NSManaged public var pictureLarge: String?
    @NSManaged public var gender: String?
    @NSManaged public var nameFirst: String?
    @NSManaged public var dobAge: Int16
    @NSManaged public var phoneNum: String
}

extension UserEntity: Identifiable {
}
