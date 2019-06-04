//
//  MapCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Visually
import Reusable
import UIKit
import MapKit
import CoreLocation

class Annotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

class MapCell: UITableViewCell, Reusable {
    private let mapView = MKMapView()
    private let emptyView = UIView()
    private var annotation: Annotation!
    private var didLayoutMap = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: CLLocationCoordinate2D) {
        annotation = Annotation(coordinate: viewModel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !didLayoutMap {
            setupMap()
            mapView.addAnnotation(annotation)
            mapView.setCenter(annotation.coordinate, animated: false)
            didLayoutMap = true
        }
    }
}

private extension MapCell {
    func setup() {
        selectionStyle = .none
        contentView.addSubview(emptyView)
        contentView.prepareSubviewsForAutolayout()
        emptyView.backgroundColor = .clear
        var c: [NSLayoutConstraint] = []
        c += H(|-emptyView-|)
        c += V(|-emptyView[160]-|)
        NSLayoutConstraint.activate(c)
    }
    
    func setupMap() {
        contentView.addSubviews(mapView)
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-mapView-|)
        c += V(|-mapView[160]-|)
        NSLayoutConstraint.activate(c)
    }
}
