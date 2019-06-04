//
//  Message.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

struct Message: Codable {
    let id: String
    let text: String
    let timestamp: Int64
    let senderId: String?
    let imageStringURL: String?
}
