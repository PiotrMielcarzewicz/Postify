//
//  Styles+Text.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

public extension Styles {
    public static func whiteRegular13TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 13, weight: .regular))
            $0.style_setTextColor(.white)
        }
    }
    
    public static func whiteRegular17TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 17, weight: .regular))
            $0.style_setTextColor(.white)
        }
    }
    
    public static func whiteBold19TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 19, weight: .bold))
            $0.style_setTextColor(.white)
        }
    }
    
    public static func whiteRegular23TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 23, weight: .regular))
            $0.style_setTextColor(.white)
        }
    }
    
    public static func whiteBold46TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 46, weight: .bold))
            $0.style_setTextColor(.white)
        }
    }
    
    public static func whiteBold35TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 35, weight: .bold))
            $0.style_setTextColor(.white)
        }
    }
    
    public static func blackBold30TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 30, weight: .bold))
            $0.style_setTextColor(.black)
        }
    }
    
    
    public static func blackRegular17TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 17, weight: .regular))
            $0.style_setTextColor(.black)
        }
    }
    
    public static func lightGrayRegular17TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 17, weight: .regular))
            $0.style_setTextColor(.lightGray)
        }
    }
    
    public static func blackHeavy17TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 17, weight: .heavy))
            $0.style_setTextColor(.black)
        }
    }
    
    public static func blackSemibold18TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 18, weight: .semibold))
            $0.style_setTextColor(.black)
        }
    }
    
    public static func blackSemibold17TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 17, weight: .semibold))
            $0.style_setTextColor(.black)
        }
    }
    
    public static func whiteSemibold17TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 17, weight: .semibold))
            $0.style_setTextColor(.white)
        }
    }
    
    public static func redSemibold17TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 17, weight: .semibold))
            $0.style_setTextColor(.red)
        }
    }
    
    public static func blackRegular14LabelStyle() -> UIViewStyle<UILabel> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 14, weight: .regular))
            $0.style_setTextColor(.black)
        }
    }
    
    public static func x64112BSemibold15TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 15, weight: .semibold))
            $0.style_setTextColor(.pst_x64112B)
        }
    }
    
    public static func x64112BBold30TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 30, weight: .bold))
            $0.style_setTextColor(.pst_x64112B)
        }
    }
    
    public static func whiteBold30TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 30, weight: .bold))
            $0.style_setTextColor(.white)
        }
    }
    
    public static func x64112BBold15TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 15, weight: .bold))
            $0.style_setTextColor(.pst_x64112B)
        }
    }
    
    public static func grayLight13TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 13, weight: .light))
            $0.style_setTextColor(.gray)
        }
    }
    
    public static func grayLight15TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 15, weight: .light))
            $0.style_setTextColor(.gray)
        }
    }
    
    public static func priceButtonStyle() -> UIViewStyle<UILabel> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 15, weight: .bold))
            $0.style_setTextColor(.white)
            $0.backgroundColor = .pst_x64112B
            Styles.roundedCornerStyle(cornerRounding: .fixedRadius(5)).apply(to: $0)
        }
    }
    
    public static func x64112BSemibold17TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 17, weight: .semibold))
            $0.style_setTextColor(.pst_x64112B)
        }
    }
    
    public static func x64112BBold27TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 27, weight: .bold))
            $0.style_setTextColor(.pst_x64112B)
        }
    }
    
    public static func blackRegular17BorderTextFieldStyle() -> UIViewStyle<UITextField> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 17, weight: .regular))
            $0.style_setTextColor(.black)
            $0.borderStyle = .roundedRect
        }
    }
    
    public static func whiteRegular17BorderTextFieldStyle() -> UIViewStyle<UITextField> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 17, weight: .regular))
            $0.style_setTextColor(.white)
            $0.borderStyle = .roundedRect
        }
    }
    
    public static func blackRegular17RoundBorderTextViewStyle() -> UIViewStyle<UITextView> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 17, weight: .regular))
            $0.style_setTextColor(.black)
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 0.25
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5
        }
    }
    
    public static func regular17TextStyle() -> UIViewStyle<UITextStylable> {
        return UIViewStyle {
            $0.style_setFont(Font.base(forSize: 17, weight: .regular))
        }
    }
}
