//
//  MyAdvertisementsViewController.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 12/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import FirebaseDatabase

protocol MyAdvertisementView: ProgressShowable, AlertShowable {
    func hydrate(with elements: [MyAdvertisementsStackElement])
}

class MyAdvertisementsViewController: UITableViewController, MyAdvertisementView {
    private var elements: [MyAdvertisementsStackElement] = []
    var presenter: MyAdvertisementsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func hydrate(with elements: [MyAdvertisementsStackElement]) {
        self.elements = elements
        tableView.reloadData()
    }
}

extension MyAdvertisementsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .advertisement(advertisement):
            tableView.isScrollEnabled = true
            return advertisementCell(with: advertisement, at: indexPath)
        case let .emptyDataSet(viewModel):
            tableView.isScrollEnabled = false
            return emptyDataSetCell(with: viewModel, at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .advertisement:
            return indexPath.row == (elements.count - 1) ? 144 : 128
        case .emptyDataSet:
            return UITableView.automaticDimension
        }
    }
}

private extension MyAdvertisementsViewController {
    func advertisementCell(with viewModel: Advertisement, at indexPath: IndexPath) -> UITableViewCell {
        let cell: MyAdvertisementCell = tableView.dequeueReusableCell(for: indexPath)
        let bottomInset: CGFloat = (indexPath.row == (elements.count - 1)) ? 16 : 0
        let insets = UIEdgeInsets(top: 16, left: 12, bottom: bottomInset, right: 12)
        cell.setInsets(insets)
        let cellHeight: CGFloat = indexPath.row == (elements.count - 1) ? 144 : 128
        let cardHeight: CGFloat = cellHeight - bottomInset - 16
        let cardFrame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: cardHeight)
        cell.view.hydrate(with: viewModel, frame: cardFrame) { [weak self] in
            self?.showActionSheet(for: viewModel)
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

private extension MyAdvertisementsViewController {
    func setup() {
        applyStyling()
        setTitle()
        setupTableView()
        registerReusables()
        setupAddButton()
    }
    
    func setupAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(didTapAdd))
        navigationItem.setRightBarButton(addButton, animated: true)
    }
    
    func setTitle() {
        navigationItem.title = LocalizedStrings.myAdvertisements
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
        edgesForExtendedLayout = .top
    }
    
    func registerReusables() {
        tableView.register(cellType: MyAdvertisementCell.self)
        tableView.register(cellType: EmptyDataSetCell.self)
    }
    
    @objc func didTapAdd() {
        presenter.handleAddButtonTapped()
    }
    
    func showActionSheet(for viewModel: Advertisement) {
        let actions = presenter.getAvailableActions(for: viewModel.id)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actions.map { action -> UIAlertAction in
            let style: UIAlertAction.Style = {
                switch action {
                case .close:
                    return .destructive
                default:
                    return .default
                }
            }()
            return UIAlertAction(title: action.title, style: style, handler: { [weak self] alertAction in
                self?.presenter.handleAdvertisementAction(action, id: viewModel.id)
            })
        }.forEach { actionSheet.addAction($0) }
        
        present(actionSheet, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(self.dismissAlertController))
            actionSheet.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }
        
    @objc func dismissAlertController() {
        dismiss(animated: true, completion: nil)
    }
}
