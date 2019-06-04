//
//  SignInBuilder.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

/// sourcery: Builder
protocol SignInBuilder {
    func buildModule() -> UIViewController
}

struct SignInBuilderImp: SignInBuilder {
    private let appDependency: AppDependency
    
    init(appDependency: AppDependency) {
        self.appDependency = appDependency
    }
    
    func buildModule() -> UIViewController {
        let view = SignInViewController()
        let interactor = SignInInteractorImp(dependencies: appDependency)
        let router = SignInRouterImp(viewController: view, builderProvider: appDependency)
        let presenter = SignInPresenterImp(view: view,
                                           interactor: interactor,
                                           router: router,
                                           validator: appDependency.validator)
        view.presenter = presenter
        return UINavigationController(rootViewController: view)
    }
}
