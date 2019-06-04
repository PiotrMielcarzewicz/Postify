//
//  Category.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 06/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

struct CategoryToken: Codable {
    let id: String
    let name: String
    let parentId: String?
    let type: AdvertisementType?
}

struct Category: Hashable {
    let id: String
    let name: String
    let parentId: String?
    let type: AdvertisementType
    
    init(token: CategoryToken) {
        self.id = token.id
        self.name = token.name
        self.parentId = token.parentId
        self.type = token.type ?? .other
    }
}
