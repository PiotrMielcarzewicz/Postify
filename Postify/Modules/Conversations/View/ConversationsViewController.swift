//
//  ConversationsViewController.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import FirebaseDatabase

protocol ConversationsView: ProgressShowable, AlertShowable {
    func hydrate(with elements: [ConversationsStackElement])
}

class ConversationsViewController: UITableViewController, ConversationsView {
    private var elements: [ConversationsStackElement] = []
    var presenter: ConversationsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func hydrate(with elements: [ConversationsStackElement]) {
        self.elements = elements
        tableView.reloadData()
    }
}

extension ConversationsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .emptyDataSet(viewModel):
            return emptyDataSetCell(with: viewModel, at: indexPath)
        case let .conversation(viewModel):
            return conversationCell(with: viewModel, at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let element = elements[indexPath.row]
        switch element {
        case .emptyDataSet:
            return UITableView.automaticDimension
        case .conversation:
            return 80
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let element = elements[indexPath.row]
        switch element {
        case let .conversation(viewModel):
            presenter.handleConversationTapped(conversationId: viewModel.conversationId,
                                               otherConversationId: viewModel.otherConversationId,
                                               otherUserId: viewModel.otherUserId,
                                               messagesId: viewModel.messagesId,
                                               advertisementId: viewModel.advertisementId)
        case .emptyDataSet:
            break
        }
    }
}

private extension ConversationsViewController {
    func conversationCell(with viewModel: ConversationViewModel, at indexPath: IndexPath) -> UITableViewCell {
        let cell: ConversationCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel) { [weak self] in
            self?.presenter.handleDetailsButtonTapped(with: viewModel.advertisement)
        }
        return cell
    }
    
    func emptyDataSetCell(with viewModel: EmptyDataSetViewModel, at indexPath: IndexPath) -> UITableViewCell {
        let cell: EmptyDataSetCell = tableView.dequeueReusableCell(for: indexPath)
        let height = tableView.frame.height -
            tabBarController!.tabBar.frame.height -
            navigationController!.navigationBar.frame.height
        cell.hydrate(with: viewModel, height: height)
        return cell
    }
}

private extension ConversationsViewController {
    func setup() {
        applyStyling()
        setTitle()
        setupTableView()
        setupRefreshControl()
        registerReusables()
    }
    
    func setTitle() {
        navigationItem.title = LocalizedStrings.conversations
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func applyStyling() {
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .pst_x64112B
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
    }
    
    func setupTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func registerReusables() {
        tableView.register(cellType: ConversationCell.self)
        tableView.register(cellType: EmptyDataSetCell.self)
    }
    
    @objc func didTapAdd() {
        let controller = AddAdvertisementViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self,
                                 action: #selector(didRefreshView),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func didRefreshView() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
                    DispatchQueue.main.async {
                        self.presenter.handleRefresh()
                    }
                }
            }
        }
    }
}
