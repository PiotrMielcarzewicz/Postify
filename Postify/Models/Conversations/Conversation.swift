//
//  Conversation.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

struct Conversation: Codable {
    let id: String
    let otherConversationId: String
    let advertisementId: String
    let recipientId: String
    let otherRecipientId: String
    let messagesId: String
    let lastMessage: String
    let lastMessageTimestamp: Int64
    let lastMessageSenderId: String?
    let lastMessageSenderName: String?
}
