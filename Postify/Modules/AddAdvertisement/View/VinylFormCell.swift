//
//  VinylFormCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 07/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Visually
import UIKit
import Reusable

protocol AdvertisementDetailedInfoProvider: class {
    func getEnteredDetailedInfo() -> AdvertisementDetailedInfo
}

class VinylFormCell: UITableViewCell, Reusable {
    private let authorTitleLabel = UILabel()
    private let authorTextField = UITextField()
    private let albumTitleLabel = UILabel()
    private let albumTextField = UITextField()
    private var enteredAlbum: String?
    private var enteredAuthor: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: Vinyl?) {
        if enteredAlbum == nil {
            albumTextField.text = viewModel?.album
        }
        
        if enteredAuthor == nil {
            authorTextField.text = viewModel?.author
        }
    }
}

extension VinylFormCell: AdvertisementDetailedInfoProvider {
    func getEnteredDetailedInfo() -> AdvertisementDetailedInfo {
        let author = authorTextField.text ?? ""
        let album = albumTextField.text ?? ""
        let vinyl = Vinyl(author: author, album: album)
        return .vinyl(vinyl)
    }
}

private extension VinylFormCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        setDefaultTexts()
        setDelegate()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(authorTitleLabel,
                                authorTextField,
                                albumTitleLabel,
                                albumTextField)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-16-authorTitleLabel-16-|)
        c += H(|-16-authorTextField-16-|)
        c += H(|-16-albumTitleLabel-16-|)
        c += H(|-16-albumTextField-16-|)
        c += V(|-16-authorTitleLabel-16-authorTextField-16-albumTitleLabel-16-albumTextField-16-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.blackSemibold17TextStyle().apply(to: authorTitleLabel)
        Styles.blackRegular17BorderTextFieldStyle().apply(to: authorTextField)
        Styles.blackSemibold17TextStyle().apply(to: albumTitleLabel)
        Styles.blackRegular17BorderTextFieldStyle().apply(to: albumTextField)
    }
    
    func setDefaultTexts() {
        authorTitleLabel.text = LocalizedStrings.author
        authorTextField.placeholder = LocalizedStrings.typeAuthor
        albumTitleLabel.text = LocalizedStrings.album
        albumTextField.placeholder = LocalizedStrings.typeAlbum
    }
    
    func setDelegate() {
        authorTextField.tag = 0
        albumTextField.tag = 1
        authorTextField.delegate = self
        albumTextField.delegate = self
    }
}

extension VinylFormCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let range = Range(range, in: textField.text ?? "")!
        let newText = textField.text?.replacingCharacters(in: range, with: string)
        switch textField.tag {
        case 0:
            enteredAuthor = newText
        case 1:
            enteredAlbum = newText
        default:
            break
        }
        
        return true
    }
}
