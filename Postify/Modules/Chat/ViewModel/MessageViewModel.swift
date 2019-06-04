//
//  MessageViewModel.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 15/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

struct MessageViewModel {
    let text: String
    let dateText: String
    let direction: Direction
}

extension MessageViewModel {
    enum Direction {
        case left
        case right
    }
}
