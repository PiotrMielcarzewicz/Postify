//
//  AddAdvertisementRouter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 11/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol AddAdvertisementRouter {
    func goBack()
    func presentCategorySelector(completion: @escaping (CategoryViewModel) -> ())
}

class AddAdvertisementRouterImp: Router, AddAdvertisementRouter {
    func goBack() {
        tryPopViewController()
    }
    
    func presentCategorySelector(completion: @escaping (CategoryViewModel) -> ()) {
        let builder = builderProvider.getCategorySelectorBuilder()
        let view = builder.buildModule(onCategorySelect: completion)
        present(view)
    }
}
