//
//  UIViewController+LoadingIndicator.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

protocol ProgressShowable: class {
    func showLoadingHUD()
    func hideLoadingHUD()
}

extension UIViewController: ProgressShowable {    
    func showLoadingHUD() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        HUDHolder.shared.hud = JGProgressHUD(style: .dark)
        HUDHolder.shared.hud?.textLabel.text = LocalizedStrings.loading
        HUDHolder.shared.hud?.parallaxMode = .alwaysOff
        HUDHolder.shared.hud?.position = .center
        if let view = self.navigationController?.view {
            HUDHolder.shared.hud?.show(in: view)
        } else {
            HUDHolder.shared.hud?.show(in: self.view)
        }
    }
    
    func hideLoadingHUD() {
        UIApplication.shared.endIgnoringInteractionEvents()
        HUDHolder.shared.hud?.dismiss(animated: true)
        HUDHolder.shared.hud = nil
    }
}
