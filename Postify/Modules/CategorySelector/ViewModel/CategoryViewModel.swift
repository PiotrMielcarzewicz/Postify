//
//  CategoryViewModel.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 10/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

struct CategoryViewModel {
    let id: String
    let name: String
    let type: Type
    let metadataType: AdvertisementType
}

extension CategoryViewModel {
    enum `Type` {
        case node
        case leaf
    }
}
