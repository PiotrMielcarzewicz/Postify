//
//  TabBarBuilder.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 02/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

/// sourcery: Builder
protocol TabBarBuilder {
    func buildModule() -> UIViewController
}

struct TabBarBuilderImp: TabBarBuilder {
    private let appDependency: AppDependency
    
    init(appDependency: AppDependency) {
        self.appDependency = appDependency
    }
    
    func buildModule() -> UIViewController {
        let tabBarController = UITabBarController()
        style(tabBarController: tabBarController)
        let viewControllers = [advertisementsView(),
                               myAdvertisementsView(),
                               conversationsView(),
                               settingsView()]
        tabBarController.viewControllers = viewControllers
        applyInsetsToTabBarItems(in: tabBarController)
        return tabBarController
    }
}

private extension TabBarBuilderImp {
    func style(tabBarController: UITabBarController) {
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.barTintColor = .pst_x64112B
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        tabBarController.tabBar.isTranslucent = false
    }
    
    func applyInsetsToTabBarItems(in controller: UITabBarController) {
        for item in controller.tabBar.items! {
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
}

private extension TabBarBuilderImp {
    func advertisementsView() -> UIViewController {
        let builder = appDependency.getAdvertisementsBuilder()
        let view = builder.buildModule()
        view.tabBarItem.image = #imageLiteral(resourceName: "ic_news")
        return view
    }
    
    func myAdvertisementsView() -> UIViewController {
        let builder = appDependency.getMyAdvertisementsBuilder()
        let view = builder.buildModule()
        view.tabBarItem.image = #imageLiteral(resourceName: "ic_pencil")
        return view
    }
    
    func conversationsView() -> UIViewController {
        let builder = appDependency.getConversationsBuilder()
        let view = builder.buildModule()
        view.tabBarItem.image = #imageLiteral(resourceName: "ic_chat")
        return view
    }
    
    func settingsView() -> UIViewController {
        let builder = appDependency.getSettingsBuilder()
        let view = builder.buildModule()
        view.tabBarItem.image = #imageLiteral(resourceName: "ic_settings")
        return view
    }
}
