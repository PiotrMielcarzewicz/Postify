//
//  SettingsPresenter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 03/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol SettingsPresenter {
    func viewDidLoad()
    func userDidTapSettingsOption(_ option: SettingsOption)
    func didSwitchToggle(for viewModel: SettingsOption, isOn: Bool)
}

class SettingsPresenterImp: SettingsPresenter {
    private unowned let view: SettingsView
    private let interactor: SettingsInteractor
    private let router: SettingsRouter
    
    init(view: SettingsView,
         interactor: SettingsInteractor,
         router: SettingsRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        let settingsOptions: [SettingsOption] = [.myProfile,
                                                 .resetPassword,
                                                 .phoneVisibility(interactor.userAllowsPhoneNumberVisibility()),
                                                 .logout]
        view.hydrate(with: settingsOptions)
    }
    
    func userDidTapSettingsOption(_ option: SettingsOption) {
        switch option {
        case .resetPassword:
            router.presentResetPassword()
        case .phoneVisibility:
            break
        case .logout:
            interactor.signOut()
            router.showLogin()
        case .myProfile:
            router.showMyProfile()
        }
    }
    
    func didSwitchToggle(for viewModel: SettingsOption, isOn: Bool) {
        switch viewModel {
        case .phoneVisibility:
            view.showLoadingHUD()
            interactor.togglePhoneVisibility(isOn: isOn) { [weak self] result in
                self?.view.hideLoadingHUD()
                switch result {
                case .success:
                    break
                case let .failure(error):
                    self?.view.showAlert(for: error)
                }
            }
        default:
            break
        }
    }
}
