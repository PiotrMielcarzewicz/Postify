//
//  Errors.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

enum PostifyError: Error {
    case missingURL
    case missingSnapshot
    case failedToFetchUser
    case invalidSessionToken
    case missingMetadata
    case missingImages
    case missingId
    
    var localizedDescription: String {
        switch self {
        case .failedToFetchUser:
            return LocalizedStrings.failedToFetchUser
        case .invalidSessionToken:
            return LocalizedStrings.invalidSessionToken
        case .missingMetadata:
            return LocalizedStrings.missingMetadata
        case .missingURL:
            return LocalizedStrings.missingURL
        case .missingImages:
            return LocalizedStrings.missingImages
        case .missingId:
            return LocalizedStrings.missingId
        case .missingSnapshot:
            return LocalizedStrings.missingSnapshot
        }
    }
}
