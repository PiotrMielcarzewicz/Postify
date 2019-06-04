//
//  CGFloat+.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 12/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

public extension CGFloat {
    public func scaled(from sourceRange: ClosedRange<CGFloat>, to targetRange: ClosedRange<CGFloat>, invert: Bool = false) -> CGFloat {
        let sourceSpan = sourceRange.upperBound - sourceRange.lowerBound
        let percentOfSelfInSourceRange = invert
            ? (sourceRange.upperBound - self) / sourceSpan
            : (self - sourceRange.lowerBound) / sourceSpan
        let targetSpan = targetRange.upperBound - targetRange.lowerBound
        return targetRange.lowerBound + percentOfSelfInSourceRange * targetSpan
    }
    
    public static var hairline: CGFloat {
        return 1 / UIScreen.main.scale
    }
    
    public func nanToZero() -> CGFloat {
        if isNaN {
            return 0
        }
        return self
    }
    
    public func restricted(to range: ClosedRange<CGFloat>) -> CGFloat {
        return Swift.max(Swift.min(self, range.upperBound), range.lowerBound)
    }
    
    public static func random(from range: ClosedRange<CGFloat>) -> CGFloat {
        let rangeSize = range.upperBound - range.lowerBound
        return range.lowerBound + CGFloat(arc4random()).truncatingRemainder(dividingBy: rangeSize)
    }
}

