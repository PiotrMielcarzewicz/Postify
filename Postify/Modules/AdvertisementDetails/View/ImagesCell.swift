//
//  ImagesCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import Visually
import ImageSlideshow

protocol ImagesCellDelegate: class {
    func handleImageSlideshowTapped(_ slideshow: ImageSlideshow)
}

class ImagesCell: UITableViewCell, Reusable {
    private let slideshow = ImageSlideshow()
    private weak var delegate: ImagesCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: [URL], delegate: ImagesCellDelegate) {
        self.delegate = delegate
        let source = viewModel.map { KingfisherSource(url: $0) }
        slideshow.setImageInputs(source)
    }
}

private extension ImagesCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        configureSubviews()
        configureTarget()
    }
    
    func addSubviews() {
        contentView.addSubview(slideshow)   
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-slideshow-|)
        c += V(|-slideshow[UIScreen.main.bounds.width * 9/16]-|)
        NSLayoutConstraint.activate(c)
    }
    
    func configureSubviews() {
        slideshow.backgroundColor = .black
    }
    
    func configureTarget() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(didTapImageSlideshow))
        slideshow.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapImageSlideshow() {
        delegate?.handleImageSlideshowTapped(slideshow)
    }
}
