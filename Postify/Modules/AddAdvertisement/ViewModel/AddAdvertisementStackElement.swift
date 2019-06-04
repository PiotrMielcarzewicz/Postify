//
//  AddAdvertisementStackElement.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 06/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

enum AddAdvertisementStackElement {
    case title(String?)
    case description(String?)
    case category(CategoryViewModel?)
    case price(Float?)
    case images([ImageResource]?)
    case detailedInfo(AdvertisementTypeViewModel)
}

enum AdvertisementTypeViewModel {
    case none
    case vinyl(Vinyl?)
}
