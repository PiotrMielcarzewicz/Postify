//
//  CategorySelectorStackElement.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 10/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

enum CategorySelectorStackElement {
    case emptyDataSet(EmptyDataSetViewModel)
    case category(CategoryViewModel)
}
