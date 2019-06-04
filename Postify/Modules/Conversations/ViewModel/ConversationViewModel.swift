//
//  ConversationViewModel.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

struct ConversationViewModel {
    let title: String
    let lastMessage: String
    let lastMessageDate: String
    let conversationId: String
    let otherConversationId: String
    let otherUserId: String
    let advertisementId: String
    let messagesId: String
    let imageURL: URL?
    let advertisement: Advertisement
}
