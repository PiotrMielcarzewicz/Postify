//
//  ChatRouter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol ChatRouter {
    func showAdvertisementDetailsView(of advertisement: Advertisement)
    func goBack()
}

class ChatRouterImp: Router, ChatRouter {
    func showAdvertisementDetailsView(of advertisement: Advertisement) {
        let builder = builderProvider.getAdvertisementDetailsBuilder()
        let view = builder.buildModule(with: advertisement)
        show(view)
    }
    
    func goBack() {
        tryPopViewController()
    }
}
