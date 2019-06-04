//
//  SignInInteractor.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol SignInInteractor {
    func signIn(with credentials: Credentials, completion: @escaping Completion<User>)
}

class SignInInteractorImp: SignInInteractor {
    typealias Dependencies = HasUserService
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func signIn(with credentials: Credentials, completion: @escaping Completion<User>) {
        dependencies.userService.signIn(with: credentials, completion: completion)
    }
}
