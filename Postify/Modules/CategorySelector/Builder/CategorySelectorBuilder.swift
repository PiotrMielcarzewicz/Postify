//
//  CategorySelectorBuilder.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 10/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

/// sourcery: Builder
protocol CategorySelectorBuilder {
    func buildModule(onCategorySelect: @escaping (CategoryViewModel) -> ()) -> UIViewController
    func buildModule(parentViewModel: CategoryViewModel, onCategorySelect: @escaping (CategoryViewModel) -> ()) -> UIViewController
    func buildSortModule(onCategorySelect: @escaping (CategoryViewModel) -> ()) -> UIViewController
}

class CategorySelectorBuilderImp: CategorySelectorBuilder {
    private let appDependency: AppDependency
    
    init(appDependency: AppDependency) {
        self.appDependency = appDependency
    }
    
    func buildModule(onCategorySelect: @escaping (CategoryViewModel) -> ()) -> UIViewController {
        let view = CategorySelectorViewController()
        let interactor = CategorySelectorInteractorImp(dependencies: appDependency,
                                                       dataSource: .firebase)
        let router = CategorySelectorRouterImp(viewController: view,
                                               builderProvider: appDependency)
        let presenter = CategorySelectorPresenterImp(view: view,
                                                     interactor: interactor,
                                                     router: router,
                                                     onCategorySelect: onCategorySelect,
                                                     customTitle: nil,
                                                     shouldIncludeAllButton: false)
        view.presenter = presenter
        return UINavigationController(rootViewController: view)
    }
    
    func buildModule(parentViewModel: CategoryViewModel, onCategorySelect: @escaping (CategoryViewModel) -> ()) -> UIViewController {
        let view = CategorySelectorViewController()
        let interactor = CategorySelectorInteractorImp(dependencies: appDependency,
                                                       dataSource: .cache(parentId: parentViewModel.id))
        let router = CategorySelectorRouterImp(viewController: view,
                                               builderProvider: appDependency)
        let presenter = CategorySelectorPresenterImp(view: view,
                                                     interactor: interactor,
                                                     router: router,
                                                     onCategorySelect: onCategorySelect,
                                                     customTitle: parentViewModel.name,
                                                     shouldIncludeAllButton: false)
        view.presenter = presenter
        return view
    }
    
    func buildSortModule(onCategorySelect: @escaping (CategoryViewModel) -> ()) -> UIViewController {
        let view = CategorySelectorViewController()
        let interactor = CategorySelectorInteractorImp(dependencies: appDependency,
                                                       dataSource: .firebase)
        let router = CategorySelectorRouterImp(viewController: view,
                                               builderProvider: appDependency)
        let presenter = CategorySelectorPresenterImp(view: view,
                                                     interactor: interactor,
                                                     router: router,
                                                     onCategorySelect: onCategorySelect,
                                                     customTitle: nil,
                                                     shouldIncludeAllButton: true)
        view.presenter = presenter
        return UINavigationController(rootViewController: view)
    }
}
