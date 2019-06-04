
//
//  ForgotPasswordBuilder.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

/// sourcery: Builder
protocol ForgotPasswordBuilder {
    func buildModule(shouldShowCloseButton: Bool) -> UIViewController
}

/// sourcery: Builder
protocol SettingsBuilder {
    func buildModule() -> UINavigationController
}

struct ForgotPasswordBuilderImp: ForgotPasswordBuilder {
    private let appDependency: AppDependency
    
    init(appDependency: AppDependency) {
        self.appDependency = appDependency
    }
    
    func buildModule(shouldShowCloseButton: Bool) -> UIViewController {
        if shouldShowCloseButton {
            return buildClosableModule()
        } else {
            return buildModule()
        }
    }
}

private extension ForgotPasswordBuilderImp {
    func buildModule() -> UIViewController {
        let view = ForgotPasswordViewController()
        let interactor = ForgotPasswordInteractorImp(dependencies: appDependency)
        let presenter = ForgotPasswordPresenterImp(view: view,
                                                   interactor: interactor,
                                                   router: nil,
                                                   validator: appDependency.validator,
                                                   shouldShowCloseButton: false)
        view.presenter = presenter
        return view
    }
    
    func buildClosableModule() -> UIViewController {
        let view = ForgotPasswordViewController()
        let interactor = ForgotPasswordInteractorImp(dependencies: appDependency)
        let navigationController = UINavigationController(rootViewController: view)
        let router: DismissableRouter? = DismissableRouter(viewController: navigationController,
                                                           builderProvider: appDependency)
        let presenter = ForgotPasswordPresenterImp(view: view,
                                                   interactor: interactor,
                                                   router: router,
                                                   validator: appDependency.validator,
                                                   shouldShowCloseButton: true)
        view.presenter = presenter
        return navigationController
    }
}
