//
//  GeolocationService.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import CoreLocation

/// sourcery: AutoDependency
protocol GeolocationService {
    func getLocation(of address: String, completion: @escaping Completion<CLLocationCoordinate2D?>)
}

class GeolocationServiceImp: GeolocationService {
    private let geocoder = CLGeocoder()
    
    func getLocation(of address: String, completion: @escaping Completion<CLLocationCoordinate2D?>) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let coordinate = placemarks?.first?.location?.coordinate {
                completion(.success(coordinate))
            } else {
                completion(.success(nil))
            }
        }
    }
}
