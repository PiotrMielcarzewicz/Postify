//
//  ConversationsBuilder.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

/// sourcery: Builder
protocol ConversationsBuilder {
    func buildModule() -> UIViewController
}

class ConversationsBuilderImp: ConversationsBuilder {
    private let appDependency: AppDependency
    
    init(appDependency: AppDependency) {
        self.appDependency = appDependency
    }
    
    func buildModule() -> UIViewController {
        let view = ConversationsViewController()
        let router = ConversationsRouterImp(viewController: view,
                                            builderProvider: appDependency)
        let interactor = ConversationsInteractorImp(dependencies: appDependency)
        let presenter = ConversationsPresenterImp(view: view,
                                                  interactor: interactor,
                                                  router: router,
                                                  dateFormatter: appDependency.appDateFormatter)
        view.presenter = presenter
        return UINavigationController(rootViewController: view)
    }
}
