//
//  ConversationsRouter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

protocol ConversationsRouter {
    func showChat(conversationId: String, otherConversationId: String, otherUserId: String, messagesId: String, advertisementId: String)
    func popToRoot()
    func showAdvertisementDetails(of advertisement: Advertisement)
}

class ConversationsRouterImp: Router, ConversationsRouter {
    func showChat(conversationId: String, otherConversationId: String, otherUserId: String, messagesId: String, advertisementId: String) {
        let builder = builderProvider.getChatBuilder()
        let view = builder.buildModule(conversationId: conversationId,
                                       otherConversationId: otherConversationId,
                                       otherUserId: otherUserId,
                                       messagesId: messagesId,
                                       advertisementId: advertisementId)
        show(view)
    }
    
    func popToRoot() {
        viewController.navigationController?.popToRootViewController(animated: false)
    }
    
    func showAdvertisementDetails(of advertisement: Advertisement) {
        let builder = builderProvider.getAdvertisementDetailsBuilder()
        let view = builder.buildModule(with: advertisement)
        show(view)
    }
}
