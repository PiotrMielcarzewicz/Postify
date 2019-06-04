//
//  LoggedInViewController.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 22/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoggedInViewController: UIViewController {
    private let email: String
    private let advertisementsService = AdvertisementsServiceImp(databaseReference: Database.database().reference().child("Advertisements"))
    
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc func didTapLogout() {
//        do {
//            try Auth.auth().signOut()
//            dismiss(animated: true)
//        } catch let error {
//            showAlert(for: error)
//        }
    }
}

private extension LoggedInViewController {
    func setup() {
        view.backgroundColor = .gray
        //
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = NSLocalizedString("Logged in from \n\(email)", comment: "")
        view.addSubview(label)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        //
        let button = UIButton(type: .system)
        button.setTitle("Fetch advertisements", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        //
        let constraints = [label.topAnchor.constraint(equalTo: view.topAnchor),
                           label.leftAnchor.constraint(equalTo: view.leftAnchor),
                           label.rightAnchor.constraint(equalTo: view.rightAnchor),
                           label.bottomAnchor.constraint(equalTo: button.topAnchor),
                           button.leftAnchor.constraint(equalTo: view.leftAnchor),
                           button.rightAnchor.constraint(equalTo: view.rightAnchor),
                           button.heightAnchor.constraint(equalToConstant: 50),
                           button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
}
