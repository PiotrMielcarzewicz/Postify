//
//  Separator.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 12/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Visually

open class Separator: UIView {
    public var color: UIColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.8, alpha: 1) {
        didSet {
            colorLayer.backgroundColor = color.cgColor
        }
    }
    public var margins: UIEdgeInsets {
        didSet {
            setNeedsLayout()
        }
    }
    public let axis: Axis
    
    private let colorLayer = CALayer()
    
    public init(axis: Axis = .horizontal, margins: UIEdgeInsets = .zero) {
        self.margins = margins
        self.axis = axis
        super.init(frame: .zero)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return size.byTransforming(height: {_ in return 1 })
    }
    
    open override var intrinsicContentSize: CGSize {
        switch axis {
        case .horizontal:
            return CGSize(width: UIView.noIntrinsicMetric, height: 1)
        case .vertical:
            return CGSize(width: 1, height: UIView.noIntrinsicMetric)
        }
    }
    
    open override func layoutSubviews() {
        colorLayer.frame = colorLayerFrame()
        super.layoutSubviews()
    }
    
    private func colorLayerFrame() -> CGRect {
        var frame = bounds
        switch axis {
        case .horizontal:
            frame.origin.x = margins.left
            frame.size.width = bounds.width - margins.horizontalInsetsSum
            frame.size.height = .hairline
        case .vertical:
            frame.origin.y = margins.top
            frame.size.width = .hairline
            frame.size.height = bounds.height - margins.verticalInsetsSum
        }
        return frame
    }
}

private extension Separator {
    func setup() {
        layer.addSublayer(colorLayer)
        colorLayer.backgroundColor = color.cgColor
        backgroundColor = .clear
        setContentHuggingPriority(.init(900), for: .vertical)
    }
}
