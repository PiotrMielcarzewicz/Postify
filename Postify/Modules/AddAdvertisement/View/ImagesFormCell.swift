//
//  ImagesFormCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 07/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import Visually
import ImageSlideshow

protocol ImageFormDelegate: class {
    func hydrate(with viewModel: [UIImage])
    func getImages(completion: @escaping Completion<[UIImage]>)
    func didEditImages() -> Bool
}

class ImagesFormCell: UITableViewCell, Reusable {
    private let titleLabel = UILabel()
    private let selectButton = UIButton(type: .system)
    private let slideshow = ImageSlideshow()
    private var onSelect: (() -> ())?
    private var storedImages: [InputSource]?
    private var didEditSlideshowImages = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: [ImageResource]?, onSelect: @escaping (() -> ())) {
        self.onSelect = onSelect
        
        if storedImages == nil {
            if let viewModel  = viewModel {
                let source: [InputSource] = viewModel.map {
                    switch $0 {
                    case let .local(image):
                        return ImageSource(image: image)
                    case let .remote(url):
                        return KingfisherSource(url: url)
                    }
                }
                slideshow.setImageInputs(source)
                storedImages = source
            } else {
                slideshow.setImageInputs([ImageSource(image: #imageLiteral(resourceName: "placeholder"))])
                storedImages = [ImageSource(image: #imageLiteral(resourceName: "placeholder"))]
            }
        }
    }
}

extension ImagesFormCell: ImageFormDelegate {
    func didEditImages() -> Bool {
        return didEditSlideshowImages
    }
    
    func hydrate(with viewModel: [UIImage]) {
        didEditSlideshowImages = true
        let source = viewModel.map { ImageSource(image: $0) }
        slideshow.setImageInputs(source)
        storedImages = source
        
        if viewModel.isEmpty {
            slideshow.setImageInputs([ImageSource(image: #imageLiteral(resourceName: "placeholder"))])
            storedImages = [ImageSource(image: #imageLiteral(resourceName: "placeholder"))]
        }
    }
    
    func getImages(completion: @escaping Completion<[UIImage]>) {
        let imageGroup = DispatchGroup()
        var images: [UIImage] = []
        
        slideshow.images.forEach { source in
            imageGroup.enter()
            source.load(to: UIImageView(), with: { image in
                if let image = image {
                    images.append(image)
                }
                imageGroup.leave()
            })
        }
        
        imageGroup.notify(queue: .main) {
            if images.count == self.slideshow.images.count {
                completion(.success(images))
            } else {
                completion(.failure(PostifyError.missingImages))
            }
        }
    }
}

private extension ImagesFormCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        setDefaultTexts()
        configureSubviews()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(titleLabel,
                                selectButton,
                                slideshow)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-16-titleLabel-16-selectButton-16-|)
        c += H(|-slideshow-|)
        c += V(|-16-selectButton)
        c += V(|-16-titleLabel-16-slideshow[UIScreen.main.bounds.width * 9/16]-16-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.blackSemibold17TextStyle().apply(to: titleLabel)
        Styles.x64112BSemibold17TextStyle().apply(to: selectButton)
    }
    
    func setDefaultTexts() {
        titleLabel.text = LocalizedStrings.images
        selectButton.setTitle(LocalizedStrings.select, for: .normal)
    }
    
    func configureSubviews() {
        slideshow.backgroundColor = .black
        selectButton.addTarget(self, action: #selector(didTapSelect), for: .touchUpInside)
    }
    
    @objc func didTapSelect() {
        onSelect?()
    }
}
