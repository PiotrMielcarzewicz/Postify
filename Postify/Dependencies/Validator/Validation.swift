//
//  Validation.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

enum Validation {
    case phoneNumber
    case email
    
    var regexString: String {
        switch self {
        case .phoneNumber:
            return "^[0-9\\+]{9,15}$"
        case .email:
            return "^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$"
        }
    }
}
