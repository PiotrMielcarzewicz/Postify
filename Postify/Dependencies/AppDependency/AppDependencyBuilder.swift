//
//  AppDependencyBuilder.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 02/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

struct AppDependencyBuilder {
    func build() -> AppDependency {
        let userStorage = UserStorageServiceImp()
        let userService = UserServiceImp(userStorage: userStorage)
        let categoryService = CategoryServiceImp()
        let validator = ValidatorImp()
        let imageUploadService = ImageUploadServiceImp()
        let advertisementsService = AdvertisementsServiceImp()
        let appDateFormatter = AppDateFormatterImp()
        let geolocationService = GeolocationServiceImp()
        let conversationsService = ConversationsServiceImp(dateFormatter: appDateFormatter)
        
        return AppDependency(userService: userService,
                             categoryService: categoryService,
                             validator: validator,
                             imageUploadService: imageUploadService,
                             advertisementsService: advertisementsService,
                             appDateFormatter: appDateFormatter,
                             geolocationService: geolocationService,
                             conversationsService: conversationsService)
    }
}
