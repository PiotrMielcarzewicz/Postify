//
//  CategorySelectorViewController.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 09/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

protocol CategorySelectorView: AlertShowable {
    func hydrate(with elements: [CategorySelectorStackElement])
    func setTitle(_ title: String)
}

class CategorySelectorViewController: UITableViewController, CategorySelectorView {
    private var elements: [CategorySelectorStackElement] = []
    var presenter: CategorySelectorPresenter!
    let s = ImageUploadServiceImp()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
        
        s.uploadImage(#imageLiteral(resourceName: "ic_settings"), id: "123") { result in
            print("dun: ", result)
        }
    }
    
    func hydrate(with elements: [CategorySelectorStackElement]) {
        self.elements = elements
        tableView.reloadData()
    }
    
    func setTitle(_ title: String) {
        self.title = title
        restoreBackButton()
    }
}

extension CategorySelectorViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .category(viewModel):
            tableView.isScrollEnabled = true
            return categoryCell(with: viewModel, at: indexPath)
        case let .emptyDataSet(viewModel):
            tableView.isScrollEnabled = false
            return emptyDataSetCell(with: viewModel, at: indexPath)
        }
    }
    
    override internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let element = elements[indexPath.row]
        switch element {
        case let .category(viewModel):
            presenter.handleCategoryTapped(with: viewModel)
        case .emptyDataSet:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let element = elements[indexPath.row]
        switch element {
        case .category:
            return 60
        case .emptyDataSet:
            return UITableView.automaticDimension
        }
    }
}

private extension CategorySelectorViewController {
    func categoryCell(with viewModel: CategoryViewModel, at indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
        return cell
    }
    
    func emptyDataSetCell(with viewModel: EmptyDataSetViewModel, at indexPath: IndexPath) -> UITableViewCell {
        let cell: EmptyDataSetCell = tableView.dequeueReusableCell(for: indexPath)
        let height = tableView.frame.height - navigationController!.navigationBar.frame.height
        cell.hydrate(with: viewModel, height: height)
        return cell
    }
}

private extension CategorySelectorViewController {
    func setup() {
        setupTableView()
        setupCloseButton()
        setTitle()
        registerReusables()
        applyStyling()
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
    }
    
    func setupCloseButton() {
        let createButton = UIBarButtonItem(title: LocalizedStrings.close,
                                           style: .done,
                                           target: self,
                                           action: #selector(didTapClose))
        navigationItem.setLeftBarButton(createButton, animated: true)
    }
    
    @objc func didTapClose() {
        presenter.handleCloseTapped()
    }
    
    func setTitle() {
        title = LocalizedStrings.selectCategory
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func registerReusables() {
        tableView.register(cellType: CategoryCell.self)
        tableView.register(cellType: EmptyDataSetCell.self)
    }
    
    func applyStyling() {
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .pst_x64112B
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
    }
    
    func restoreBackButton() {
        navigationItem.leftBarButtonItem = nil
    }
}
