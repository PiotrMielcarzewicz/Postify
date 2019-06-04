//
//  AdvertisementDetailsRouter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol AdvertisementDetailsRouter {
    func goBack()
    func switchConversationsTab()
}

class AdvertisementDetailsRouterImp: Router, AdvertisementDetailsRouter {
    func goBack() {
        tryPopViewController()
    }
    
    func switchConversationsTab() {
        viewController.tabBarController?.selectedIndex = 2
    }
}
