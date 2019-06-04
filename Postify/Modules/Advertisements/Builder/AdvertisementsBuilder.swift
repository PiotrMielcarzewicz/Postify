//
//  AdvertisementsBuilder.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

/// sourcery: Builder
protocol AdvertisementsBuilder {
    func buildModule() -> UIViewController
}

class AdvertisementsBuilderImp: AdvertisementsBuilder {
    private let appDependency: AppDependency
    
    init(appDependency: AppDependency) {
        self.appDependency = appDependency
    }
    
    func buildModule() -> UIViewController {
        let view = AdvertisementsViewController()
        let navigationController = UINavigationController(rootViewController: view)
        let interactor = AdvertisementsInteractorImp(dependencies: appDependency)
        let router = AdvertisementsRouterImp(viewController: view,
                                               builderProvider: appDependency)
        let presenter = AdvertisementsPresenterImp(view: view,
                                                   interactor: interactor,
                                                   router: router)
        view.presenter = presenter
        return navigationController
    }
}
