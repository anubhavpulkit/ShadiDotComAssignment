////
////  User.swift
////  ShadiDotComAssignment
////
////  Created by Anubhav Singh on 29/07/24.
////
//

import Foundation

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
    let phone: String
    let cell: String
    let idInfo: IDInfo
    let picture: Picture
    let nat: String
    var status: String?

    enum CodingKeys: String, CodingKey {
        case gender, name, location, email, login, dob, registered, phone, cell, picture, nat
        case idInfo = "id"
    }

    // Custom initializer to handle optional types or special cases
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .idInfo)
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
        self.status = nil // Or handle status if it is present in the JSON
    }
}

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
}

struct Picture: Decodable {
    let large: String?
    let medium: String
    let thumbnail: String?
}
