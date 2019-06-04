//
//  AdvertisementDetailsViewController.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import ImageSlideshow

protocol AdvertisementDetailsView: ProgressShowable, AlertShowable {
    func hydrate(with elements: [AdvertisementDetailsStackElement])
}

class AdvertisementDetailsViewController: UITableViewController, AdvertisementDetailsView {
    private var elements: [AdvertisementDetailsStackElement] = []
    var presenter: AdvertisementDetailsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    func hydrate(with elements: [AdvertisementDetailsStackElement]) {
        self.elements = elements
        tableView.reloadData()
    }
}

extension AdvertisementDetailsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .emptyDataSet(viewModel):
            return emptyDataSetCell(with: viewModel, at: indexPath)
        case let .images(viewModel):
            return imagesCell(with: viewModel, at: indexPath)
        case let .title(viewModel):
            return titleCell(with: viewModel, at: indexPath)
        case let .description(viewModel):
            return descritpionCell(with: viewModel, at: indexPath)
        case let .detailsTitle(viewModel):
            return detailsTitleCell(with: viewModel, at: indexPath)
        case .separator:
            return separatorCell(at: indexPath)
        case let .info(viewModel):
            return infoCell(with: viewModel, at: indexPath)
        case let .map(viewModel):
            return mapCell(with: viewModel, at: indexPath)
        case let .contactButton(viewModel):
            return contactButtonCell(with: viewModel, at: indexPath)
        }
    }
}


private extension AdvertisementDetailsViewController {
    func emptyDataSetCell(with viewModel: EmptyDataSetViewModel, at indexPath: IndexPath) -> UITableViewCell {
        let cell: EmptyDataSetCell = tableView.dequeueReusableCell(for: indexPath)
        let height = tableView.frame.height
        cell.hydrate(with: viewModel, height: height)
        return cell
    }
    
    func imagesCell(with viewModel: [URL], at indexPath: IndexPath) -> UITableViewCell {
        let cell: ImagesCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel, delegate: self)
        return cell
    }
    
    func titleCell(with viewModel: String, at indexPath: IndexPath) -> UITableViewCell {
        let cell: AdvertisementTitleCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
        return cell
    }
    
    func descritpionCell(with viewModel: String, at indexPath: IndexPath) -> UITableViewCell {
        let cell: AdvertisementDescriptionCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
        return cell
    }
    
    func detailsTitleCell(with viewModel: String, at indexPath: IndexPath) -> UITableViewCell {
        let cell: ContactDetailsTitleCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
        return cell
    }
    
    func separatorCell(at indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(for: indexPath) as SeparatorCell
    }
    
    func infoCell(with viewModel: InfoViewModel, at indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
        return cell
    }
    
    func mapCell(with viewModel: CLLocationCoordinate2D, at indexPath: IndexPath) -> UITableViewCell {
        let cell: MapCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
        return cell
    }
    
    func contactButtonCell(with viewModel: ContactButtonViewModel, at indexPath: IndexPath) -> UITableViewCell {
        let cell: ContactButtonCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel) { [weak self] target in
            self?.presenter.handleContactButtonTapped(with: target)
        }
        return cell
    }
}

extension AdvertisementDetailsViewController: ImagesCellDelegate {
    func handleImageSlideshowTapped(_ slideshow: ImageSlideshow) {
        slideshow.presentFullScreenController(from: self)
    }
}

private extension AdvertisementDetailsViewController {
    func setup() {
        setTitle()
        setupTableView()
        registerReusables()
    }
    
    func setTitle() {
        title = LocalizedStrings.details
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
    }
    
    func registerReusables() {
        tableView.register(cellType: EmptyDataSetCell.self)
        tableView.register(cellType: ImagesCell.self)
        tableView.register(cellType: AdvertisementTitleCell.self)
        tableView.register(cellType: AdvertisementDescriptionCell.self)
        tableView.register(cellType: ContactDetailsTitleCell.self)
        tableView.register(cellType: SeparatorCell.self)
        tableView.register(cellType: InfoCell.self)
        tableView.register(cellType: MapCell.self)
        tableView.register(cellType: ContactButtonCell.self)
    }
}
