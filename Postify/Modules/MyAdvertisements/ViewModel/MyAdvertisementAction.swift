//
//  MyAdvertisementAction.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 12/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

enum MyAdvertisementAction {
    case edit
    case archive
    case unarchive
    case showDetails
    case close
    
    var title: String {
        switch self {
        case .edit:
            return LocalizedStrings.edit
        case .archive:
            return LocalizedStrings.archive
        case .unarchive:
            return LocalizedStrings.unarchive
        case .showDetails:
            return LocalizedStrings.showDetails
        case .close:
            return LocalizedStrings.close
        }
    }
}
