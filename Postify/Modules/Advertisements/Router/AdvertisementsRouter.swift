//
//  AdvertisementsRouter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol AdvertisementsRouter {
    func presentFilterView(completion: @escaping (CategoryViewModel) -> ())
    func showAdvertisementDetailsView(of advertisement: Advertisement)
}

class AdvertisementsRouterImp: Router, AdvertisementsRouter {
    func presentFilterView(completion: @escaping (CategoryViewModel) -> ()) {
        let builder = builderProvider.getCategorySelectorBuilder()
        let view = builder.buildSortModule(onCategorySelect: completion)
        present(view)
    }
    
    func showAdvertisementDetailsView(of advertisement: Advertisement) {
        let builder = builderProvider.getAdvertisementDetailsBuilder()
        let view = builder.buildModule(with: advertisement)
        show(view)
    }
}
