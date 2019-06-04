//
//  Result.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

typealias Completion<T> = (Result<T>) -> ()
