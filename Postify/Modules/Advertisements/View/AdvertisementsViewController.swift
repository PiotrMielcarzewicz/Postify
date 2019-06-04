//
//  AdvertisementsViewController.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Reusable

protocol AdvertisementsView: ProgressShowable, AlertShowable {
    func hydrate(with elements: [AdvertisementsStackElement])
}

class AdvertisementsViewController: UITableViewController, AdvertisementsView {
    private var allElements: [AdvertisementsStackElement] = []
    private var filteredElements: [AdvertisementsStackElement]?
    private var latestQuery: String?
    var presenter: AdvertisementsPresenter!
    var elements: [AdvertisementsStackElement] {
        if let filteredElements = filteredElements {
            return filteredElements
        } else {
            return allElements
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func hydrate(with elements: [AdvertisementsStackElement]) {
        self.allElements = elements
        filteredElements = nil
        latestQuery = nil
        navigationItem.searchController?.searchBar.text = nil
        tableView.endEditing(true)
        tableView.reloadData()
    }
}

extension AdvertisementsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .emptyDataSet(viewModel):
            tableView.isScrollEnabled = false
            return emptyDataSetCell(with: viewModel, at: indexPath)
        case let .advertisement(advertisement):
            tableView.isScrollEnabled = true
            return advertisementCell(with: advertisement, at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let element = elements[indexPath.row]
        switch element {
        case .emptyDataSet:
            return UITableView.automaticDimension
        case .advertisement:
            return 120
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let element = elements[indexPath.row]
        switch element {
        case .emptyDataSet:
            break
        case let .advertisement(advertisement):
            presenter.handleAdvertisementTapped(advertisement)
        }
    }
}

private extension AdvertisementsViewController {
    func advertisementCell(with viewModel: Advertisement, at indexPath: IndexPath) -> UITableViewCell {
        let cell: AdvertisementCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
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

private extension AdvertisementsViewController {
    func setup() {
        applyStyling()
        setTitle()
        setupTableView()
        setupNavigationItem()
        setupSearchController()
        setupRefreshControl()
        registerReusables()
    }
    
    func setTitle() {
        navigationItem.title = LocalizedStrings.browse
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func applyStyling() {
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .pst_x64112B
        navigationController?.view.backgroundColor = .white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
    }
    
    func setupTableView() {
        navigationController?.navigationBar.backgroundColor = .white
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        edgesForExtendedLayout = .top
    }
    
    func registerReusables() {
        tableView.register(cellType: AdvertisementCell.self)
        tableView.register(cellType: EmptyDataSetCell.self)
    }
    
    func setupNavigationItem() {
        let filterButton = UIBarButtonItem(title: LocalizedStrings.filter,
                                           style: .done,
                                           target: self,
                                           action: #selector(didTapFilter))
        let sortButton = UIBarButtonItem(title: LocalizedStrings.sort,
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapSort))
        navigationItem.setLeftBarButton(filterButton, animated: true)
        navigationItem.setRightBarButton(sortButton, animated: true)
    }    
    
    func showActionSheet() {
        let actions = presenter.getAvailableSortActions()
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actions.map { action -> UIAlertAction in
            return UIAlertAction(title: action.title, style: .default, handler: { [weak self] alertAction in
                self?.presenter.handleSortActionTapped(action)
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
    
    @objc func didTapFilter() {
        presenter.handleFilterButtonTapped()
    }
    
    @objc func didTapSort() {
        showActionSheet()
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        
        searchController.searchBar.subviews.forEach { view in
            view.subviews.forEach { potentialTextField in
                if let textField = potentialTextField as? UITextField, let view = textField.subviews.first {
                    textField.tintColor = .black
                    view.backgroundColor = .white
                    view.layer.cornerRadius = 10
                    view.clipsToBounds = true
                }
            }
        }
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
                        self.presenter.viewDidLoad()
                    }
                }
            }
        }
    }
}

extension AdvertisementsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = latestQuery
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        latestQuery = searchBar.text
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredElements = [.emptyDataSet(.loading)]
        tableView.reloadData()
        latestQuery = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reload), object: nil)
        self.perform(#selector(reload), with: nil, afterDelay: 0.25)
    }
    
    @objc func reload() {
        guard let latestQuery = latestQuery else {
            filteredElements = nil
            tableView.reloadData()
            return
        }
        
        if latestQuery.isEmpty {
            filteredElements = nil
        } else {
            filteredElements = presenter.filteredElements(searchText: latestQuery, elements: allElements)
        }
        
        tableView.reloadData()
    }
}
