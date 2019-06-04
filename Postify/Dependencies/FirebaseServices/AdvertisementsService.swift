//
//  AdvertisementsService.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CodableFirebase

/// sourcery: AutoDependency
protocol AdvertisementsService {
    func publish(_ advertisement: Advertisement, completion: @escaping Completion<Void>)
    func getAllAdvertisements(completion: @escaping Completion<[Advertisement]>)
    func getFilteredAdvertisements(categoryId: String, completion: @escaping Completion<[Advertisement]>)
    func observeAdvertisements(ownerId: String, refreshHandler: @escaping Completion<[Advertisement]>)
    func unobserveAdvertisements()
    func generateNewId() -> String?
    func getCachedAdvertisements() -> [Advertisement]
    func getAdvertisement(id: String, completion: @escaping Completion<[Advertisement]>)
}

class AdvertisementsServiceImp: AdvertisementsService {
    private let databaseReference: DatabaseReference
    private var observeRef: DatabaseReference?
    private var advertisementsRefreshHandler: DatabaseHandle?
    private var cachedAdvertisements: [Advertisement] = []
    
    init(databaseReference: DatabaseReference = Database.database().reference().child("Advertisements")) {
        self.databaseReference = databaseReference
    }
    
    func getCachedAdvertisements() -> [Advertisement] {
        return cachedAdvertisements
    }
    
    func generateNewId() -> String? {
        return databaseReference.childByAutoId().key
    }
    
    func publish(_ advertisement: Advertisement, completion: @escaping Completion<Void>) {
        let data = try! FirebaseEncoder().encode(advertisement)
        databaseReference.child(advertisement.id).removeValue()
        databaseReference.child(advertisement.id).setValue(data) { (error, reference) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getAllAdvertisements(completion: @escaping Completion<[Advertisement]>) {
        databaseReference.queryOrdered(byChild: "isArchived").queryEqual(toValue: false).observeSingleEvent(of: .value) { [weak self] snapshot in
            self?.handleSnapshot(snapshot,
                                 shouldCache: true,
                                 shouldFilterArchived: false,
                                 completion: completion)
        }
    }
    
    func observeAdvertisements(ownerId: String, refreshHandler: @escaping Completion<[Advertisement]>) {
        databaseReference.queryOrdered(byChild: "ownerId").queryEqual(toValue: ownerId).observe(.value) { [weak self] snapshot in
            self?.handleSnapshot(snapshot,
                                 shouldCache: false,
                                 shouldFilterArchived: false,
                                 completion: refreshHandler)
        }
    }
    
    func getFilteredAdvertisements(categoryId: String, completion: @escaping Completion<[Advertisement]>) {
        databaseReference.queryOrdered(byChild: "categoryId").queryEqual(toValue: categoryId).observeSingleEvent(of: .value) { [weak self] snapshot in
            self?.handleSnapshot(snapshot,
                                 shouldCache: false,
                                 shouldFilterArchived: true,
                                 completion: completion)
        }
    }
    
    func unobserveAdvertisements() {
        databaseReference.removeAllObservers()
    }
    
    func getAdvertisement(id: String, completion: @escaping Completion<[Advertisement]>) {
        databaseReference.queryOrdered(byChild: "id").queryEqual(toValue: id).observeSingleEvent(of: .value) { [weak self] snapshot in
            self?.handleSnapshot(snapshot,
                                 shouldCache: false,
                                 shouldFilterArchived: false,
                                 completion: completion)
        }
    }
}

private extension AdvertisementsServiceImp {
    func handleSnapshot(_ snapshot: DataSnapshot, shouldCache: Bool, shouldFilterArchived: Bool, completion: @escaping Completion<[Advertisement]>) {
        guard let value = snapshot.value else {
            completion(.failure(PostifyError.missingSnapshot))
            return
        }
        do {
            let advertisementTokens = (try? FirebaseDecoder().decode([String: Advertisement].self, from: value)) ?? [:]
            let advertisements = advertisementTokens.map { $0.value }
                                                    .sorted(by: { $0.timestamp > $1.timestamp })
                                                    .filter { shouldFilterArchived ? !$0.isArchived : true }
            if shouldCache {
                cachedAdvertisements = advertisements
            }
            completion(.success(advertisements))
        }
    }
}
