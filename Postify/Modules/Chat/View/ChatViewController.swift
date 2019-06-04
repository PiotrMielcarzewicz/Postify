//
//  ChatViewController.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import SlackTextViewController

protocol ChatView: ProgressShowable, AlertShowable {
    func hydrate(with elements: [ChatStackElement])
    func setTitle(_ tile: String)
    func activateDetailsButton()
    func activateSendButton()
}

class ChatViewController: SLKTextViewController, ChatView {
    private var elements: [ChatStackElement] = []
    var presenter: ChatPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    func hydrate(with elements: [ChatStackElement]) {
        self.elements = elements
        tableView?.reloadData()
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func activateDetailsButton() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func activateSendButton() {
        self.rightButton.isEnabled = true
    }
}

extension ChatViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .emptyDataSet(viewModel):
            return emptyDataSetCell(with: viewModel, at: indexPath)
        case let .textMessage(viewModel):
            return textMessageCell(with: viewModel, at: indexPath)
        case let .adminMessage(viewModel, isFullscreen):
            return adminMessageCell(with: viewModel, isFullscreen: isFullscreen, at: indexPath)
        }
    }
    
    override class func tableViewStyle(for decoder: NSCoder) -> UITableView.Style {
        return .plain
    }
    
    override func didPressRightButton(_ sender: Any?) {
        guard let message = textView.text else { return }
        presenter.handleSendButtonTapped(with: message)
        textView.text = ""
    }
}

private extension ChatViewController {
    func emptyDataSetCell(with viewModel: EmptyDataSetViewModel, at indexPath: IndexPath) -> UITableViewCell {
        let cell: EmptyDataSetCell = tableView!.dequeueReusableCell(for: indexPath)
        let height = tableView!.frame.height
        cell.transform = tableView!.transform
        cell.hydrate(with: viewModel, height: height)
        return cell
    }
    
    func textMessageCell(with viewModel: MessageViewModel, at indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageCell = tableView!.dequeueReusableCell(for: indexPath)
        cell.transform = tableView!.transform
        cell.hydrate(with: viewModel)
        return cell
    }
    
    func adminMessageCell(with viewModel: String, isFullscreen: Bool, at indexPath: IndexPath) -> UITableViewCell {
        let cell: AdminMessageCell = tableView!.dequeueReusableCell(for: indexPath)
        cell.transform = tableView!.transform
        if isFullscreen {
            cell.hydrate(with: viewModel, height: tableView!.frame.height)
        } else {
            cell.hydrate(with: viewModel, height: 56)
        }
        return cell
    }
}

private extension ChatViewController {
    func setup() {
        setupRightButton()
        setupTableView()
        setPlaceholder()
        setupDetailsButton()
        setTitle()
        registerReusables()
    }

    func setupRightButton() {
        self.rightButton.setTitle("", for: .normal)
        self.rightButton.setImage(#imageLiteral(resourceName: "ic_send"), for: .normal)
        self.rightButton.tintColor = .white
        self.rightButton.isEnabled = false
        textInputbar.backgroundColor = .pst_x64112B
    }

    func setupTableView() {
        tableView?.separatorStyle = .none
    }

    func setPlaceholder() {
        self.textView.placeholder = LocalizedStrings.message
    }

    func setTitle() {
        navigationItem.largeTitleDisplayMode = .never
    }

    func registerReusables() {
        tableView?.register(cellType: MessageCell.self)
        tableView?.register(cellType: AdminMessageCell.self)
        tableView?.register(cellType: EmptyDataSetCell.self)
    }
    
    func setupDetailsButton() {
        let addButton = UIBarButtonItem(title: LocalizedStrings.details,
                                        style: .plain,
                                        target: self,
                                        action: #selector(didTapDetailsButton))
        navigationItem.setRightBarButton(addButton, animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func didTapDetailsButton() {
        presenter.handleDetailsButtonTapped()
    }
}
