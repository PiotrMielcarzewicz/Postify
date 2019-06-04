//
//  ForgotPasswordRouter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 05/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

class DismissableRouter: Router {
    func dismiss() {
        viewController.dismiss(animated: true)
    }
}
