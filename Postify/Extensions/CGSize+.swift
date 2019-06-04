//
//  CGSize+.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 12/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

public extension CGSize {
    public func byApplyingTransformToComponents(_ transform: (CGFloat) -> CGFloat) -> CGSize {
        return CGSize(width: transform(width), height: transform(height))
    }
    
    public func byTransforming(width widthTransform: (CGFloat) -> CGFloat = {$0}, height heightTransform: (CGFloat) -> CGFloat = {$0}) -> CGSize {
        return CGSize(width: widthTransform(width), height: heightTransform(height))
    }
}

public extension CGSize {
    var aspectRatio: CGFloat {
        return width / height
    }
    
    public func scaled(by scaleFactor: CGFloat) -> CGSize {
        return byApplyingTransformToComponents({ $0 * scaleFactor })
    }
}

