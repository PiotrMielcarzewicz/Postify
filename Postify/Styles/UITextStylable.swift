//
//  UITextStylable.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

/**
 * Allows definining common text styles
 * for buttons, labels and text fields.
 */
public protocol UITextStylable {
    func style_setTextColor(_ color: UIColor)
    func style_setFont(_ font: UIFont)
}

extension UIButton: UITextStylable {
    public func style_setTextColor(_ color: UIColor) {
        setTitleColor(color, for: .normal)
    }
    
    public func style_setFont(_ font: UIFont) {
        titleLabel?.font = font
    }
}

extension UILabel: UITextStylable {
    public func style_setTextColor(_ color: UIColor) {
        textColor = color
    }
    
    public func style_setFont(_ font: UIFont) {
        self.font = font
    }
}

extension UITextField: UITextStylable {
    public func style_setTextColor(_ color: UIColor) {
        textColor = color
    }
    
    public func style_setFont(_ font: UIFont) {
        self.font = font
    }
}

extension UITextView: UITextStylable {
    public func style_setTextColor(_ color: UIColor) {
        textColor = color
    }
    
    public func style_setFont(_ font: UIFont) {
        self.font = font
    }
}
