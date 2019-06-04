//
//  ChatBuilder.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

/// sourcery: Builder
protocol ChatBuilder {
    func buildModule(conversationId: String, otherConversationId: String, otherUserId: String, messagesId: String, advertisementId: String) -> UIViewController
}

class ChatBuilderImp: ChatBuilder {
    private let appDependency: AppDependency
    
    init(appDependency: AppDependency) {
        self.appDependency = appDependency
    }
    
    func buildModule(conversationId: String, otherConversationId: String, otherUserId: String, messagesId: String, advertisementId: String) -> UIViewController {
        let view = ChatViewController()
        let router = ChatRouterImp(viewController: view,
                                   builderProvider: appDependency)
        let interactor = ChatInteractorImp(dependencies: appDependency)
        let presenter = ChatPresenterImp(view: view,
                                         interactor: interactor,
                                         router: router,
                                         dateFormatter: appDependency.appDateFormatter,
                                         conversationId: conversationId,
                                         otherConversationId: otherConversationId,
                                         otherUserId: otherUserId,
                                         advertisementId: advertisementId,
                                         messagesId: messagesId)
        view.presenter = presenter
        view.hidesBottomBarWhenPushed = true
        return view
    }
}
