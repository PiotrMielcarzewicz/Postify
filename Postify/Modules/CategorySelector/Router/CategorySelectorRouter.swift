//
//  CategorySelectorRouter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 10/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol CategorySelectorRouter {
    func dismissView()
    func showSubcategories(parentViewModel: CategoryViewModel, onCategorySelect: @escaping (CategoryViewModel) -> ())
}

class CategorySelectorRouterImp: DismissableRouter, CategorySelectorRouter {
    func dismissView() {
        dismiss()
    }
    
    func showSubcategories(parentViewModel: CategoryViewModel, onCategorySelect: @escaping (CategoryViewModel) -> ()) {
        let builder = builderProvider.getCategorySelectorBuilder()
        let view = builder.buildModule(parentViewModel: parentViewModel, onCategorySelect: onCategorySelect)
        show(view)
    }
}
