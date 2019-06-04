//
//  AdvertisementDetailsPresenter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol AdvertisementDetailsPresenter {
    func viewDidLoad()
    func handleContactButtonTapped(with target: ContactButtonViewModel.Target)
}

class AdvertisementDetailsPresenterImp: AdvertisementDetailsPresenter {
    private unowned let view: AdvertisementDetailsView
    private let interactor: AdvertisementDetailsInteractor
    private let router: AdvertisementDetailsRouter
    private let advertisement: Advertisement
    private let dateFormatter: AppDateFormatter
    
    init(view: AdvertisementDetailsView,
         interactor: AdvertisementDetailsInteractor,
         router: AdvertisementDetailsRouter,
         advertisement: Advertisement,
         dateFormatter: AppDateFormatter) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.advertisement = advertisement
        self.dateFormatter = dateFormatter
    }
    
    func viewDidLoad() {
        view.hydrate(with: [.emptyDataSet(.loading)])
        interactor.getAdvertisementMetadata(of: advertisement) { [weak self] result in
            switch result {
            case let .success(metadata):
                self?.handleFetchData(metadata: metadata)
            case let .failure(error):
                self?.view.hydrate(with: [.emptyDataSet(.text(LocalizedStrings.failedToFetchData))])
                self?.view.showAlert(for: error)
            }
        }
    }
    
    func handleContactButtonTapped(with target: ContactButtonViewModel.Target) {
        switch target {
        case let .phone(phoneNumber: number):
            if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case let .chat(advertisementId: id):
            router.switchConversationsTab()
            let idDict:[String: String] = ["advertisementId": id]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.postify.OpenChat"), object: nil, userInfo: idDict)
        }
    }
}

private extension AdvertisementDetailsPresenterImp {
    func handleFetchData(metadata: AdvertisementMetadata) {
        let (owner, advertisement, category, isOwnerDisplaying, ownerCoordinate) = metadata
        
        if advertisement.isArchived && !isOwnerDisplaying {
            view.showAlert(.advertisementIsArchived)
            router.goBack()
            return
        }
        
        var elements: [AdvertisementDetailsStackElement] = [.images(advertisement.imageURLs),
                                                            .title(advertisement.title),
                                                            .description(advertisement.description),
                                                            .detailsTitle(LocalizedStrings.advertisementInfo)]
        
        elements.append(AdvertisementDetailsStackElement.info(InfoViewModel(title: LocalizedStrings.priceDescription,
                                                                            value: priceText(of: advertisement))))
        elements.append(AdvertisementDetailsStackElement.info(InfoViewModel(title: LocalizedStrings.publishDateDescription,
                                                                            value: dateFormatter.date(from: advertisement.timestamp, template: .dayMonthYear))))
        elements.append(AdvertisementDetailsStackElement.info(InfoViewModel(title: LocalizedStrings.typeDescription,
                                                                            value: advertisement.type.title)))
        elements.append(AdvertisementDetailsStackElement.info(InfoViewModel(title: LocalizedStrings.categoryDescription,
                                                                            value: category.name)))
        elements += detailedInfoElements(of: advertisement)
        
        elements.append(AdvertisementDetailsStackElement.separator)
        let contactDetailsTitle = LocalizedStrings.contactDetailsTitle(name: owner.firstName)
        elements.append(AdvertisementDetailsStackElement.detailsTitle(contactDetailsTitle))
        elements.append(AdvertisementDetailsStackElement.info(InfoViewModel(title: LocalizedStrings.cityDescription,
                                                                            value: owner.city)))
        elements.append(AdvertisementDetailsStackElement.info(InfoViewModel(title: LocalizedStrings.countryDescription,
                                                                            value: owner.country)))
        if owner.publicPhoneNumber {
            elements += phoneElements(of: owner)
        }
        
        if !isOwnerDisplaying {
            elements += chatElements(with: advertisement)
        }
        
        elements.append(AdvertisementDetailsStackElement.separator)
        elements += mapElements(for: ownerCoordinate)
        
        view.hydrate(with: elements)
    }
    
    func detailedInfoElements(of advertisement: Advertisement) -> [AdvertisementDetailsStackElement] {
        switch advertisement.detailedInfo {
        case let .vinyl(vinyl):
            var elements: [AdvertisementDetailsStackElement] = []
            elements.append(AdvertisementDetailsStackElement.info(InfoViewModel(title: LocalizedStrings.authorDescription,
                                                                                value: vinyl.author)))
            elements.append(AdvertisementDetailsStackElement.info(InfoViewModel(title: LocalizedStrings.albumDescription,
                                                                                value: vinyl.album)))
            return elements
        case .none:
            return []
        }
    }
    
    func priceText(of advertisement: Advertisement) -> String {
        if advertisement.price == 0 {
            return LocalizedStrings.free
        } else {
            return "\(advertisement.price)$"
        }
    }
    
    func mapElements(for coordinate: CLLocationCoordinate2D?) -> [AdvertisementDetailsStackElement] {
        if let coordinate = coordinate {
            return [AdvertisementDetailsStackElement.map(coordinate)]
        } else {
            return []
        }
    }
    
    func phoneElements(of user: User) -> [AdvertisementDetailsStackElement] {
        let target = ContactButtonViewModel.Target.phone(phoneNumber: user.phoneNumber)
        let viewModel = ContactButtonViewModel(title: LocalizedStrings.phoneDescription,
                                               buttonText: user.phoneNumber,
                                               target: target)
        return [AdvertisementDetailsStackElement.contactButton(viewModel)]
    }
    
    func chatElements(with advertisement: Advertisement) -> [AdvertisementDetailsStackElement] {
        let target = ContactButtonViewModel.Target.chat(advertisementId: advertisement.id)
        let viewModel = ContactButtonViewModel(title: LocalizedStrings.chatDescription,
                                               buttonText: LocalizedStrings.open,
                                               target: target)
        return [AdvertisementDetailsStackElement.contactButton(viewModel)]
    }
}
