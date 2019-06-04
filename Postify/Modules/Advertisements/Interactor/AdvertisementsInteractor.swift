//
//  AdvertisementsInteractor.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol AdvertisementsInteractor {
    func getAllAdvertisements(completion: @escaping Completion<[Advertisement]>)
    func getFilteredAdvertisements(categoryId: String, completion: @escaping Completion<[Advertisement]>)
    func getFilteredAdvertisements(query: String, sortAction: AdvertisementSortAction) -> [Advertisement]
    func getSortedAdvertisements(sortAction: AdvertisementSortAction) -> [Advertisement]
}

class AdvertisementsInteractorImp: AdvertisementsInteractor {
    typealias Dependencies = HasAdvertisementsService
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func getAllAdvertisements(completion: @escaping Completion<[Advertisement]>) {
        dependencies.advertisementsService.getAllAdvertisements(completion: completion)
    }
    
    func getFilteredAdvertisements(categoryId: String, completion: @escaping Completion<[Advertisement]>) {
        dependencies.advertisementsService.getFilteredAdvertisements(categoryId: categoryId, completion: completion)
    }
    
    func getFilteredAdvertisements(query: String, sortAction: AdvertisementSortAction) -> [Advertisement] {
        let advertisements = dependencies.advertisementsService.getCachedAdvertisements()
        let query = query.lowercased()
        let filtered = advertisements.filter {
            return ($0.title.lowercased().range(of: query) != nil) ||
                   ($0.description.lowercased().range(of: query) != nil) ||
                   detailedInfoContainsQuery(in: $0, query: query)
        }
        
        return sortedAdvertisements(filtered, by: sortAction)
    }
    
    func getSortedAdvertisements(sortAction: AdvertisementSortAction) -> [Advertisement] {
        let advertisements = dependencies.advertisementsService.getCachedAdvertisements()
        return sortedAdvertisements(advertisements, by: sortAction)
    }
}

private extension AdvertisementsInteractorImp {
    func detailedInfoContainsQuery(in advertisement: Advertisement, query: String) -> Bool {
        switch advertisement.detailedInfo {
        case let .vinyl(vinyl):
            return (vinyl.album.lowercased().range(of: query) != nil) ||
                   (vinyl.author.lowercased().range(of: query) != nil)
        case .none:
            return false
        }
    }
    
    func sortedAdvertisements(_ advertisements: [Advertisement], by sortAction: AdvertisementSortAction) -> [Advertisement] {
        switch sortAction {
        case .dateDescending:
            return advertisements.sorted(by: { $0.timestamp > $1.timestamp })
        case .dateAscending:
            return advertisements.sorted(by: { $0.timestamp < $1.timestamp })
        case .highToLow:
            return advertisements.sorted(by: { $0.price > $1.price })
        case .lowToHigh:
            return advertisements.sorted(by: { $0.price < $1.price })
        }
    }
}
