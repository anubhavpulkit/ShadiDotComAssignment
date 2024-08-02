////
////  User.swift
////  ShadiDotComAssignment
////
////  Created by Anubhav Singh on 29/07/24.
////
//

import Foundation
import CoreData

struct UserResponse: Decodable {
    let results: [User]
}

struct User: Decodable, Identifiable {
    let id: String
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob: DateOfBirth
    let registered: Registered
    var phone: String
    let cell: String
    let idInfo: IDInfo
    let picture: Picture
    let nat: String
    var status: String?
    var pictureLarge: String? // New field
    var nameFirst: String?    // New field
    var dobAge: Int16?        // New field
    var phoneNum: String? // New field

    enum CodingKeys: String, CodingKey {
        case gender, name, location, email, login, dob, registered, phone, cell, picture, nat, status
        case idInfo = "id"
    }

    // Custom initializer to handle optional types or special cases
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idInfoContainer = try container.nestedContainer(keyedBy: IDInfo.CodingKeys.self, forKey: .idInfo)
        self.id = try idInfoContainer.decodeIfPresent(String.self, forKey: .value) ?? UUID().uuidString
        self.gender = try container.decode(String.self, forKey: .gender)
        self.name = try container.decode(Name.self, forKey: .name)
        self.location = try container.decode(Location.self, forKey: .location)
        self.email = try container.decode(String.self, forKey: .email)
        self.login = try container.decode(Login.self, forKey: .login)
        self.dob = try container.decode(DateOfBirth.self, forKey: .dob)
        self.registered = try container.decode(Registered.self, forKey: .registered)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.cell = try container.decode(String.self, forKey: .cell)
        self.idInfo = try container.decode(IDInfo.self, forKey: .idInfo)
        self.picture = try container.decode(Picture.self, forKey: .picture)
        self.nat = try container.decode(String.self, forKey: .nat)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        
        // No coding keys for these; set as nil by default
        self.pictureLarge = nil
        self.nameFirst = nil
        self.dobAge = nil
        self.phoneNum = nil
    }
}

// Extension to initialize User from UserEntity (Core Data)
extension User {
    init(from entity: UserEntity) {
        self.id = entity.id ?? UUID().uuidString
        self.gender = entity.gender ?? "" // Default or optional
        self.name = Name(title: "", first: entity.nameFirst ?? "", last: "")
        self.location = Location(
            street: Street(number: 0, name: ""),
            city: "",
            state: "",
            country: "",
            postcode: .string(""),
            coordinates: Coordinates(latitude: "", longitude: ""),
            timezone: Timezone(offset: "", description: "")
        )
        self.email = "" // Default or optional
        self.login = Login(uuid: "", username: "", password: "", salt: "", md5: "", sha1: "", sha256: "")
        self.dob = DateOfBirth(date: "", age: Int(entity.dobAge))
        self.registered = Registered(date: "", age: 0)
        self.phone = "" // From JSON data, not Core Data
        self.cell = "" // Default or optional
        self.idInfo = IDInfo(name: "", value: nil)
        self.picture = Picture(large: nil, medium: "", thumbnail: nil)
        self.nat = "" // Default or optional
        
        // Values from Core Data
        self.status = entity.status
        self.pictureLarge = entity.pictureLarge
        self.nameFirst = entity.nameFirst
        self.dobAge = entity.dobAge
        self.phone = entity.phoneNum
    }
}

// Decodable supporting types
struct Name: Decodable {
    let title: String
    let first: String
    let last: String
}

struct Location: Decodable {
    let street: Street
    let city: String
    let state: String
    let country: String
    let postcode: Postcode
    let coordinates: Coordinates
    let timezone: Timezone
}

struct Street: Decodable {
    let number: Int
    let name: String
}

enum Postcode: Decodable {
    case int(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(Postcode.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Postcode value cannot be decoded"))
        }
    }
}

struct Coordinates: Decodable {
    let latitude: String
    let longitude: String
}

struct Timezone: Decodable {
    let offset: String
    let description: String
}

struct Login: Decodable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}

struct DateOfBirth: Decodable {
    let date: String
    let age: Int
}

struct Registered: Decodable {
    let date: String
    let age: Int
}

struct IDInfo: Decodable {
    let name: String
    let value: String?

    enum CodingKeys: String, CodingKey {
        case name, value
    }
}

struct Picture: Decodable {
    let large: String?
    let medium: String
    let thumbnail: String?
}
