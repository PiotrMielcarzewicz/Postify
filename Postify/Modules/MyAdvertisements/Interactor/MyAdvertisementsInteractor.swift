//
//  MyAdvertisementsInteractor.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 12/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol MyAdvertisementsInteractor {
    func observeMyAdvertisements(refreshHandler: @escaping Completion<[Advertisement]>)
    func unobserveMyAdvertisements()
    func archiveAdvertisement(_ advertisement: Advertisement)
    func unarchiveAdvertisement(_ advertisement: Advertisement)
}

class MyAdvertisementsInteractorImp: MyAdvertisementsInteractor {
    typealias Dependencies = HasAdvertisementsService & HasUserService
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func observeMyAdvertisements(refreshHandler: @escaping Completion<[Advertisement]>) {
        let userId: String = {
            switch dependencies.userService.state {
            case let .loggedIn(user):
                return user.id
            case .loggedOut:
                fatalError("User should be logged in here!")
            }
        }()
        dependencies.advertisementsService.observeAdvertisements(ownerId: userId, refreshHandler: refreshHandler)
    }
    
    func unobserveMyAdvertisements() {
        dependencies.advertisementsService.unobserveAdvertisements()
    }
    
    func archiveAdvertisement(_ advertisement: Advertisement) {
        setAdvertisementArchivedState(of: advertisement, to: true)
    }
    
    func unarchiveAdvertisement(_ advertisement: Advertisement) {
        setAdvertisementArchivedState(of: advertisement, to: false)
    }
}

private extension MyAdvertisementsInteractorImp {
    func setAdvertisementArchivedState(of advertisement: Advertisement, to shouldArchive: Bool) {
        let updatedAdvertisement = Advertisement(id: advertisement.id,
                                                 title: advertisement.title,
                                                 description: advertisement.description,
                                                 price: advertisement.price,
                                                 imageURLs: advertisement.imageURLs,
                                                 timestamp: advertisement.timestamp,
                                                 type: advertisement.type,
                                                 detailedInfo: advertisement.detailedInfo,
                                                 isArchived: shouldArchive,
                                                 categoryId: advertisement.categoryId,
                                                 ownerId: advertisement.ownerId)
        dependencies.advertisementsService.publish(updatedAdvertisement) { result in }
    }
}
