//
//  ForgotPasswordViewController.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

protocol ForgotPaswordView: AlertShowable, ProgressShowable {
    func hydrate(with elements: [ForgotPasswordStackElement])
    func showCloseButton()
}

class ForgotPasswordViewController: UITableViewController, ForgotPaswordView {
    private var elements: [ForgotPasswordStackElement] = []
    private var emailProvider: EmailProvider!
    var presenter: ForgotPasswordPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    func hydrate(with elements: [ForgotPasswordStackElement]) {
        self.elements = elements
        tableView.reloadData()
    }
    
    func showCloseButton() {
        applyNavBarStyling()
        let closeButton = UIBarButtonItem(title: LocalizedStrings.close,
                                          style: .done,
                                          target: self,
                                          action: #selector(didTapClose))
        navigationItem.setLeftBarButton(closeButton, animated: true)
    }
}

extension ForgotPasswordViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        
        switch element {
        case let .title(viewModel):
            return titleCell(with: viewModel, at: indexPath)
        case .emailField:
            return emailFieldCell(at: indexPath)
        case .sendButton:
            return sendButtonCell(at: indexPath)
        }
    }
}

private extension ForgotPasswordViewController {
    func titleCell(with viewModel: TitleCellViewModel, at indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
        return cell
    }
    
    func emailFieldCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell: EmailFieldCell = tableView.dequeueReusableCell(for: indexPath)
        emailProvider = cell
        return cell
    }
    
    func sendButtonCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell: ActionButtonCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate { [weak self] in
            guard let email = self?.emailProvider.getEnteredEmail() else {
                fatalError("Email shouldn't be nil here")
            }
            self?.presenter.userDidTapSend(with: email)
        }
        return cell
    }
}

private extension ForgotPasswordViewController {
    func setup() {
        setupTableView()
        registerReusables()
        setupKeyboardDismissGesture()
    }
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.backgroundView = getAppThemeBackgroundView()
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
    }
    
    func registerReusables() {
        tableView.register(cellType: TitleCell.self)
        tableView.register(cellType: EmailFieldCell.self)
        tableView.register(cellType: ActionButtonCell.self)
    }
    
    @objc func didTapClose() {
        presenter.userDidTapClose()
    }
    
    func applyNavBarStyling() {
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
