//
//  SignUpBuilder.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

/// sourcery: Builder
protocol SignUpBuilder {
    func buildModule() -> UIViewController
}

struct SignUpBuilderImp: SignUpBuilder {
    private let appDependency: AppDependency
    
    init(appDependency: AppDependency) {
        self.appDependency = appDependency
    }
    
    func buildModule() -> UIViewController {
        let view = SignUpViewController()
        let interactor = SignUpInteractorImp(dependencies: appDependency)
        let presenter = SignUpPresenterImp(view: view,
                                           interactor: interactor,
                                           validator: appDependency.validator)
        view.presenter = presenter
        return view
    }
}
