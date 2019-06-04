//
//  MyAdvertisementsPresenter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 12/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol MyAdvertisementsPresenter {
    func viewDidLoad()
    func getAvailableActions(for id: String) -> [MyAdvertisementAction]
    func handleAdvertisementAction(_ action: MyAdvertisementAction, id: String)
    func handleAddButtonTapped()
}

class MyAdvertisementsPresenterImp: MyAdvertisementsPresenter {
    private unowned let view: MyAdvertisementView
    private let interactor: MyAdvertisementsInteractor
    private let router: MyAdvertisementsRouter
    private var fetchedAdvertisements: [Advertisement] = []
    
    init(view: MyAdvertisementView,
         interactor: MyAdvertisementsInteractor,
         router: MyAdvertisementsRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        observeAdvertisements()
    }
    
    deinit {
        interactor.unobserveMyAdvertisements()
    }
    
    func getAvailableActions(for id: String) -> [MyAdvertisementAction] {
        guard let advertisement = fetchedAdvertisements.first(where: { $0.id == id }) else {
            fatalError("Advertisement shouldn't be nil here!")
        }
        
        if advertisement.isArchived {
            return [MyAdvertisementAction.showDetails,
                    MyAdvertisementAction.unarchive,
                    MyAdvertisementAction.close]
        } else {
            return [MyAdvertisementAction.showDetails,
                    MyAdvertisementAction.archive,
                    MyAdvertisementAction.edit,
                    MyAdvertisementAction.close]
        }
    }
    
    func handleAdvertisementAction(_ action: MyAdvertisementAction, id: String) {
        guard let advertisement = fetchedAdvertisements.first(where: { $0.id == id }) else {
            fatalError("Advertisement shouldn't be nil here!")
        }
        
        switch action {
        case .edit:
            router.showEditAdvertisementView(of: advertisement)
        case .archive:
            interactor.archiveAdvertisement(advertisement)
        case .unarchive:
            interactor.unarchiveAdvertisement(advertisement)
        case .showDetails:
            router.showAdvertisementDetailsView(of: advertisement)
        case .close:
            break
        }
    }
    
    func handleAddButtonTapped() {
        router.showAddAdvertisementView()
    }
}

private extension MyAdvertisementsPresenterImp {
    func observeAdvertisements() {
        view.hydrate(with: [.emptyDataSet(.loading)])
        interactor.observeMyAdvertisements { [weak self] result in
            switch result {
            case let .success(advertisements):
                self?.fetchedAdvertisements = advertisements
                self?.hydrateViewWithFetchedAdvertisements()
            case let .failure(error):
                self?.fetchedAdvertisements = []
                self?.view.showAlert(for: error)
                self?.view.hydrate(with: [.emptyDataSet(.text(LocalizedStrings.failedToFetchAdvertisements))])
            }
        }
    }
    
    func hydrateViewWithFetchedAdvertisements() {
        if fetchedAdvertisements.isEmpty {
            view.hydrate(with: [.emptyDataSet(.text(LocalizedStrings.youHaveNoAdvertisements))])
        } else {
            let elements = fetchedAdvertisements.map { MyAdvertisementsStackElement.advertisement($0) }
            view.hydrate(with: elements)
        }
    }
}
