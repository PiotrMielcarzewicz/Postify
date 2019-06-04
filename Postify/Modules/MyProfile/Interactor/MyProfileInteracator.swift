//
//  MyProfileInteracator.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol MyProfileInteractor {
    func getUser() -> User
    func updateUser(user: User, completion: @escaping Completion<Void>)
}

class MyProfileInteractorImp: MyProfileInteractor {
    typealias Dependencies = HasUserService
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func getUser() -> User {
        switch dependencies.userService.state {
        case let .loggedIn(user):
            return user
        case .loggedOut:
            fatalError("User should be logged in")
        }
    }
    
    func updateUser(user: User, completion: @escaping Completion<Void>) {
        dependencies.userService.updateUser(user, completion: completion)
    }
}
