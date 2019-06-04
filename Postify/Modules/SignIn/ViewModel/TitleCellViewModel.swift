//
//  TitleCellViewModel.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

struct TitleCellViewModel {
    let title: String
    let subtitle: String?
    let titleSize: TitleSize
}

extension TitleCellViewModel {
    enum TitleSize {
        case big
        case normal
    }
}
