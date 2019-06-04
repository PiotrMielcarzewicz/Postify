//
//  SettingsRouter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol SettingsRouter {
    func presentResetPassword()
    func showMyProfile()
    func showLogin()
}

class SettingsRouterImp: DismissableRouter, SettingsRouter {
    func presentResetPassword() {
        let builder = builderProvider.getForgotPasswordBuilder()
        let view = builder.buildModule(shouldShowCloseButton: true)
        present(view)
    }
    
    func showMyProfile() {
        let builder = builderProvider.getMyProfileBuilder()
        let view = builder.buildModule()
        show(view)
    }
    
    func showLogin() {
        dismiss()
    }
}
