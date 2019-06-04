//
//  ChatPresenter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol ChatPresenter {
    func viewDidLoad()
    func handleSendButtonTapped(with message: String)
    func handleDetailsButtonTapped()
}

class ChatPresenterImp: ChatPresenter {
    private unowned let view: ChatView
    private let interactor: ChatInteractor
    private let router: ChatRouter
    private let dateFormatter: AppDateFormatter
    private let conversationId: String
    private let otherConversationId: String
    private let otherUserId: String
    private let advertisementId: String
    private let messagesId: String
    private var fetchedAdvertisement: Advertisement!
    private var fetchedCurrentUser: User!
    private var fetchedOtherUser: User!
    
    init(view: ChatView,
         interactor: ChatInteractor,
         router: ChatRouter,
         dateFormatter: AppDateFormatter,
         conversationId: String,
         otherConversationId: String,
         otherUserId: String,
         advertisementId: String,
         messagesId: String) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.conversationId = conversationId
        self.otherConversationId = otherConversationId
        self.otherUserId = otherUserId
        self.advertisementId = advertisementId
        self.messagesId = messagesId
        self.dateFormatter = dateFormatter
    }
    
    deinit {
        unobserveMessages()
    }
    
    func viewDidLoad() {
        fetchMetadataAndTryObserveMessages()
    }
    
    func handleSendButtonTapped(with message: String) {
        let metadata = MessageMetadata(senderName: fetchedCurrentUser.firstName,
                                       conversationId: conversationId,
                                       otherConversationId: otherConversationId,
                                       advertisementId: fetchedAdvertisement.id,
                                       senderId: fetchedCurrentUser.id,
                                       receiverId: fetchedOtherUser.id,
                                       messagesId: messagesId,
                                       message: message)
        interactor.sendMessage(with: metadata)
    }
    
    func handleDetailsButtonTapped() {
        router.showAdvertisementDetailsView(of: fetchedAdvertisement)
    }
}

private extension ChatPresenterImp {
    func fetchMetadataAndTryObserveMessages() {
        view.hydrate(with: [.emptyDataSet(.loading)])
        interactor.getMedatada(advertisementId: advertisementId, otherUserId: otherUserId) { [weak self] result in
            switch result {
            case let .success(metadata):
                self?.handleMetadata(metadata)
            case let .failure(error):
                self?.view.showAlert(for: error)
                self?.view.hydrate(with: [.emptyDataSet(.text(LocalizedStrings.failedToFetchData))])
            }
        }
    }
    
    func handleMetadata(_ metadata: ChatMetadata) {
        let (advertisement, otherUser, currentUser) = metadata
        
        if advertisement.isArchived {
            view.showAlert(.advertisementIsArchived)
            router.goBack()
            return
        }
        
        fetchedOtherUser = otherUser
        fetchedCurrentUser = currentUser
        fetchedAdvertisement = advertisement
        view.activateDetailsButton()
        view.setTitle(fetchedOtherUser.firstName)
        observeMessages()
    }
    
    func observeMessages() {
        view.hydrate(with: [.emptyDataSet(.loading)])
        interactor.observeMessages(messagesId: messagesId) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case let .success(messages):
                self.handleFetchedMessages(messages)
            case let .failure(error):
                self.view.showAlert(for: error)
                self.view.hydrate(with: [.emptyDataSet(.text(LocalizedStrings.failedToFetchData))])
            }
        }
    }
    
    func unobserveMessages() {
        interactor.unobserveMessages()
    }
    
    func handleFetchedMessages(_ messages: [Message]) {
        if messages.isEmpty {
            view.hydrate(with: [.emptyDataSet(.text(LocalizedStrings.noItems))])
            return
        }
        
        let elements = messages.compactMap { message -> ChatStackElement? in
            if let senderId = message.senderId {
                let direction: MessageViewModel.Direction = (senderId == fetchedCurrentUser.id) ? .right : .left
                let date = dateText(for: message.timestamp)
                let viewModel = MessageViewModel(text: message.text,
                                                 dateText: date,
                                                 direction: direction)
                return ChatStackElement.textMessage(viewModel)
            } else {
                if messages.count == 1 {
                    return adminMessageElement(for: message.text)
                } else {
                    return nil
                }
            }
        }
        
        view.hydrate(with: elements)
    }
    
    func dateText(for timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        if Calendar.current.isDateInToday(date) {
            return dateFormatter.date(from: timestamp, template: .hourMinute)
        } else if Calendar.current.isDateInWeekend(date) {
            return dateFormatter.date(from: timestamp, template: .weekdayHourMinute)
        } else {
            return dateFormatter.date(from: timestamp, template: .dayMonthYear)
        }
    }
    
    func adminMessageElement(for text: String) -> ChatStackElement {
        switch text {
        case "start":
            return ChatStackElement.adminMessage(LocalizedStrings.conversationStarted, isFullscreen: true)
        default:
            return ChatStackElement.adminMessage(text, isFullscreen: false)
        }
    }
}
