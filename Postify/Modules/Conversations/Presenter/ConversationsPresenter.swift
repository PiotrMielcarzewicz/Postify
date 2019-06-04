//
//  ConversationsPresenter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol ConversationsPresenter {
    func viewDidLoad()
    func handleConversationTapped(conversationId: String, otherConversationId: String, otherUserId: String, messagesId: String, advertisementId: String)
    func handleDetailsButtonTapped(with advertisement: Advertisement)
    func handleRefresh()
}

class ConversationsPresenterImp: ConversationsPresenter {
    private unowned let view: ConversationsView
    private let interactor: ConversationsInteractor
    private let router: ConversationsRouter
    private var didCompleteInitialLoad = false
    private var shouldUseCache = false
    private let dateFormatter: AppDateFormatter
    
    init(view: ConversationsView,
         interactor: ConversationsInteractor,
         router: ConversationsRouter,
         dateFormatter: AppDateFormatter) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.dateFormatter = dateFormatter
        observeNotifications()
    }
    
    deinit {
        interactor.unobserveConversations()
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewDidLoad() {
        observeConversations()
    }
    
    func handleConversationTapped(conversationId: String, otherConversationId: String, otherUserId: String, messagesId: String, advertisementId: String) {
        router.showChat(conversationId: conversationId,
                        otherConversationId: otherConversationId,
                        otherUserId: otherUserId,
                        messagesId: messagesId,
                        advertisementId: advertisementId)
    }
    
    func handleDetailsButtonTapped(with advertisement: Advertisement) {
        router.showAdvertisementDetails(of: advertisement)
    }
    
    func handleRefresh() {
        interactor.unobserveConversations()
        shouldUseCache = false
        observeConversations()
    }
}

private extension ConversationsPresenterImp {
    func observeNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handleOpenChatNotification(_:)),
                                               name: NSNotification.Name(rawValue: "com.postify.OpenChat"),
                                               object: nil)
    }
    
    @objc func handleOpenChatNotification(_ notification: NSNotification) {
        if let advertisementId = notification.userInfo?["advertisementId"] as? String {
            router.popToRoot()
            view.showLoadingHUD()
            interactor.getConversation(for: advertisementId) { [weak self] result in
                self?.view.hideLoadingHUD()
                switch result {
                case let .success(conversation):
                    self?.router.showChat(conversationId: conversation.id,
                                          otherConversationId: conversation.otherConversationId,
                                          otherUserId: conversation.otherRecipientId,
                                          messagesId: conversation.messagesId,
                                          advertisementId: conversation.advertisementId)
                case let .failure(error):
                    self?.view.showAlert(for: error)
                }
            }
        }
    }
    
    func observeConversations() {
        view.hydrate(with: [.emptyDataSet(.loading)])
        interactor.observeConversations { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case let .success(conversations):
                self.fetchAdvertisementsAndHydrateView(with: conversations,
                                                       shouldShowSpinner: self.didCompleteInitialLoad)
            case let .failure(error):
                self.view.showAlert(for: error)
                self.view.hydrate(with: [.emptyDataSet(.text(LocalizedStrings.failedToFetchData))])
            }
        }
    }
    
    func fetchAdvertisementsAndHydrateView(with conversations: [Conversation], shouldShowSpinner: Bool) {
        if !didCompleteInitialLoad {
            view.hydrate(with: [.emptyDataSet(.loading)])
            didCompleteInitialLoad = true
        }
        
        if conversations.isEmpty {
            view.hydrate(with: [.emptyDataSet(.text(LocalizedStrings.youHaveNoConversations))])
            return
        }
        
        interactor.getMetadata(of: conversations, shouldUseCache: shouldUseCache) { [weak self] result in
            switch result {
            case let .success(metadata):
                self?.shouldUseCache = true
                self?.hydrateView(with: metadata)
            case let .failure(error):
                self?.view.showAlert(for: error)
                self?.view.hydrate(with: [.emptyDataSet(.text(LocalizedStrings.failedToFetchData))])
            }
        }
    }
    
    func hydrateView(with metadata: [(Conversation, Advertisement)]) {
        let filteredMetadata = metadata.filter { !$0.1.isArchived }
        
        if filteredMetadata.isEmpty {
            view.hydrate(with: [.emptyDataSet(.text(LocalizedStrings.youHaveNoConversations))])
            return
        }
        
        let elements: [ConversationsStackElement] = filteredMetadata.map { metadata -> ConversationsStackElement in
            let (conversation, advertisement) = metadata
            let timeText = dateText(for: conversation.lastMessageTimestamp)
            let viewModel = ConversationViewModel(title: advertisement.title,
                                                  lastMessage: lastMessage(for: conversation),
                                                  lastMessageDate: timeText,
                                                  conversationId: conversation.id,
                                                  otherConversationId: conversation.otherConversationId,
                                                  otherUserId: conversation.otherRecipientId,
                                                  advertisementId: advertisement.id,
                                                  messagesId: conversation.messagesId,
                                                  imageURL: advertisement.imageURLs.first,
                                                  advertisement: advertisement)
            return ConversationsStackElement.conversation(viewModel)
        }
        view.hydrate(with: elements)
    }
    
    func dateText(for timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        if Calendar.current.isDateInToday(date) {
            return dateFormatter.date(from: timestamp, template: .hourMinute)
        } else if Calendar.current.isDateInWeekend(date) {
            return dateFormatter.date(from: timestamp, template: .weekday)
        } else {
            return dateFormatter.date(from: timestamp, template: .dayMonthYear)
        }
    }
    
    func lastMessage(for conversation: Conversation) -> String {
        if let senderName = conversation.lastMessageSenderName {
            if interactor.lastMessageIsSentByCurrentUser(in: conversation) {
                return LocalizedStrings.you + ": " + conversation.lastMessage
            } else {
                return senderName + ": " + conversation.lastMessage
            }
        } else {
            switch conversation.lastMessage {
            case "start":
                return LocalizedStrings.conversationStarted
            default:
                return ""
            }
        }
    }
}
