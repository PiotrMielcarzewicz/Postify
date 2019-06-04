//
//  SignInPresenter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol SignInPresenter {
    func viewDidLoad()
    func userDidSelectAction(_ action: SignInAction)
}

class SignInPresenterImp: SignInPresenter {
    private unowned let view: SignInView
    private let interactor: SignInInteractor
    private let router: SignInRouter
    private let validator: Validator
    
    init(view: SignInView,
         interactor: SignInInteractor,
         router: SignInRouter,
         validator: Validator) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.validator = validator
    }
    
    func viewDidLoad() {
        let titleViewModel = TitleCellViewModel(title: LocalizedStrings.postify,
                                                subtitle: nil,
                                                titleSize: .big)
        let elements: [SignInStackElement] = [.title(titleViewModel),
                                              .credentialsForm,
                                              .actionButtons]
        view.hydrate(with: elements)
    }
    
    func userDidSelectAction(_ action: SignInAction) {
        switch action {
        case .signIn:
            trySignIn()
        case .forgotPassword:
            router.showForgotPassword()
        case .signUp:
            router.showSignUp()
        }
    }
}

private extension SignInPresenterImp {
    func trySignIn() {
        let credentials = view.getEnteredCredentials()
        if validateCredentials(credentials) {
            trySignIn(with: credentials)
        }
    }
    
    func trySignIn(with credentials: Credentials) {
        view.showLoadingHUD()
        interactor.signIn(with: credentials) { [weak self] result in
            self?.view.hideLoadingHUD()
            switch result {
            case .success:
                self?.router.showHomeView()
            case let .failure(error):
                self?.view.showAlert(.custom(title: LocalizedStrings.errorCapitalized,
                                             subtitle: error.localizedDescription,
                                             style: .danger))
            }
        }
    }
    
    func validateCredentials(_ credentials: Credentials) -> Bool {
        guard validator.validateNonEmpty(credentials.email), validator.validateNonEmpty(credentials.password) else {
            view.showAlert(.emptyFields)
            return false
        }
        
        return true
    }
}
