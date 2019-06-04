//
//  MyProfileBuilder.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

/// sourcery: Builder
protocol MyProfileBuilder {
    func buildModule() -> UIViewController
}

struct MyProfileBuilderImp: MyProfileBuilder {
    private let appDependency: AppDependency
    
    init(appDependency: AppDependency) {
        self.appDependency = appDependency
    }
    
    func buildModule() -> UIViewController {
        let view = MyProfileViewController()
        let interactor = MyProfileInteractorImp(dependencies: appDependency)
        let presenter = MyProfilePresenterImp(view: view,
                                              interactor: interactor,
                                              validator: appDependency.validator)
        view.presenter = presenter
        return view
    }
}
