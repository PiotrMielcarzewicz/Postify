//
//  UIImage+.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with url: URL?, placeholder: UIImage? = nil, completion: ((UIImage?) -> ())? = nil) {
        guard let url = url else { image = placeholder; return }
        kf.setImage(with: url, placeholder: placeholder) { (image, _, _, _) in
            completion?(image)
        }
    }
}
