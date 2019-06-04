//
//  ConversationsService.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CodableFirebase

/// sourcery: AutoDependency
protocol ConversationsService {
    func getConversation(userId: String, advertisement: Advertisement, completion: @escaping Completion<[Conversation]>)
    func observeConversations(userId: String, refreshHandler: @escaping Completion<[Conversation]>)
    func unobserveConversations()
    func observeMessages(messagesId: String, refreshHandler: @escaping Completion<[Message]>)
    func unobserveMessages()
    func sendMessage(with metadata: MessageMetadata)
}

class ConversationsServiceImp: ConversationsService {
    private let databaseReference = Database.database().reference().child("Conversations")
    private let messagesDatabaseReference = Database.database().reference().child("Messages")
    private let dateFormatter: AppDateFormatter
    
    init(dateFormatter: AppDateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    func getConversation(userId: String, advertisement: Advertisement, completion: @escaping Completion<[Conversation]>) {
        databaseReference.queryOrdered(byChild: "recipientId").queryEqual(toValue: userId).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let value = snapshot.value else {
                completion(.failure(PostifyError.missingSnapshot))
                return
            }
            do {
                if let conversationTokens = (try? FirebaseDecoder().decode([String: Conversation].self, from: value)) {
                    let conversations = conversationTokens.map { $0.value }
                    let conversation = conversations.filter { $0.advertisementId == advertisement.id }.first
                    if let foundConversation = conversation {
                        completion(.success([foundConversation]))
                    } else {
                        self?.createNewConversation(userId: userId,
                                                    advertisement: advertisement,
                                                    completion: completion)
                    }
                } else {
                    self?.createNewConversation(userId: userId,
                                                advertisement: advertisement,
                                                completion: completion)
                }
            }
        }
    }
    
    func observeConversations(userId: String, refreshHandler: @escaping Completion<[Conversation]>) {
        databaseReference.queryOrdered(byChild: "recipientId").queryEqual(toValue: userId).observe(.value) { snapshot in
            guard let value = snapshot.value else {
                refreshHandler(.failure(PostifyError.missingSnapshot))
                return
            }
            do {
                let conversationTokens = (try? FirebaseDecoder().decode([String: Conversation].self, from: value)) ?? [:]
                let conversations = conversationTokens.map { $0.value }
                                                      .sorted(by: { $0.lastMessageTimestamp > $1.lastMessageTimestamp })
                refreshHandler(.success(conversations))
            }
        }
    }
    
    func observeMessages(messagesId: String, refreshHandler: @escaping Completion<[Message]>) {
        messagesDatabaseReference.child(messagesId).observe(.value) { snapshot in
            guard let value = snapshot.value else {
                refreshHandler(.failure(PostifyError.missingSnapshot))
                return
            }
            do {
                let conversationTokens = (try? FirebaseDecoder().decode([String: Message].self, from: value)) ?? [:]
                let conversations = conversationTokens.map { $0.value }
                    .sorted(by: { $0.timestamp > $1.timestamp })
                refreshHandler(.success(conversations))
            }
        }
    }
    
    func unobserveConversations() {
        databaseReference.removeAllObservers()
    }
    
    func unobserveMessages() {
        messagesDatabaseReference.removeAllObservers()
    }
    
