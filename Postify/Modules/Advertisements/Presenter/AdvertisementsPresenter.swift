//
//  AdvertisementsPresenter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol AdvertisementsPresenter {
    func viewDidLoad()
    func getAvailableSortActions() -> [AdvertisementSortAction]
    func handleSortActionTapped(_ action: AdvertisementSortAction)
    func handleFilterButtonTapped()
    func filteredElements(searchText: String, elements: [AdvertisementsStackElement]) -> [AdvertisementsStackElement]
    func handleAdvertisementTapped(_ advertisement: Advertisement)
}

class AdvertisementsPresenterImp: AdvertisementsPresenter {
    private unowned let view: AdvertisementsView
    private let interactor: AdvertisementsInteractor
    private let router: AdvertisementsRouter
    private var currentSort: AdvertisementSortAction = .dateDescending
    
    init(view: AdvertisementsView,
         interactor: AdvertisementsInteractor,
         router: AdvertisementsRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view.hydrate(with: [.emptyDataSet(.loading)])
        interactor.getAllAdvertisements { [weak self] result in
            self?.handleAdvertisementsResult(result)
        }
    }
    
    func getAvailableSortActions() -> [AdvertisementSortAction] {
        return [AdvertisementSortAction.dateDescending,
                AdvertisementSortAction.dateAscending,
                AdvertisementSortAction.lowToHigh,
                AdvertisementSortAction.highToLow]
    }
    
    func handleSortActionTapped(_ action: AdvertisementSortAction) {
        currentSort = action
        view.hydrate(with: [.emptyDataSet(.loading)])
        let advertisements = interactor.getSortedAdvertisements(sortAction: action)
        let elements = advertisements.map { AdvertisementsStackElement.advertisement($0) }
        let waitTime: Double = Double(Int.random(in: 3...6)) * 0.1
        let dispatchTime: DispatchTime = DispatchTime.now() + waitTime
        DispatchQueue.global().asyncAfter(deadline: dispatchTime) {
            DispatchQueue.main.async {
                self.view.hydrate(with: elements)
            }
        }
    }
    
    func handleFilterButtonTapped() {
        router.presentFilterView { [weak self] categoryViewModel in
            if categoryViewModel.id == "all" {
                self?.viewDidLoad()
            } else {
                self?.handleFilterSelection(with: categoryViewModel)
            }
        }
    }
    
    func filteredElements(searchText: String, elements: [AdvertisementsStackElement]) -> [AdvertisementsStackElement] {
        return interactor.getFilteredAdvertisements(query: searchText, sortAction: currentSort).map { AdvertisementsStackElement.advertisement($0) }
    }
    
    func handleAdvertisementTapped(_ advertisement: Advertisement) {
        router.showAdvertisementDetailsView(of: advertisement)
    }
}

private extension AdvertisementsPresenterImp {
    func handleFilterSelection(with categoryViewModel: CategoryViewModel) {
        view.hydrate(with: [.emptyDataSet(.loading)])
        interactor.getFilteredAdvertisements(categoryId: categoryViewModel.id) { [weak self] result in
            self?.handleAdvertisementsResult(result)
        }
    }
    
    func handleAdvertisementsResult(_ result: Result<[Advertisement]>) {
        switch result {
        case let .success(advertisements):
            let elements = advertisements.map { AdvertisementsStackElement.advertisement($0) }
            if elements.isEmpty {
                view.hydrate(with: [.emptyDataSet(.text(LocalizedStrings.noItems))])
            } else {
                view.hydrate(with: elements)
            }
        case let .failure(error):
            view.hydrate(with: [.emptyDataSet(.text(LocalizedStrings.failedToFetchAdvertisements))])
            view.showAlert(for: error)
        }
    }
}
