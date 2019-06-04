//
//  AdvertisementCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Reusable
import Visually
import UIKit

class MyAdvertisementCell: InsettedTableViewCell, Reusable {
    private(set) lazy var view = AdvertisementView()
    private let shadowView = UIView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override var viewToPinToInsets: UIView {
        return view
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupShadowView()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupShadowView() {
        contentView.insertSubview(shadowView, at: 0)
        contentView.prepareSubviewsForAutolayout()
        var c: [NSLayoutConstraint] = []
        c += [shadowView.leftAnchor.constraint(equalTo: view.leftAnchor),
              shadowView.rightAnchor.constraint(equalTo: view.rightAnchor),
              shadowView.topAnchor.constraint(equalTo: view.topAnchor),
              shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(c)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = 10
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius = 2
    }
}

class AdvertisementView: UIView {
    private let dateFormatter = AppDateFormatterImp()
    private let itemImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dummyTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    private let dateLabel = UILabel()
    private let blurEffect = UIBlurEffect(style: .dark)
    private lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    private lazy var vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
    private lazy var vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
    private let archivedLabel = UILabel()
    private let moreButton = UIButton(type: .system)
    private let separator = Separator()
    private var onMoreTapped: (() -> ())?
    private var isArchived: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: Advertisement, frame: CGRect, onMoreTapped: @escaping () -> ()) {
        self.onMoreTapped = onMoreTapped
        titleLabel.text = viewModel.title
        descriptionLabel.text = "asjdl sajo hasou hyfiuasiuf asiuh fiui fiadh ifhsaiu iuashfiuhsaiud isah diuashiud aisuh dasiudhas iudiuash ihasid iash idashi hiashidu asiudh aisuhd iasiudas iu"//viewModel.description
        itemImageView.setImage(with: viewModel.imageURLs.first!)
        dateLabel.text = dateFormatter.date(from: viewModel.timestamp, template: .dayMonthYear)
        if viewModel.price != 0 {
            priceLabel.text = "$\(viewModel.price)"
        } else {
            priceLabel.text = LocalizedStrings.free
        }
        
        isArchived = viewModel.isArchived
        if viewModel.isArchived {
            blurEffectView.frame = frame
            vibrancyView.frame = blurEffectView.contentView.bounds
            vibrancyView.contentView.addSubview(archivedLabel)
            archivedLabel.frame = vibrancyView.contentView.bounds
            blurEffectView.contentView.addSubview(vibrancyView)
            insertSubview(blurEffectView, at: 6)
            Styles.whiteBold30TextStyle().apply(to: moreButton)
        } else {
            blurEffectView.removeFromSuperview()
            archivedLabel.removeFromSuperview()
            vibrancyView.removeFromSuperview()
            Styles.x64112BBold30TextStyle().apply(to: moreButton)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isArchived {
            blurEffectView.frame = bounds
            vibrancyView.frame = blurEffectView.contentView.bounds
            vibrancyView.contentView.addSubview(archivedLabel)
            archivedLabel.frame = vibrancyView.contentView.bounds
            blurEffectView.contentView.addSubview(vibrancyView)
            insertSubview(blurEffectView, at: 6)
        } else {
            blurEffectView.removeFromSuperview()
            archivedLabel.removeFromSuperview()
            vibrancyView.removeFromSuperview()
        }
    }
}

private extension AdvertisementView {
    func setup() {
        addSubviews()
        prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        configureSubviews()
        configureTargets()
    }
    
    func addSubviews() {
        addSubviews(itemImageView,
                    titleLabel,
                    dummyTitleLabel,
                    descriptionLabel,
                    priceLabel,
                    dateLabel,
                    moreButton)
    }
    
    func setupConstraints() {
        priceLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow - 1, for: .vertical)
        var c: [NSLayoutConstraint] = []
        c += H(|-itemImageView[120]-8-titleLabel->=8-priceLabel-8-|)
        c += H(itemImageView-8-descriptionLabel->=8-|)
        c += H(itemImageView-8-dateLabel->=8-moreButton-8-|)
        c += V(|-itemImageView-|)
        c += V(|-8-titleLabel-descriptionLabel->=0-moreButton-|)
        c += [dateLabel.centerYAnchor.constraint(equalTo: moreButton.centerYAnchor, constant: 0)]
        c += [priceLabel.centerYAnchor.constraint(equalTo: dummyTitleLabel.centerYAnchor, constant: 0)]
        c += V(|-8-dummyTitleLabel)
        c += H(itemImageView-8-dummyTitleLabel)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        backgroundColor = .white
        Styles.blackSemibold18TextStyle().apply(to: titleLabel)
        Styles.blackSemibold18TextStyle().apply(to: dummyTitleLabel)
        Styles.blackRegular14LabelStyle().apply(to: descriptionLabel)
        Styles.x64112BSemibold15TextStyle().apply(to: priceLabel)
        Styles.x64112BBold30TextStyle().apply(to: moreButton)
        Styles.grayLight13TextStyle().apply(to: dateLabel)
        Styles.x64112BBold27TextStyle().apply(to: archivedLabel)
        Styles.cardStyle().apply(to: self)
        blurEffectView.alpha = 0.9
        archivedLabel.alpha = 0.5
        archivedLabel.textAlignment = .center
    }
    
    func configureSubviews() {
        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 0
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.layer.masksToBounds = true
        itemImageView.clipsToBounds = true
        clipsToBounds = true
        moreButton.setTitle(LocalizedStrings.options, for: .normal)
        archivedLabel.text = LocalizedStrings.archivedCapitalized
        dateLabel.text = "27.10.2018"
        dummyTitleLabel.text = " "
    }
    
    func configureTargets() {
        moreButton.addTarget(self,
                             action: #selector(didTapMoreButton),
                             for: .touchUpInside)
    }
    
    @objc func didTapMoreButton() {
        onMoreTapped?()
    }
}

extension LocalizedStrings {
    static let free = NSLocalizedString("Free", comment: "")
}
