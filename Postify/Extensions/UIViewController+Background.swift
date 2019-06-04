//
//  UIViewController+Background.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func getAppThemeBackgroundView() -> UIView {
        let view = UIView()
        applyGradientLayer(to: view)
        applyBlur(to: view)
        return view
    }
}

fileprivate extension UIViewController {
    func applyGradientLayer(to view: UIView) {
        let colorTop =  UIColor.pst_x64112B.cgColor
        let colorBottom = UIColor.pst_x210910.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.6, 1.0]
        gradientLayer.frame = self.view.bounds
        
        view.layer.addSublayer(gradientLayer)
    }
    
    func applyBlur(to view: UIView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}
