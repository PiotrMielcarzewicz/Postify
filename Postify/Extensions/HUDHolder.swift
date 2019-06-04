//
//  HUDHolder.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import JGProgressHUD

class HUDHolder {
    var hud: JGProgressHUD?
    static var shared = HUDHolder()
}
