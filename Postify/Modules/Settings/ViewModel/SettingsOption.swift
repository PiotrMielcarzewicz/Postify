//
//  SettingsOption.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 03/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

enum SettingsOption {
    case myProfile
    case resetPassword
    case phoneVisibility(Bool)
    case logout
    
    var title: String {
        switch self {
        case .myProfile:
            return LocalizedStrings.myProfile
        case .resetPassword:
            return LocalizedStrings.resetPassword
        case .phoneVisibility:
            return LocalizedStrings.shouldDisplayPhone
        case .logout:
            return LocalizedStrings.logout
        }
    }
    
    var icon: UIImage {
        switch self {
        case .myProfile:
            return #imageLiteral(resourceName: "ic_my_profile")
        case .resetPassword:
            return #imageLiteral(resourceName: "ic_password")
        case .phoneVisibility:
            return #imageLiteral(resourceName: "ic_phone")
        case .logout:
            return #imageLiteral(resourceName: "ic_logout")
        }
    }
}
