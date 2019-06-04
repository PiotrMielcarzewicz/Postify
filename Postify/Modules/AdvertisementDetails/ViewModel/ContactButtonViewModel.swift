//
//  ContactButtonViewModel.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

struct ContactButtonViewModel {
    let title: String
    let buttonText: String
    let target: Target
}

extension ContactButtonViewModel {
    enum Target {
        case phone(phoneNumber: String)
        case chat(advertisementId: String)
    }
}
