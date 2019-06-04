//
//  MyAdvertisementsBuilder.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 12/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

/// sourcery: Builder
protocol MyAdvertisementsBuilder {
    func buildModule() -> UIViewController
}

class MyAdvertisementsBuilderImp: MyAdvertisementsBuilder {
    private let appDependency: AppDependency
    
    init(appDependency: AppDependency) {
        self.appDependency = appDependency
    }
    
    func buildModule() -> UIViewController {
        let view = MyAdvertisementsViewController()
        let navigationController = UINavigationController(rootViewController: view)
        let interactor = MyAdvertisementsInteractorImp(dependencies: appDependency)
        let router = MyAdvertisementsRouterImp(viewController: view,
                                               builderProvider: appDependency)
        let presenter = MyAdvertisementsPresenterImp(view: view,
                                                     interactor: interactor,
                                                     router: router)
        view.presenter = presenter
        return navigationController
    }
}
