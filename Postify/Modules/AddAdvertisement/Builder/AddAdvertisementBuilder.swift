//
//  AddAdvertisementBuilder.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 11/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

/// sourcery: Builder
protocol AddAdvertisementBuilder {
    func buildAddModule() -> UIViewController
    func buildEditModule(with advertisement: Advertisement) -> UIViewController
}

class AddAdvertisementBuilderImp: AddAdvertisementBuilder {
    private let appDependency: AppDependency
    
    init(appDependency: AppDependency) {
        self.appDependency = appDependency
    }
    
    func buildAddModule() -> UIViewController {
        let view = AddAdvertisementViewController()
        let interactor = AddAdvertisementInteractorImp(dependencies: appDependency)
        let router = AddAdvertisementRouterImp(viewController: view,
                                               builderProvider: appDependency)
        let presenter = AddAdvertisementPresenterImp(view: view,
                                                     interactor: interactor,
                                                     router: router,
                                                     validator: appDependency.validator,
                                                     mode: .add)
        view.presenter = presenter
        return view
    }
    
    func buildEditModule(with advertisement: Advertisement) -> UIViewController {
        let view = AddAdvertisementViewController()
        let interactor = AddAdvertisementInteractorImp(dependencies: appDependency)
        let router = AddAdvertisementRouterImp(viewController: view,
                                               builderProvider: appDependency)
        let presenter = AddAdvertisementPresenterImp(view: view,
                                                     interactor: interactor,
                                                     router: router,
                                                     validator: appDependency.validator,
                                                     mode: .edit(advertisement))
        view.presenter = presenter
        return view
    }
}
