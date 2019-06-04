//
//  AdvertisementForm.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 11/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

struct AdvertisementForm {
    let title: String
    let categoryViewModel: CategoryViewModel?
    let description: String
    let price: Float
    let images: [UIImage]
    let detailedInfo: AdvertisementDetailedInfo
    
    var type: AdvertisementType {
        switch detailedInfo {
        case .vinyl:
            return .vinyl
        case .none:
            return .other
        }
    }
}
