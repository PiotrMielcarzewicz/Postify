//
//  ChatInteractor.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol ChatInteractor {
    func getMedatada(advertisementId: String, otherUserId: String, completion: @escaping Completion<ChatMetadata>)
    func observeMessages(messagesId: String, refreshHandler: @escaping Completion<[Message]>)
    func unobserveMessages()
    func sendMessage(with metadata: MessageMetadata)
}

typealias ChatMetadata = (Advertisement, otherUser: User, currentUser: User)
typealias MessageMetadata =
    (senderName: String,
    conversationId: String,
    otherConversationId: String,
    advertisementId: String,
    senderId: String,
    receiverId: String,
    messagesId: String,
    message: String)

class ChatInteractorImp: ChatInteractor {
    typealias Dependencies = HasAdvertisementsService &
                             HasConversationsService &
                             HasUserService
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func getMedatada(advertisementId: String, otherUserId: String, completion: @escaping Completion<ChatMetadata>) {
        let currentUser: User = {
            switch dependencies.userService.state {
            case let .loggedIn(user):
                return user
            case .loggedOut:
                fatalError("User should be logged in here!")
            }
        }()
        
        dependencies.advertisementsService.getAdvertisement(id: advertisementId) { [weak self] result in
            switch result {
            case let .success(advertisements):
                if let advertisement = advertisements.first {
                    self?.handleFetchedAdvertisement(advertisement,
                                                     otherUserId: otherUserId,
                                                     currentUser: currentUser,
                                                     completion: completion)
                } else {
                    completion(.failure(PostifyError.missingMetadata))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func observeMessages(messagesId: String, refreshHandler: @escaping Completion<[Message]>) {
        dependencies.conversationsService.observeMessages(messagesId: messagesId, refreshHandler: refreshHandler)
    }
    
    func unobserveMessages() {
        dependencies.conversationsService.unobserveMessages()
    }
    
    func sendMessage(with metadata: MessageMetadata) {
        dependencies.conversationsService.sendMessage(with: metadata)
    }
}

private extension ChatInteractorImp {
    func handleFetchedAdvertisement(_ advertisement: Advertisement, otherUserId: String, currentUser: User, completion: @escaping Completion<ChatMetadata>) {
        dependencies.userService.getUser(id: otherUserId) { result in
            switch result {
            case let .success(otherUser):
                let metadata = ChatMetadata(advertisement,
                                            otherUser: otherUser,
                                            currentUser: currentUser)
                completion(.success(metadata))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
