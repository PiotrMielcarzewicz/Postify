//
//  AddAdvertisementInteractor.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 11/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol AddAdvertisementInteractor {
    func addAdvertisement(with form: AdvertisementForm, completion: @escaping Completion<Void>)
    func editAdvertisement(_ advertisement: Advertisement, with form: AdvertisementForm, didEditImages: Bool, completion: @escaping Completion<Void>)
    func getCategory(of advertisement: Advertisement, completion: @escaping Completion<CategoryViewModel?>)
}

class AddAdvertisementInteractorImp: AddAdvertisementInteractor {
    typealias Dependencies = HasAppDateFormatter &
                             HasAdvertisementsService &
                             HasImageUploadService &
                             HasCategoryService &
                             HasUserService
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func addAdvertisement(with form: AdvertisementForm, completion: @escaping Completion<Void>) {
        guard let id = dependencies.advertisementsService.generateNewId() else {
            completion(.failure(PostifyError.missingId))
            return
        }
        
        guard let ownerId: String = {
            switch dependencies.userService.state {
            case let .loggedIn(user):
                return user.id
            case .loggedOut:
                fatalError("User should be logged here!")
            }
        }() else {
            fatalError("User should be logged here!")
        }
        
        let imageUploadGroup = DispatchGroup()
        var imageURLs: [URL] = []
        
        form.images.enumerated().forEach { (value) in
            imageUploadGroup.enter()
            let (index, image) = value
            let imageId = id + "-\(index)"
            dependencies.imageUploadService.uploadImage(image, id: imageId, completion: { result in
                switch result {
                case let .success(url):
                    imageURLs.append(url)
                case .failure:
                    break
                }
                imageUploadGroup.leave()
            })
        }
        
        imageUploadGroup.notify(queue: .main) {
            guard imageURLs.count == form.images.count else {
                completion(.failure(PostifyError.missingURL))
                return
            }
            let timestamp = self.dependencies.appDateFormatter.timestamp(from: Date())
            let advertisement = Advertisement(id: id,
                                              title: form.title,
                                              description: form.description,
                                              price: form.price,
                                              imageURLs: imageURLs,
                                              timestamp: timestamp,
                                              type: form.type,
                                              detailedInfo: form.detailedInfo,
                                              isArchived: false,
                                              categoryId: form.categoryViewModel!.id,
                                              ownerId: ownerId)
            self.dependencies.advertisementsService.publish(advertisement, completion: completion)
        }
    }
    
    func editAdvertisement(_ advertisement: Advertisement, with form: AdvertisementForm, didEditImages: Bool, completion: @escaping Completion<Void>) {
        if !didEditImages {
            let advertisement = Advertisement(id: advertisement.id,
                                              title: form.title,
                                              description: form.description,
                                              price: form.price,
                                              imageURLs: advertisement.imageURLs,
                                              timestamp: advertisement.timestamp,
                                              type: form.type,
                                              detailedInfo: form.detailedInfo,
                                              isArchived: advertisement.isArchived,
                                              categoryId: form.categoryViewModel!.id,
                                              ownerId: advertisement.ownerId)
            self.dependencies.advertisementsService.publish(advertisement, completion: completion)
        } else {
            let imageUploadGroup = DispatchGroup()
            var imageURLs: [URL] = []
            form.images.enumerated().forEach { (value) in
                imageUploadGroup.enter()
                let (index, image) = value
                let imageId = advertisement.id + "-\(index)"
                dependencies.imageUploadService.uploadImage(image, id: imageId, completion: { result in
                    switch result {
                    case let .success(url):
                        imageURLs.append(url)
                    case .failure:
                        break
                    }
                    imageUploadGroup.leave()
                })
            }
            
            imageUploadGroup.notify(queue: .main) {
                guard imageURLs.count == form.images.count else {
                    completion(.failure(PostifyError.missingURL))
                    return
                }
                let advertisement = Advertisement(id: advertisement.id,
                                                  title: form.title,
                                                  description: form.description,
                                                  price: form.price,
                                                  imageURLs: imageURLs,
                                                  timestamp: advertisement.timestamp,
                                                  type: form.type,
                                                  detailedInfo: form.detailedInfo,
                                                  isArchived: advertisement.isArchived,
                                                  categoryId: form.categoryViewModel!.id,
                                                  ownerId: advertisement.ownerId)
                self.dependencies.advertisementsService.publish(advertisement, completion: completion)
            }
        }
    }
    
    func getCategory(of advertisement: Advertisement, completion: @escaping Completion<CategoryViewModel?>) {
        dependencies.categoryService.getCategories { result in
            switch result {
            case let .success(categories):
                if let category = categories.first(where: { $0.id == advertisement.categoryId }) {
                    let type: CategoryViewModel.`Type` = categories.map { $0.parentId }.contains(category.id) ? .node : .leaf
                    let metadataType: AdvertisementType = {
                        switch advertisement.detailedInfo {
                        case .vinyl:
                            return .vinyl
                        case .none:
                            return .other
                        }
                    }()
                    let viewModel = CategoryViewModel(id: category.id,
                                                      name: category.name,
                                                      type: type,
                                                      metadataType: metadataType)
                    completion(.success(viewModel))
                } else {
                    completion(.success(nil))
                }
            case .failure:
                completion(.success(nil))
            }
        }
    }
}