    func sendMessage(with metadata: MessageMetadata) {
        guard let messageId = messagesDatabaseReference.child(metadata.messagesId).childByAutoId().key else { return }
        let timestamp = dateFormatter.timestamp(from: Date())
        
        let userConversation = Conversation(id: metadata.conversationId,
                                            otherConversationId: metadata.otherConversationId,
                                            advertisementId: metadata.advertisementId,
                                            recipientId: metadata.senderId,
                                            otherRecipientId: metadata.receiverId,
                                            messagesId: metadata.messagesId,
                                            lastMessage: metadata.message,
                                            lastMessageTimestamp: timestamp,
                                            lastMessageSenderId: metadata.senderId,
                                            lastMessageSenderName: metadata.senderName)
        
        let otherUserConversation = Conversation(id: metadata.otherConversationId,
                                                 otherConversationId: metadata.conversationId,
                                                 advertisementId: metadata.advertisementId,
                                                 recipientId: metadata.receiverId,
                                                 otherRecipientId: metadata.senderId,
                                                 messagesId: metadata.messagesId,
                                                 lastMessage: metadata.message,
                                                 lastMessageTimestamp: timestamp,
                                                 lastMessageSenderId: metadata.senderId,
                                                 lastMessageSenderName: metadata.senderName)
        
        let message = Message(id: messageId,
                              text: metadata.message,
                              timestamp: timestamp,
                              senderId: metadata.senderId,
                              imageStringURL: nil)
        
        let userData = try! FirebaseEncoder().encode(userConversation)
        databaseReference.child(metadata.conversationId).setValue(userData)
            
        let otherUserData = try! FirebaseEncoder().encode(otherUserConversation)
        databaseReference.child(metadata.otherConversationId).setValue(otherUserData)
        
        let messageData = try! FirebaseEncoder().encode(message)
        messagesDatabaseReference.child(metadata.messagesId).child(messageId).setValue(messageData)
    }
}

private extension ConversationsServiceImp {
    func createNewConversation(userId: String, advertisement: Advertisement, completion: @escaping Completion<[Conversation]>) {
        let timestamp = dateFormatter.timestamp(from: Date())
        guard let userConversationId = databaseReference.childByAutoId().key,
              let adOwnerConversationId = databaseReference.childByAutoId().key,
              let messagesId = messagesDatabaseReference.childByAutoId().key,
              let startMessageId = messagesDatabaseReference.child(messagesId).childByAutoId().key else {
                completion(.failure(PostifyError.missingId))
                return
        }
        
        let userConversation = Conversation(id: userConversationId,
                                            otherConversationId: adOwnerConversationId,
                                            advertisementId: advertisement.id,
                                            recipientId: userId,
                                            otherRecipientId: advertisement.ownerId,
                                            messagesId: messagesId,
                                            lastMessage: "start",
                                            lastMessageTimestamp: timestamp,
                                            lastMessageSenderId: nil,
                                            lastMessageSenderName: nil)
        
        let adOwnerConversation = Conversation(id: adOwnerConversationId,
                                               otherConversationId: userConversationId,
                                               advertisementId: advertisement.id,
                                               recipientId: advertisement.ownerId,
                                               otherRecipientId: userId,
                                               messagesId: messagesId,
                                               lastMessage: "start",
                                               lastMessageTimestamp: timestamp,
                                               lastMessageSenderId: nil,
                                               lastMessageSenderName: nil)
        
        let startMessage = Message(id: startMessageId,
                                   text: "start",
                                   timestamp: timestamp,
                                   senderId: nil,
                                   imageStringURL: nil)
        
        var createError: Error?
        let createGroup = DispatchGroup()
        
        createGroup.enter()
        let userData = try! FirebaseEncoder().encode(userConversation)
        databaseReference.child(userConversationId).setValue(userData) { (error, reference) in
            if let error = error {
                createError = error
            }
            createGroup.leave()
        }
        
        createGroup.enter()
        let adOwnerData = try! FirebaseEncoder().encode(adOwnerConversation)
        databaseReference.child(adOwnerConversationId).setValue(adOwnerData) { (error, reference) in
            if let error = error {
                createError = error
            }
            createGroup.leave()
        }
        
        createGroup.enter()
        let messageData = try! FirebaseEncoder().encode(startMessage)
        messagesDatabaseReference.child(messagesId).child(startMessageId).setValue(messageData) { (error, reference) in
            if let error = error {
                createError = error
            }
            createGroup.leave()
        }
        
        createGroup.notify(queue: .main) {
            if let error = createError {
                self.databaseReference.child(userConversationId).removeValue()
                self.databaseReference.child(adOwnerConversationId).removeValue()
                self.messagesDatabaseReference.child(messagesId).child(startMessageId).removeValue()
                completion(.failure(error))
                return
            }
            
            completion(.success([userConversation]))
        }
    }
}
