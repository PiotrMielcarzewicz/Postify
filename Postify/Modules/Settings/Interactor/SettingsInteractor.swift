//
//  SettingsInteractor.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 09/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol SettingsInteractor {
    func signOut()
    func userAllowsPhoneNumberVisibility() -> Bool
    func togglePhoneVisibility(isOn: Bool, completion: @escaping Completion<Void>)
}

class SettingsInteractorImp: SettingsInteractor {
    typealias Dependencies = HasUserService
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func signOut() {
        dependencies.userService.signOut()
    }
    
    func userAllowsPhoneNumberVisibility() -> Bool {
        switch dependencies.userService.state {
        case let .loggedIn(user):
            return user.publicPhoneNumber
        case .loggedOut:
            fatalError("User shouldn't be nil here!")
        }
    }
    
    func togglePhoneVisibility(isOn: Bool, completion: @escaping Completion<Void>) {
        let user: User = {
            switch dependencies.userService.state {
            case let .loggedIn(user):
                return user
            case .loggedOut:
                fatalError("User shouldn't be nil here!")
            }
        }()
        
        let updatedUser = User(id: user.id,
                               email: user.email,
                               firstName: user.firstName,
                               lastName: user.lastName,
                               phoneNumber: user.phoneNumber,
                               city: user.city,
                               country: user.country,
                               publicPhoneNumber: isOn)
        
        dependencies.userService.updateUser(updatedUser, completion: completion)
    }
}
