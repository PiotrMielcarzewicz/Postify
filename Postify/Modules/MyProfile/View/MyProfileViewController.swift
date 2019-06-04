//
//  MyProfileViewController.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Reusable

protocol MyProfileView: AlertShowable, ProgressShowable {
    func hydrate(with user: User)
}

class MyProfileViewController: UITableViewController, MyProfileView {
    private var user: User!
    private var myProfileFormDelegate: MyProfileFormDelegate!
    var presenter: MyProfilePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    func hydrate(with user: User) {
        self.user = user
        tableView.reloadData()
    }
}

extension MyProfileViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyProfileFormCell = tableView.dequeueReusableCell(for: indexPath)
        myProfileFormDelegate = cell
        cell.hydrate(with: user)
        return cell
    }
}

private extension MyProfileViewController {
    func setup() {
        setupTableView()
        setupKeyboardDismissGesture()
        setupUpdateButton()
        setTitle()
        registerReusables()
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
    }
    
    func setupUpdateButton() {
        let createButton = UIBarButtonItem(title: LocalizedStrings.update,
                                           style: .done,
                                           target: self,
                                           action: #selector(didTapUpdate))
        navigationItem.setRightBarButton(createButton, animated: true)
    }
    
    @objc func didTapUpdate() {
        let user = myProfileFormDelegate.getUser()
        presenter.handleUpdateButtonTapped(with: user)
    }
    
    func setTitle() {
        title = LocalizedStrings.myProfileEdit
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func registerReusables() {
        tableView.register(cellType: MyProfileFormCell.self)
    }
}
