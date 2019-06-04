//
//  UIViewController+Alerts.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 22/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import NotificationBannerSwift
import UIKit

protocol AlertShowable: class {
    func showAlert(_ alert: Alert)
    func showAlert(for error: Error)
}

extension UIViewController: AlertShowable {
    func showAlert(_ alert: Alert) {
        let (title, subtitle, style) = alert.metadata
        let banner = NotificationBanner(title: title,
                                        subtitle: subtitle,
                                        leftView: nil,
                                        rightView: nil,
                                        style: style,
                                        colors: nil)
        banner.show()
    }
    
    func showAlert(for error: Error) {
        let subtitle: String = {
            if let postifyError = error as? PostifyError {
                return postifyError.localizedDescription
            } else {
                return error.localizedDescription
            }
        }()
        let alert: Alert = .custom(title: LocalizedStrings.errorCapitalized,
                                   subtitle: subtitle,
                                   style: .warning)
        showAlert(alert)
    }
}

enum Alert {
    case wrongCredentials
    case emptyFields
    case accountCreated
    case resetEmailSent
    case mismatchedPasswords
    case userFetchFailed
    case invalidPhoneNumber
    case updatedUserData
    case didCreateAdvertisement
    case didEditAdvertisement
    case failedToProcessAdvertisement
    case advertisementIsArchived
    case custom(title: String, subtitle: String, style: BannerStyle)
    
    var metadata: (String, String, BannerStyle) {
        switch self {
        case .accountCreated:
            return (LocalizedStrings.successCapitalized,
                    LocalizedStrings.accountCreated,
                    .success)
        case .resetEmailSent:
            return (LocalizedStrings.successCapitalized,
                    LocalizedStrings.resetEmailSent,
                    .success)
        case .mismatchedPasswords:
            return (LocalizedStrings.errorCapitalized,
                    LocalizedStrings.mismatchedPasswords,
                    .warning)
        case .emptyFields:
            return (LocalizedStrings.emptyFieldsTitle,
                    LocalizedStrings.emptyFieldsSubtitle,
                    .warning)
        case .wrongCredentials:
            return (LocalizedStrings.wrongCredentialsTitle,
                    LocalizedStrings.wrongCredentialsSubtitle,
                    .warning)
        case .userFetchFailed:
            return (LocalizedStrings.errorCapitalized,
                    LocalizedStrings.failedToFetchUser,
                    .danger)
        case .invalidPhoneNumber:
            return (LocalizedStrings.errorCapitalized,
                    LocalizedStrings.invalidPhoneNumber,
                    .danger)
        case .updatedUserData:
            return (LocalizedStrings.successCapitalized,
                    LocalizedStrings.updatedUserData,
                    .success)
        case .didCreateAdvertisement:
            return (LocalizedStrings.successCapitalized,
                    LocalizedStrings.didCreateAdvertisement,
                    .success)
        case .didEditAdvertisement:
            return (LocalizedStrings.successCapitalized,
                    LocalizedStrings.didEditAdvertisement,
                    .success)
        case .failedToProcessAdvertisement:
            return (LocalizedStrings.errorCapitalized,
                    LocalizedStrings.failedToProcessAdvertisement,
                    .danger)
        case .advertisementIsArchived:
            return (LocalizedStrings.errorCapitalized,
                    LocalizedStrings.advertisementIsArchived,
                    .warning)
        case let .custom(title: title, subtitle: subtitle, style: style):
            return (title, subtitle, style)
        }
    }
}
