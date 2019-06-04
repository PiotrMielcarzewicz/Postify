//
//  MyProfilePresenter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol MyProfilePresenter {
    func viewDidLoad()
    func handleUpdateButtonTapped(with user: User)
}

class MyProfilePresenterImp: MyProfilePresenter {
    private unowned let view: MyProfileView
    private let interactor: MyProfileInteractor
    private let validator: Validator
    
    init(view: MyProfileView,
         interactor: MyProfileInteractor,
         validator: Validator) {
        self.view = view
        self.interactor = interactor
        self.validator = validator
    }
    
    func viewDidLoad() {
        let user = interactor.getUser()
        view.hydrate(with: user)
    }
    
    func handleUpdateButtonTapped(with user: User) {
        guard isValid(user) else { return }
        
        view.showLoadingHUD()
        interactor.updateUser(user: user) { [weak self] result in
            self?.view.hideLoadingHUD()
            switch result {
            case .success:
                self?.view.showAlert(.updatedUserData)
            case let .failure(error):
                self?.view.showAlert(for: error)
            }
        }
    }
}

private extension MyProfilePresenterImp {
    func isValid(_ user: User) -> Bool {
        guard validator.validateNonEmpty(user.email),
              validator.validateNonEmpty(user.firstName),
              validator.validateNonEmpty(user.lastName),
              validator.validateNonEmpty(user.city),
              validator.validateNonEmpty(user.country),
              validator.validateNonEmpty(user.phoneNumber) else { view.showAlert(.emptyFields); return false }
        
        guard validator.validate(user.phoneNumber, type: .phoneNumber) else { view.showAlert(.invalidPhoneNumber); return false }
        
        return true
    }
}
