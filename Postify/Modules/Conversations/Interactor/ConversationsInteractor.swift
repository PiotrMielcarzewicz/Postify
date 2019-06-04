//
//  ConversationsInteractor.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol ConversationsInteractor {
    func observeConversations(refreshHandler: @escaping Completion<[Conversation]>)
    func getConversation(for advertisementId: String, completion: @escaping Completion<Conversation>)
    func getMetadata(of conversations: [Conversation], shouldUseCache: Bool, completion: @escaping Completion<[(Conversation, Advertisement)]>)
    func unobserveConversations()
    func lastMessageIsSentByCurrentUser(in conversation: Conversation) -> Bool
}

class ConversationsInteractorImp: ConversationsInteractor {
    typealias Dependencies = HasAdvertisementsService &
                             HasUserService &
                             HasConversationsService
    private let dependencies: Dependencies
    private var prefetchedAdvertisements: [Advertisement] = []
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func lastMessageIsSentByCurrentUser(in conversation: Conversation) -> Bool {
        let user: User = {
            switch dependencies.userService.state {
            case let .loggedIn(user):
                return user
            case .loggedOut:
                fatalError("User should be logged in here!")
            }
        }()
        return conversation.lastMessageSenderId == user.id
    }
    
    func observeConversations(refreshHandler: @escaping Completion<[Conversation]>) {
        let user: User = {
            switch dependencies.userService.state {
            case let .loggedIn(user):
                return user
            case .loggedOut:
                fatalError("User should be logged in here!")
            }
        }()
        dependencies.conversationsService.observeConversations(userId: user.id, refreshHandler: refreshHandler)
    }
    
    func unobserveConversations() {
        dependencies.conversationsService.unobserveConversations()
    }
    
    func getConversation(for advertisementId: String, completion: @escaping Completion<Conversation>) {
        dependencies.advertisementsService.getAdvertisement(id: advertisementId) { [weak self] result in
            switch result {
            case let .success(advertisements):
                if let advertisement = advertisements.first {
                    self?.getConversation(for: advertisement, completion: completion)
                } else {
                    completion(.failure(PostifyError.missingMetadata))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getMetadata(of conversations: [Conversation], shouldUseCache: Bool, completion: @escaping Completion<[(Conversation, Advertisement)]>) {
        let fetchGroup = DispatchGroup()
        var metadata: [(Conversation, Advertisement)] = []
        var fetchError: Error?
        conversations.forEach { _ in fetchGroup.enter() }
        
        conversations.forEach { conversation in
            if prefetchedAdvertisements.contains(where: { $0.id == conversation.advertisementId }) && shouldUseCache {
                let advertisement = prefetchedAdvertisements.first(where: { $0.id == conversation.advertisementId })!
                metadata.append((conversation, advertisement))
                fetchGroup.leave()
            } else {
                dependencies.advertisementsService.getAdvertisement(id: conversation.advertisementId) { [weak self] result in
                    switch result {
                    case let .success(advertisements):
                        if let advertisement = advertisements.first {
                            metadata.append((conversation, advertisement))
                            self?.prefetchedAdvertisements.removeAll(where: { $0.id == advertisement.id })
                            self?.prefetchedAdvertisements.append(advertisement)
                        } else {
                            fetchError = PostifyError.missingMetadata
                        }
                    case let .failure(error):
                        fetchError = error
                    }
                    fetchGroup.leave()
                }
            }
        }
        
        fetchGroup.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
                return
            }
            
            completion(.success(metadata.sorted(by: { $0.0.lastMessageTimestamp > $1.0.lastMessageTimestamp })))
        }
    }
}

private extension ConversationsInteractorImp {
    func getConversation(for advertisement: Advertisement, completion: @escaping Completion<Conversation>) {
        let user: User = {
            switch dependencies.userService.state {
            case let .loggedIn(user):
                return user
            case .loggedOut:
                fatalError("User should be logged in here!")
            }
        }()
        dependencies.conversationsService.getConversation(userId: user.id, advertisement: advertisement) { result in
            switch result {
            case let .success(conversations):
                if let conversation = conversations.first {
                    completion(.success(conversation))
                } else {
                    completion(.failure(PostifyError.missingMetadata))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
