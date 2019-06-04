//
//  CornerRounding.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

public enum CornerRounding {
    case circle
    case fixedRadius(CGFloat)
    
    public func cornerRadius(for bounds: CGRect) -> CGFloat {
        switch self {
        case .circle:
            let height = bounds.height
            let width = bounds.width
            let shorterDimension = height > width ? width : height
            let cornerRadius = floor(shorterDimension * 0.5)
            return cornerRadius
        case let .fixedRadius(radius):
            return radius
        }
    }
}
