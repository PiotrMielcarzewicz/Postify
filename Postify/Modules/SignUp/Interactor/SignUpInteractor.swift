//
//  SignUpInteractor.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol SignUpInteractor {
    func signUp(with form: UserForm, completion: @escaping Completion<Void>)
}

class SignUpInteractorImp: SignUpInteractor {
    typealias Dependencies = HasUserService
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func signUp(with form: UserForm, completion: @escaping Completion<Void>) {
        dependencies.userService.signUp(with: form, completion: completion)
    }
}
