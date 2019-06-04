//
//  SignUpViewController.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import Visually

protocol SignUpView: ProgressShowable, AlertShowable {
    func hydrate(with elements: [SignUpStackElement])
}

class SignUpViewController: UITableViewController, SignUpView {
    private var elements: [SignUpStackElement] = []
    private var userFormDelegate: UserFormDelegate!
    var presenter: SignUpPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyStyling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        applyDefaultStyling()
    }
    
    func hydrate(with elements: [SignUpStackElement]) {
        self.elements = elements
        tableView.reloadData()
    }
}

extension SignUpViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        
        switch element {
        case let .title(viewModel):
            return titleCell(with: viewModel, at: indexPath)
        case .form:
            return userFormCell(at: indexPath)
        }
    }
}

private extension SignUpViewController {
    func titleCell(with viewModel: TitleCellViewModel, at indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
        return cell
    }
    
    func userFormCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell: UserFormCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate()
        userFormDelegate = cell
        return cell
    }
}

private extension SignUpViewController {
    func setup() {
        setupTableView()
        setupKeyboardDismissGesture()
        setupCreateButton()
        registerReusables()
    }
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.backgroundView = getAppThemeBackgroundView()
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
    }
    
    func registerReusables() {
        tableView.register(cellType: TitleCell.self)
        tableView.register(cellType: UserFormCell.self)
    }
    
    func setupCreateButton() {
        let createButton = UIBarButtonItem(title: LocalizedStrings.create,
                                          style: .done,
                                          target: self,
                                          action: #selector(didTapCreate))
        navigationItem.setRightBarButton(createButton, animated: true)
    }
    
    @objc func didTapCreate() {
        let form = userFormDelegate.getUserForm()
        presenter.handleCreateButtonTapped(with: form)
    }
    
    func applyStyling() {
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .pst_x3B171E
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .pst_x3B171E
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
    }
    
    func applyDefaultStyling() {
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
    }
}
