//
//  Styles.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

public struct Styles {
    public static func roundedCornerStyle<T: UIView>(cornerRounding: CornerRounding) -> UIViewStyle<T> {
        return UIViewStyle<T> {
            let cornerRadius = cornerRounding.cornerRadius(for: $0.bounds)
            $0.layer.cornerRadius = cornerRadius
            $0.layer.masksToBounds = true
        }
    }
    
    public static func shadowStyle<T: UIView>(cornerRounding: CornerRounding, color: UIColor, opacity: Float, offset: CGSize, shadowRadius: CGFloat) -> UIViewStyle<T> {
        return UIViewStyle<T> {
            let cornerRadius = cornerRounding.cornerRadius(for: $0.bounds)
            let shadowPath = UIBezierPath(roundedRect: $0.bounds, cornerRadius: cornerRadius)
            $0.layer.masksToBounds = false
            $0.layer.shadowColor = color.cgColor
            $0.layer.shadowOffset = offset
            $0.layer.shadowOpacity = opacity
            $0.layer.shadowRadius = shadowRadius
            $0.layer.shadowPath = shadowPath.cgPath
        }
    }
    
    public static func shadowStyle<T: UIView>(offset: CGSize, radius: CGFloat, opacity: Float) -> UIViewStyle<T> {
        return UIViewStyle<T> {
            $0.layer.masksToBounds = false
            $0.layer.shadowOffset = offset
            $0.layer.shadowRadius = radius
            $0.layer.shadowOpacity = opacity
        }
    }
    
    public static func cardStyle() -> UIViewStyle<UIView> {
        return roundedCornerStyle(cornerRounding: .fixedRadius(10))
    }
    
    public static func whiteSemibold36RoundedCorner10ButtonStyle<T: UIButton>() -> UIViewStyle<T> {
        return UIViewStyle<T> {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 10
            $0.style_setFont(Font.base(forSize: 36, weight: .semibold))
            $0.tintColor = .white
        }
    }
    
    public static func themeSemibold36RoundedCorner10ButtonStyle<T: UIButton>() -> UIViewStyle<T> {
        return UIViewStyle<T> {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 10
            $0.style_setFont(Font.base(forSize: 36, weight: .semibold))
            $0.tintColor = .pst_x64112B
            $0.backgroundColor = .white
        }
    }
}
