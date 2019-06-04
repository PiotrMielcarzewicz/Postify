//
//  UIView+.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func prepareSubviewsForAutolayout() {
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func findSubview(where meetsCondition: (UIView) -> Bool) -> UIView? {
        for subview in subviews {
            if meetsCondition(subview) {
                return subview
            }
            if let found = subview.findSubview(where: meetsCondition) {
                return found
            }
        }
        return nil
    }
}
