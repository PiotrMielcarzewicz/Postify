//
//  User.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 03/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let city: String
    let country: String
    let publicPhoneNumber: Bool
}
