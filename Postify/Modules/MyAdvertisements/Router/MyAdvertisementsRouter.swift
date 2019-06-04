//
//  MyAdvertisementsRouter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 12/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol MyAdvertisementsRouter {
    func showAdvertisementDetailsView(of advertisement: Advertisement)
    func showEditAdvertisementView(of advertisement: Advertisement)
    func showAddAdvertisementView()
}

class MyAdvertisementsRouterImp: Router, MyAdvertisementsRouter {
    func showAdvertisementDetailsView(of advertisement: Advertisement) {
        let builder = builderProvider.getAdvertisementDetailsBuilder()
        let view = builder.buildModule(with: advertisement)
        show(view)
    }
    
    func showEditAdvertisementView(of advertisement: Advertisement) {
        let builder = builderProvider.getAddAdvertisementBuilder()
        let view = builder.buildEditModule(with: advertisement)
        show(view)
    }
    
    func showAddAdvertisementView() {
        let builder = builderProvider.getAddAdvertisementBuilder()
        let view = builder.buildAddModule()
        show(view)
    }
}
