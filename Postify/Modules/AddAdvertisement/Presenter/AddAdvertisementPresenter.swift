//
//  AddAdvertisementPresenter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 11/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

enum AddAdvertisementMode {
    case add
    case edit(Advertisement)
}

protocol AddAdvertisementPresenter {
    func viewDidLoad()
    func handleCreateButtonTapped(with form: AdvertisementForm)
    func handleSelectedCategoryTapped(completion: @escaping (CategoryViewModel) -> ())
}

class AddAdvertisementPresenterImp: AddAdvertisementPresenter {
    private unowned let view: AddAdvertisementView
    private let interactor: AddAdvertisementInteractor
    private let router: AddAdvertisementRouter
    private let validator: Validator
    private let mode: AddAdvertisementMode
    private var selectedCategoryViewModel: CategoryViewModel?
    
    init(view: AddAdvertisementView,
         interactor: AddAdvertisementInteractor,
         router: AddAdvertisementRouter,
         validator: Validator,
         mode: AddAdvertisementMode) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.validator = validator
        self.mode = mode
    }
    
    func viewDidLoad() {
        switch mode {
        case .add:
            hydrateViewAddMode()
        case let .edit(advertisement):
            hydrateViewEditMode(of: advertisement)
            fetchCategory(of: advertisement)
        }
    }
    
    func handleCreateButtonTapped(with form: AdvertisementForm) {
        guard isValid(form) else { return }
        
        view.showLoadingHUD()
        switch mode {
        case .add:
            interactor.addAdvertisement(with: form, completion: { [weak self] result in
                self?.view.hideLoadingHUD()
                self?.addAdvertisementCompletionHandler(result)
            })
        case let .edit(advertisement):
            interactor.editAdvertisement(advertisement, with: form, didEditImages: view.didEditImages(), completion: { [weak self] result in
                self?.view.hideLoadingHUD()
                self?.editAdvertisementCompletionHandler(result)
            })
        }
    }
    
    func handleSelectedCategoryTapped(completion: @escaping (CategoryViewModel) -> ()) {
        router.presentCategorySelector { [weak self] viewModel in
            self?.selectedCategoryViewModel = viewModel
            completion(viewModel)
        }
    }
}

private extension AddAdvertisementPresenterImp {
    func hydrateViewAddMode() {
        view.setTitle(LocalizedStrings.addAdvertisement)
        view.setRightButtonText(LocalizedStrings.add)
        let elements: [AddAdvertisementStackElement] = [.category(nil),
                                                        .title(nil),
                                                        .description(nil),
                                                        .price(nil),
                                                        .images(nil),
                                                        .detailedInfo(.vinyl(nil))]
        view.hydrate(with: elements)
    }
    
    func hydrateViewEditMode(of advertisement: Advertisement) {
        view.setTitle(LocalizedStrings.editAdvertisement)
        view.setRightButtonText(LocalizedStrings.update)
        let typeViewModel: AdvertisementTypeViewModel = {
            switch advertisement.detailedInfo {
            case .none:
                return .none
            case let .vinyl(vinyl):
                return .vinyl(vinyl)
            }
        }()
        let imagesSource = advertisement.imageURLs.map { ImageResource.remote($0) }
        let elements: [AddAdvertisementStackElement] = [.category(selectedCategoryViewModel),
                                                        .title(advertisement.title),
                                                        .description(advertisement.description),
                                                        .price(advertisement.price),
                                                        .images(imagesSource),
                                                        .detailedInfo(typeViewModel)]
        view.hydrate(with: elements)
    }
    
    func addAdvertisementCompletionHandler(_ result: Result<Void>) {
        switch result {
        case .success:
            router.goBack()
            view.showAlert(.didCreateAdvertisement)
        case let .failure(error):
            view.showAlert(for: error)
        }
    }
    
    func editAdvertisementCompletionHandler(_ result: Result<Void>) {
        switch result {
        case .success:
            router.goBack()
            view.showAlert(.didEditAdvertisement)
        case let .failure(error):
            view.showAlert(for: error)
        }
    }
    
    func isValid(_ form: AdvertisementForm) -> Bool {
        guard validator.validateNonEmpty(form.title),
              validator.validateNonEmpty(form.description),
              validator.validateAdvertisementDetails(form.detailedInfo),
              form.categoryViewModel != nil else { view.showAlert(.emptyFields); return false }
        
        return true
    }
    
    func fetchCategory(of advertisement: Advertisement) {
        view.showLoadingHUD()
        interactor.getCategory(of: advertisement) { [weak self] result in
            self?.view.hideLoadingHUD()
            switch result {
            case let .success(viewModel):
                if let viewModel = viewModel {
                    self?.selectedCategoryViewModel = viewModel
                    self?.hydrateViewEditMode(of: advertisement)
                }
            case .failure:
                break
            }
        }
    }
}
