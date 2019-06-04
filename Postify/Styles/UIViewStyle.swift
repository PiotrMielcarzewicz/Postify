//
//  UIViewStyle.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

public struct UIViewStyle<T> {
    private let styling: (T) -> ()
    
    public init(styling: @escaping (T) -> ()) {
        self.styling = styling
    }
    
    public static func compose(_ styles: UIViewStyle<T>...) -> UIViewStyle<T> {
        return UIViewStyle { view in
            for style in styles {
                style.styling(view)
            }
        }
    }
    
    public func apply(to view: T) {
        styling(view)
    }
}
