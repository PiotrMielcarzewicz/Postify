//
//  SettingsViewController.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 03/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Reusable

protocol SettingsView: AlertShowable, ProgressShowable {
    func hydrate(with options: [SettingsOption])
    func dismiss()
    func present(_ view: UIViewController)
    func push(_ view: UIViewController)
}

class SettingsViewController: UITableViewController, SettingsView {
    private var options: [SettingsOption] = []
    var presenter: SettingsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    func hydrate(with options: [SettingsOption]) {
        self.options = options
        tableView.reloadData()
    }
    
    func dismiss() {
        tabBarController?.dismiss(animated: true)
    }
    
    func present(_ view: UIViewController) {
        tabBarController?.present(view, animated: true)
    }
    
    func push(_ view: UIViewController) {
        navigationController?.pushViewController(view, animated: true)
    }
}

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]
        switch option {
        case let .phoneVisibility(isOn):
            return switchableOptionCell(with: option, isOn: isOn, at: indexPath)
        default:
            return optionCell(with: option, at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = options[indexPath.row]
        presenter.userDidTapSettingsOption(option)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsViewController {
    func optionCell(with viewModel: SettingsOption, at indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel)
        return cell
    }
    
    func switchableOptionCell(with viewModel: SettingsOption, isOn: Bool, at indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsSwitchCell = tableView.dequeueReusableCell(for: indexPath)
        cell.hydrate(with: viewModel, isOn: isOn) { [weak self] isOn in
            self?.presenter.didSwitchToggle(for: viewModel, isOn: isOn)
        }
        return cell
    }
}

private extension SettingsViewController {
    func setup() {
        setTitle()
        setupTableView()
        registerReusables()
        applyStyling()
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
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorInset.left = 0
    }
    
    func registerReusables() {
        tableView.register(cellType: SettingsCell.self)
        tableView.register(cellType: SettingsSwitchCell.self)
    }
    
    func setTitle() {
        navigationItem.title = LocalizedStrings.settings
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
