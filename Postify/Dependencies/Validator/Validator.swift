//
//  Validator.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

/// sourcery: AutoDependency
protocol Validator {
    func validateNonEmpty(_ text: String?) -> Bool
    func validate(_ text: String, type: Validation) -> Bool
    func validateAdvertisementDetails(_ detailedInfo: AdvertisementDetailedInfo) -> Bool
}

class ValidatorImp: Validator {
    func validateNonEmpty(_ text: String?) -> Bool {
        if let text = text, !text.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func validate(_ text: String, type: Validation) -> Bool {
        let toMatch = text.filter({ false == CharacterSet.whitespaces.contains($0.unicodeScalars.first!) })
        return toMatch.range(of: type.regexString, options: .regularExpression) != nil
    }
    
    func validateAdvertisementDetails(_ detailedInfo: AdvertisementDetailedInfo) -> Bool {
        switch detailedInfo {
        case let .vinyl(vinyl):
            return validateVinyl(vinyl)
        case .none:
            return true
        }
    }
}

private extension ValidatorImp {
    func validateVinyl(_ vinyl: Vinyl) -> Bool {
        return validateNonEmpty(vinyl.album) &&
               validateNonEmpty(vinyl.author)
    }
}
