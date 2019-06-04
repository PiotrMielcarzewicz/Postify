//
//  ForgotPasswordInteractor.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol ForgotPasswordInteractor {
    func sendResetPasswordEmail(with email: String, completion: @escaping Completion<Void>)
}

class ForgotPasswordInteractorImp: ForgotPasswordInteractor {
    typealias Dependencies = HasUserService
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func sendResetPasswordEmail(with email: String, completion: @escaping Completion<Void>) {
        dependencies.userService.sendResetPasswordEmail(with: email, completion: completion)
    }
}
