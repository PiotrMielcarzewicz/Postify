//
//  AdvertisementSortActions.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

enum AdvertisementSortAction {
    case dateDescending
    case dateAscending
    case lowToHigh
    case highToLow
    
    var title: String {
        switch self {
        case .dateDescending:
            return LocalizedStrings.dateDescending
        case .dateAscending:
            return LocalizedStrings.dateAscending
        case .lowToHigh:
            return LocalizedStrings.lowToHighPrice
        case .highToLow:
            return LocalizedStrings.highToLowPrice
        }
    }
}
