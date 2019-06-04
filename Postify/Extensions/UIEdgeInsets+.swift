//
//  UIEdgeInsets+.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 12/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

public extension UIEdgeInsets {
    public func byTransforming(topInset: (CGFloat) -> CGFloat = {$0},
                               leftInset: (CGFloat) -> CGFloat = {$0},
                               bottomInset: (CGFloat) -> CGFloat = {$0},
                               rightInset: (CGFloat) -> CGFloat = {$0}) -> UIEdgeInsets {
        return UIEdgeInsets(top: topInset(top), left: leftInset(left), bottom: bottomInset(bottom), right: rightInset(right))
    }
    
    public var horizontalInsetsSum: CGFloat {
        return left + right
    }
    
    public var verticalInsetsSum: CGFloat {
        return top + bottom
    }
}
