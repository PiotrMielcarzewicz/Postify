//
//  SignInRouter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol SignInRouter {
    func showHomeView()
    func showForgotPassword()
    func showSignUp()
}

class SignInRouterImp: Router, SignInRouter {
    func showHomeView() {
        let builder = builderProvider.getTabBarBuilder()
        let view = builder.buildModule()
        present(view)
    }
    
    func showForgotPassword() {
        let builder = builderProvider.getForgotPasswordBuilder()
        let view = builder.buildModule(shouldShowCloseButton: false)
        show(view)
    }
    
    func showSignUp() {
        let builder = builderProvider.getSignUpBuilder()
        let view = builder.buildModule()
        show(view)
    }
}
