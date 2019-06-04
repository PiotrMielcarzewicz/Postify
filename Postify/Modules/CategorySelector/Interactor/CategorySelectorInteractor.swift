//
//  CategorySelectorInteractor.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 10/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol CategorySelectorInteractor {
    func getCategories(completion: @escaping Completion<[CategoryViewModel]>)
}

class CategorySelectorInteractorImp: CategorySelectorInteractor {
    typealias Dependencies = HasCategoryService
    private let dependencies: Dependencies
    private let dataSource: CategoryDataSource
    
    init(dependencies: Dependencies, dataSource: CategoryDataSource) {
        self.dependencies = dependencies
        self.dataSource = dataSource
    }
    
    func getCategories(completion: @escaping Completion<[CategoryViewModel]>) {
        switch dataSource {
        case let .cache(parentId: id):
            let categories = dependencies.categoryService.cache
            let subcategories = categories.filter { $0.parentId == id }
            wrapViewModels(allCategories: categories,
                           wrapCategories: subcategories,
                           completion: completion)
        case .firebase:
            dependencies.categoryService.getCategories { [weak self] result in
                switch result {
                case let .success(categories):
                    let mainCategories = categories.filter { $0.parentId == nil }
                    self?.wrapViewModels(allCategories: categories,
                                         wrapCategories: mainCategories,
                                         completion: completion)
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}

extension CategorySelectorInteractorImp {
    enum CategoryDataSource {
        case firebase
        case cache(parentId: String)
    }
}

private extension CategorySelectorInteractorImp {
    func wrapViewModels(allCategories: [Category], wrapCategories: [Category], completion: @escaping Completion<[CategoryViewModel]>) {
        let viewModels = wrapCategories.map { category -> CategoryViewModel in
            let type: CategoryViewModel.`Type` = {
                if allCategories.contains(where: { $0.parentId == category.id }) {
                    return .node
                } else {
                    return .leaf
                }
            }()
            
            return CategoryViewModel(id: category.id,
                                     name: category.name,
                                     type: type,
                                     metadataType: category.type)
            
        }
        completion(.success(viewModels))
    }
}
