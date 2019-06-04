//
//  ChatStackElement.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

enum ChatStackElement {
    case emptyDataSet(EmptyDataSetViewModel)
    case textMessage(MessageViewModel)
    case adminMessage(String, isFullscreen: Bool)
}
