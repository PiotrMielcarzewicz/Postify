//
//  AppDependency.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 02/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

struct AppDependency: HasUserService,
                      HasValidator,
                      HasCategoryService,
                      HasImageUploadService,
                      HasAdvertisementsService,
                      HasAppDateFormatter,
                      HasGeolocationService,
                      HasConversationsService {
    var userService: UserService
    var categoryService: CategoryService
    var validator: Validator
    var imageUploadService: ImageUploadService
    var advertisementsService: AdvertisementsService
    var appDateFormatter: AppDateFormatter
    var geolocationService: GeolocationService
    var conversationsService: ConversationsService
}
