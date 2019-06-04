//
//  Router.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 02/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

enum TransitioningOptions {
    case fade
}

struct RoutingOptions: OptionSet {
    let rawValue: Int
    
    static let removeDisappearingControllerFromNavigationStack = RoutingOptions(rawValue: 0b1)
}

class Router: NSObject, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    let builderProvider: BuilderProvider
    unowned let viewController: UIViewController
    
    init(viewController: UIViewController, builderProvider: BuilderProvider) {
        self.viewController = viewController
        self.builderProvider = builderProvider
        super.init()
    }
    
    private var routingOptions: RoutingOptions = []
    private var completion: ((UINavigationController) -> ())?
    func show(_ controller: UIViewController,
              options: RoutingOptions = [],
              completion: ((UINavigationController) -> ())? = nil) {
        self.completion = completion
        self.routingOptions = options
        viewController.navigationController?.delegate = self
        viewController.show(controller, sender: nil)
    }
    
    private var transitioningOptions: TransitioningOptions?
    func present(_ controller: UIViewController, options: TransitioningOptions? = nil) {
        self.transitioningOptions = options
        if options != nil {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
        }
        viewController.present(controller, animated: true, completion: nil)
    }
    
    func tryPopViewController() {
        viewController.navigationController?.popViewController(animated: true)
    }
}
