//
//  FormFieldViewModel.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

struct FormFieldViewModel {
    let title: String
    let text: String?
    let placeholder: String
    let type: KeyboardType
    
    init(title: String, text: String? = nil, placeholder: String, type: KeyboardType = .default) {
        self.title = title
        self.text = text
        self.placeholder = placeholder
        self.type = type
    }
}

extension FormFieldViewModel {
    enum KeyboardType {
        case `default`
        case numberPad
        case secure
        case locked
    }
}
