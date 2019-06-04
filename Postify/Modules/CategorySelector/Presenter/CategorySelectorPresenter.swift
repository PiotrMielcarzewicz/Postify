//
//  CategorySelectorPresenter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 10/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol CategorySelectorPresenter {
    func handleCategoryTapped(with viewModel: CategoryViewModel)
    func handleCloseTapped()
    func viewDidLoad()
}

class CategorySelectorPresenterImp: CategorySelectorPresenter {
    private unowned let view: CategorySelectorView
    private let interactor: CategorySelectorInteractor
    private let router: CategorySelectorRouter
    private let onCategorySelect: (CategoryViewModel) -> ()
    private let customTitle: String?
    private let shouldIncludeAllButton: Bool
    
    init(view: CategorySelectorView,
         interactor: CategorySelectorInteractor,
         router: CategorySelectorRouter,
         onCategorySelect: @escaping (CategoryViewModel) -> (),
         customTitle: String?,
         shouldIncludeAllButton: Bool) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.onCategorySelect = onCategorySelect
        self.customTitle = customTitle
        self.shouldIncludeAllButton = shouldIncludeAllButton
    }
    
    
    func handleCategoryTapped(with viewModel: CategoryViewModel) {
        switch viewModel.type {
        case .node:
            router.showSubcategories(parentViewModel: viewModel, onCategorySelect: onCategorySelect)
        case .leaf:
            onCategorySelect(viewModel)
            router.dismissView()
        }        
    }
    
    func handleCloseTapped() {
        router.dismissView()
    }
    
    func viewDidLoad() {
        if let title = customTitle {
            view.setTitle(title)
        }
        view.hydrate(with: [.emptyDataSet(.loading)])
        interactor.getCategories { [weak self] result in
            self?.handleCategoriesResult(result)
        }
    }
}

private extension CategorySelectorPresenterImp {
    func handleCategoriesResult(_ result: Result<[CategoryViewModel]>) {
        switch result {
        case let .success(viewModels):
            if viewModels.isEmpty {
                view.hydrate(with: [.emptyDataSet(.text(LocalizedStrings.noItems))])
            } else {
                if shouldIncludeAllButton {
                    let viewModel = CategoryViewModel(id: "all",
                                                      name: LocalizedStrings.all,
                                                      type: .leaf,
                                                      metadataType: .other)
                    let allElement = CategorySelectorStackElement.category(viewModel)
                    let elements = viewModels.map { CategorySelectorStackElement.category($0) }
                    view.hydrate(with: [allElement] + elements)
                } else {
                    let elements = viewModels.map { CategorySelectorStackElement.category($0) }
                    view.hydrate(with: elements)
                }
            }
        case let .failure(error):
            view.showAlert(for: error)
            view.hydrate(with: [.emptyDataSet(.text(LocalizedStrings.failedToFetchData))])
        }
    }
}
