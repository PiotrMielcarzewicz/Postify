//
//  AdvertisementDetailsBuilder.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

/// sourcery: Builder
protocol AdvertisementDetailsBuilder {
    func buildModule(with advertisement: Advertisement) -> UIViewController
}

class AdvertisementDetailsBuilderImp: AdvertisementDetailsBuilder {
    private let appDependency: AppDependency
    
    init(appDependency: AppDependency) {
        self.appDependency = appDependency
    }
    
    func buildModule(with advertisement: Advertisement) -> UIViewController {
        let view = AdvertisementDetailsViewController()
        let router = AdvertisementDetailsRouterImp(viewController: view,
                                                   builderProvider: appDependency)
        let interactor = AdvertisementDetailsInteractorImp(dependencies: appDependency)
        let presenter = AdvertisementDetailsPresenterImp(view: view,
                                                         interactor: interactor,
                                                         router: router,
                                                         advertisement: advertisement,
                                                         dateFormatter: appDependency.appDateFormatter)
        view.presenter = presenter
        return view
    }
}
