//
//  AdvertisementDetailsStackElement.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import CoreLocation

enum AdvertisementDetailsStackElement {
    case emptyDataSet(EmptyDataSetViewModel)
    case images([URL])
    case title(String)
    case description(String)
    case detailsTitle(String)
    case separator
    case info(InfoViewModel)
    case map(CLLocationCoordinate2D)
    case contactButton(ContactButtonViewModel)
}
