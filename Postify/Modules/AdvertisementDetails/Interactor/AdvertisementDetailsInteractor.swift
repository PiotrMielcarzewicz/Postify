//
//  AdvertisementDetailsInteractor.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import CoreLocation

protocol AdvertisementDetailsInteractor {
    func getAdvertisementMetadata(of advertisement: Advertisement, completion: @escaping Completion<AdvertisementMetadata>)
}

typealias AdvertisementMetadata = (User, Advertisement, Category, isOwnerDisplaying: Bool, ownerCoordinate: CLLocationCoordinate2D?)
class AdvertisementDetailsInteractorImp: AdvertisementDetailsInteractor {
    typealias Dependecies = HasAdvertisementsService &
                            HasUserService &
                            HasCategoryService &
                            HasGeolocationService
    private let dependencies: Dependecies
    
    init(dependencies: Dependecies) {
        self.dependencies = dependencies
    }
    
    func getAdvertisementMetadata(of advertisement: Advertisement, completion: @escaping Completion<AdvertisementMetadata>) {
        let fetchGroup = DispatchGroup()
        var fetchError: Error?
        var fetchedUser: User!
        var fetchedAdvertisement: Advertisement!
        var fetchedCategory: Category!
        var ownerCoordinate: CLLocationCoordinate2D?
        
        fetchGroup.enter()
        dependencies.userService.getUser(id: advertisement.ownerId) { [weak self] result in
            switch result {
            case let .success(user):
                fetchedUser = user
                let address = user.city + " " + user.country
                self?.dependencies.geolocationService.getLocation(of: address, completion: { result in
                    switch result {
                    case let .success(coordinate):
                        ownerCoordinate = coordinate
                    case .failure:
                        break
                    }
                    fetchGroup.leave()
                })
            case let .failure(error):
                fetchError = error
                fetchGroup.leave()
            }
        }
        
        fetchGroup.enter()
        dependencies.advertisementsService.getAdvertisement(id: advertisement.id) { result in
            switch result {
            case let .success(advertisements):
                if let advertisement = advertisements.first {
                    fetchedAdvertisement = advertisement
                } else {
                    fetchError = PostifyError.missingSnapshot
                }
            case let .failure(error):
                fetchError = error
            }
            fetchGroup.leave()
        }
        
        fetchGroup.enter()
        dependencies.categoryService.getCategory(id: advertisement.categoryId) { result in
            switch result {
            case let .success(categories):
                if let category = categories.first {
                    fetchedCategory = category
                } else {
                    fetchError = PostifyError.missingSnapshot
                }
            case let .failure(error):
                fetchError = error
            }
            fetchGroup.leave()
        }
        
        fetchGroup.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
                return
            } else {
                let isOwnerDisplaying: Bool = {
                    switch self.dependencies.userService.state {
                    case let .loggedIn(currentUser):
                        return currentUser.id == fetchedUser.id
                    case .loggedOut:
                        fatalError("User should be logged in here!")
                    }
                }()
                
                let metadata = AdvertisementMetadata(fetchedUser,
                                                     fetchedAdvertisement,
                                                     fetchedCategory,
                                                     isOwnerDisplaying: isOwnerDisplaying,
                                                     ownerCoordinate: ownerCoordinate)
                completion(.success(metadata))
            }
        }
    }
}
