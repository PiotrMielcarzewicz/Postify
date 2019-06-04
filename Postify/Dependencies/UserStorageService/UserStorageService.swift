//
//  UserStorageService.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 03/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import KeychainAccess

protocol UserStorageService {
    func getUser() -> User?
    func saveUser(_ user: User)
    func clearUser()
}

class UserStorageServiceImp: UserStorageService {
    private let keychain = Keychain.init(service: "com.pm.postify.userKeychain")
    
    func getUser() -> User? {
        guard let id = getValue(.id),
              let email = getValue(.email),
              let firstName = getValue(.firstName),
              let lastName = getValue(.lastName),
              let phoneNumber = getValue(.phoneNumber),
              let city = getValue(.city),
              let country = getValue(.country),
              let publicPhoneNumber = getBoolValue(.publicPhoneNumber) else { return nil }
        
        return User(id: id,
                    email: email,
                    firstName: firstName,
                    lastName: lastName,
                    phoneNumber: phoneNumber,
                    city: city,
                    country: country,
                    publicPhoneNumber: publicPhoneNumber)
    }
    
    func saveUser(_ user: User) {
        saveValue(user.id, forKey: .id)
        saveValue(user.email, forKey: .email)
        saveValue(user.firstName, forKey: .firstName)
        saveValue(user.lastName, forKey: .lastName)
        saveValue(user.phoneNumber, forKey: .phoneNumber)
        saveValue(user.city, forKey: .city)
        saveValue(user.country, forKey: .country)
        saveBoolValue(user.publicPhoneNumber, forKey: .publicPhoneNumber)
    }
    
    func clearUser() {
        saveValue(nil, forKey: .id)
        saveValue(nil, forKey: .email)
        saveValue(nil, forKey: .firstName)
        saveValue(nil, forKey: .lastName)
        saveValue(nil, forKey: .phoneNumber)
        saveValue(nil, forKey: .city)
        saveValue(nil, forKey: .country)
        saveValue(nil, forKey: .publicPhoneNumber)
    }
}

private extension UserStorageServiceImp {
    enum Key: String {
        case id
        case email
        case firstName
        case lastName
        case phoneNumber
        case city
        case country
        case publicPhoneNumber
    }
    
    func getValue(_ key: Key) -> String? {
        return keychain[key.rawValue]
    }
    
    func getBoolValue(_ key: Key) -> Bool? {
        if let value = keychain[key.rawValue] {
            return value == "yes"
        } else {
            return nil
        }
    }
    
    func saveBoolValue(_ value: Bool?, forKey key: Key) {
        if let value = value {
            if value == true {
                keychain[key.rawValue] = "yes"
            } else {
                keychain[key.rawValue] = "no"
            }
        } else {
            keychain[key.rawValue] = nil
        }
    }
    
    func saveValue(_ value: String?, forKey key: Key) {
        keychain[key.rawValue] = value
    }
}
