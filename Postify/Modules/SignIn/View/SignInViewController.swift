//
//  SignInViewController.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

protocol SignInView: AlertShowable, ProgressShowable {
    func hydrate(with elements: [SignInStackElement])
    func getEnteredCredentials() -> Credentials
}

class SignInViewController: UITableViewController, SignInView {
    private var elements: [SignInStackElement] = []
    private var credentialsProvider: CredentialsProvider!
    var presenter: SignInPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }

    func hydrate(with elements: [SignInStackElement]) {
        self.elements = elements
        tableView.reloadData()
    }
    
    func getEnteredCredentials() -> Credentials {
        return credentialsProvider.getEnteredCredentials()
    }
}

extension SignInViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        
        switch element {
        case let .title(viewModel):
            return titleCell(with: viewModel, at: indexPath)
        case .credentialsForm:
            return credentialsFormCell(at: indexPath)
        case .actionButtons:
            return signInActionsCell(at: indexPath)
        }
    }
}

extension SignInViewController: SignInActionsDelegate {
    func actionSelected(_ action: SignInAction) {
        presenter.userDidSelectAction(action)
    }
}

private extension SignInViewController {
    func titleCell(with viewModel: TitleCellViewModel, at indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
        return cell
    }
    
    func credentialsFormCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell: CredentialsFormCell = tableView.dequeueReusableCell(for: indexPath)
        credentialsProvider = cell
        return cell
    }
    
    func signInActionsCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell: SignInActionsCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: self)
        return cell
    }
}

private extension SignInViewController {
    func setup() {
        setupTableView()
        registerReusables()
        setupKeyboardDismissGesture()
        applyStyling()
    }
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.backgroundView = getAppThemeBackgroundView()
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
    }
    
    func registerReusables() {
        tableView.register(cellType: TitleCell.self)
        tableView.register(cellType: CredentialsFormCell.self)
        tableView.register(cellType: SignInActionsCell.self)
    }
    
    func applyStyling() {
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


//func applyStyling() {
//    //pst_x3B171E
//    extendedLayoutIncludesOpaqueBars = true
//    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//    navigationController?.navigationBar.shadowImage = UIImage()
//    navigationController?.navigationBar.isTranslucent = false
//    navigationController?.view.backgroundColor = .pst_x3B171E
//    navigationController?.navigationBar.tintColor = .white
//    navigationController?.navigationBar.barTintColor = .pst_x3B171E
//    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
//    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
//}
