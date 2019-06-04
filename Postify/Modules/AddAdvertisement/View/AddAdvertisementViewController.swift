//
//  AddAdvertisementViewController.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 06/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import ImagePicker

protocol AddAdvertisementView: AlertShowable, ProgressShowable {
    func hydrate(with elements: [AddAdvertisementStackElement])
    func setTitle(_ title: String)
    func setRightButtonText(_ text: String)
    func didEditImages() -> Bool
}

class AddAdvertisementViewController: UITableViewController, AddAdvertisementView {
    private var elements: [AddAdvertisementStackElement] = []
    private weak var imageFormDelegate: ImageFormDelegate!
    private weak var titleProvider: TitleFormProvider!
    private weak var descriptionProvider: DescriptionFormProvider!
    private weak var categoryProvider: CategoryFormProvider!
    private weak var priceProvider: PriceFormProvider!
    private weak var detailedInfoProvider: AdvertisementDetailedInfoProvider?
    var presenter: AddAdvertisementPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    func hydrate(with elements: [AddAdvertisementStackElement]) {
        self.elements = elements
        tableView.reloadData()
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func setRightButtonText(_ text: String) {
        let rightButton = UIBarButtonItem(title: text,
                                          style: .done,
                                          target: self,
                                          action: #selector(didTapRightButton))
        navigationItem.setRightBarButton(rightButton, animated: true)
    }
    
    func didEditImages() -> Bool {
        return imageFormDelegate.didEditImages()
    }
}

extension AddAdvertisementViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .title(viewModel):
            return titleCell(with: viewModel, at: indexPath)
        case let .description(viewModel):
            return descriptionCell(with: viewModel, at: indexPath)
        case let .category(viewModel):
            return categoryCell(with: viewModel, at: indexPath)
        case let .price(viewModel):
            return priceCell(with: viewModel, at: indexPath)
        case let .images(viewModel):
            return imagesCell(with: viewModel, at: indexPath)
        case let .detailedInfo(viewModel):
            return detailedInfoCell(with: viewModel, at: indexPath)
        }
    }
}

private extension AddAdvertisementViewController {
    func titleCell(with viewModel: String?, at indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleFormCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
        titleProvider = cell
        return cell
    }
    
    func descriptionCell(with viewModel: String?, at indexPath: IndexPath) -> UITableViewCell {
        let cell: DescriptionFormCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
        descriptionProvider = cell
        return cell
    }
    
    func categoryCell(with viewModel: CategoryViewModel?, at indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryFormCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel) { [weak self] in
            self?.presenter.handleSelectedCategoryTapped { selectedViewModel in
                cell.didSelect(selectedViewModel)
            }
        }
        categoryProvider = cell
        return cell
    }
    
    func priceCell(with viewModel: Float?, at indexPath: IndexPath) -> UITableViewCell {
        let cell: PriceFormCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
        priceProvider = cell
        return cell
    }
    
    func imagesCell(with viewModel: [ImageResource]?, at indexPath: IndexPath) -> UITableViewCell {
        let cell: ImagesFormCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel) { [weak self] in
            self?.presentImagePicker()
        }
        imageFormDelegate = cell
        return cell
    }
    
    func vinylCell(with viewModel: Vinyl?, at indexPath: IndexPath) -> UITableViewCell {
        let cell: VinylFormCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
        detailedInfoProvider = cell
        return cell
    }
    
    func emptyCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell: EmptyCell = tableView.dequeueReusableCell(for: indexPath)
        detailedInfoProvider = nil
        return cell
    }
    
    func detailedInfoCell(with viewModel: AdvertisementTypeViewModel, at indexPath: IndexPath) -> UITableViewCell {
        switch viewModel {
        case let .vinyl(viewModel):
            return vinylCell(with: viewModel, at: indexPath)
        case .none:
            return emptyCell(at: indexPath)
        }
    }
}

private extension AddAdvertisementViewController {
    func setup() {
        configureTitle()
        registerReusables()
        setupTableView()
        setupKeyboardDismissGesture()
        setupNavigationItem()
    }
    
    func configureTitle() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func registerReusables() {
        tableView.register(cellType: TitleFormCell.self)
        tableView.register(cellType: DescriptionFormCell.self)
        tableView.register(cellType: PriceFormCell.self)
        tableView.register(cellType: ImagesFormCell.self)
        tableView.register(cellType: VinylFormCell.self)
        tableView.register(cellType: CategoryFormCell.self)
        tableView.register(cellType: EmptyCell.self)
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        edgesForExtendedLayout = []
    }
    
    func presentImagePicker() {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func setupNavigationItem() {
        extendedLayoutIncludesOpaqueBars = true
    }
    
    @objc func didTapRightButton() {
        let title = titleProvider.getEnteredTitle()
        let description = descriptionProvider.getEnteredDescription()
        let category = categoryProvider.getEnteredCategoryViewModel()
        let detailedInfo = detailedInfoProvider?.getEnteredDetailedInfo() ?? .none
        let price = priceProvider.getEnteredPrice()
        showLoadingHUD()
        imageFormDelegate.getImages { [weak self] result in
            self?.hideLoadingHUD()
            switch result {
            case let .success(images):
                let form = AdvertisementForm(title: title,
                                             categoryViewModel: category,
                                             description: description,
                                             price: price,
                                             images: images,
                                             detailedInfo: detailedInfo)
                self?.presenter.handleCreateButtonTapped(with: form)
            case .failure:
                self?.showAlert(.failedToProcessAdvertisement)
            }
        }
    }
}

extension AddAdvertisementViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imageFormDelegate?.hydrate(with: images)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imageFormDelegate?.hydrate(with: images)
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }    
}
