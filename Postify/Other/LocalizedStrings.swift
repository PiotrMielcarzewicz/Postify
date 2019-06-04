//
//  LocalizedStrings.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 22/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

struct LocalizedStrings {
    // alerts
    static let wrongCredentialsTitle = NSLocalizedString("Wrong Credentials", comment: "")
    static let wrongCredentialsSubtitle = NSLocalizedString("The username or password you entered is incorrect", comment: "")
    static let emptyFieldsTitle = NSLocalizedString("Empty Fields", comment: "")
    static let emptyFieldsSubtitle = NSLocalizedString("Please fill all empty fields", comment: "")
    static let accountCreated = NSLocalizedString("Account has been created", comment: "")
    static let mismatchedPasswords = NSLocalizedString("Password does not match the confirm password", comment: "")
    static let resetEmailSent = NSLocalizedString("We sent you an email with password reset link", comment: "")
    static let failedToFetchUser = NSLocalizedString("Failed to fetch user", comment: "")
    static let invalidSessionToken = NSLocalizedString("Session Token is invalid", comment: "")
    static let missingMetadata = NSLocalizedString("Upload metadata is missing", comment: "")
    static let missingURL = NSLocalizedString("Upload url is missing", comment: "")
    static let missingImages = NSLocalizedString("Failed to fall all images", comment: "")
    static let failedToProcessAdvertisement = NSLocalizedString("Failed to process advertisement data. Please try again later.", comment: "")
    static let missingSnapshot = NSLocalizedString("Failed to fetch data", comment: "")
    
    // generic
    static let errorCapitalized = NSLocalizedString("Error", comment: "")
    static let successCapitalized = NSLocalizedString("Success", comment: "")
    static let loading = NSLocalizedString("Loading", comment: "")
    static let failedToFetchData = NSLocalizedString("Failed to fetch data", comment: "")
    static let noItems = NSLocalizedString("No Items", comment: "")
    
    // sign in
    static let postify = NSLocalizedString("Postify", comment: "")
    static let orCapitalized = NSLocalizedString("OR", comment: "")
    static let login = NSLocalizedString("Login", comment: "")
    static let forgotPassword = NSLocalizedString("Forgot your password?", comment: "")
    static let dontHaveAccount = NSLocalizedString("Don't have account?", comment: "")
    static let email = NSLocalizedString("Email", comment: "")
    static let password = NSLocalizedString("Password", comment: "")
    
    // sign up
    static let createAccount = NSLocalizedString("Create Account", comment: "")
    static let createAccountDescription = NSLocalizedString("In order to sign up please fill every form field.", comment: "")
    static let create = NSLocalizedString("Create", comment: "")
    static let repeatPassword = NSLocalizedString("Confirm Password", comment: "")
    static let firstname = NSLocalizedString("Firstname", comment: "")
    static let lastname = NSLocalizedString("Lastname", comment: "")
    static let country = NSLocalizedString("Country", comment: "")
    static let city = NSLocalizedString("City", comment: "")
    static let phoneNumber = NSLocalizedString("Phone Number", comment: "")
    static let typeEmail = NSLocalizedString("Type email...", comment: "")
    static let typePassword = NSLocalizedString("Type password...", comment: "")
    static let typeFirstname = NSLocalizedString("Type firstname...", comment: "")
    static let typeLastname = NSLocalizedString("type lastname...", comment: "")
    static let typeCountry = NSLocalizedString("Type country...", comment: "")
    static let typeCity = NSLocalizedString("Type city...", comment: "")
    static let typePhoneNumber = NSLocalizedString("Type phone number...", comment: "")
    static let invalidPhoneNumber = NSLocalizedString("Phone Number format is incorrect", comment: "")
    
    // forgot password
    static let passwordResetQuestion = NSLocalizedString("Password Reset?", comment: "")
    static let forgotPasswordTitle = NSLocalizedString("Forgot Password?", comment: "")
    static let forgotPasswordDescription = NSLocalizedString("We will sent you an email with a link to reset your password.", comment: "")
    static let send = NSLocalizedString("Send", comment: "")
    static let close = NSLocalizedString("Close", comment: "")
    
    // add advertisement
    static let browse = NSLocalizedString("Browse", comment: "")
    static let addAdvertisement = NSLocalizedString("Add Advertisement", comment: "")
    static let editAdvertisement = NSLocalizedString("Edit Advertisement", comment: "")
    static let title = NSLocalizedString("Title", comment: "")
    static let typeTitle = NSLocalizedString("Type title...", comment: "")
    static let description = NSLocalizedString("Description", comment: "")
    static let price = NSLocalizedString("Price ($)", comment: "")
    static let images = NSLocalizedString("Images", comment: "")
    static let select = NSLocalizedString("Select", comment: "")
    static let author = NSLocalizedString("Author", comment: "")
    static let typeAuthor = NSLocalizedString("Type author...", comment: "")
    static let album = NSLocalizedString("Album", comment: "")
    static let typeAlbum = NSLocalizedString("Type album...", comment: "")
    static let category = NSLocalizedString("Category", comment: "")
    static let notSelected = NSLocalizedString("Not Selected", comment: "")
    static let didCreateAdvertisement = NSLocalizedString("Advertisement has been succesfully created!", comment: "")
    static let didEditAdvertisement = NSLocalizedString("Advertisement has been succesfully edited!", comment: "")
    static let add = NSLocalizedString("Add", comment: "")
    static let update = NSLocalizedString("Update", comment: "")
    static let missingId = NSLocalizedString("Cannot generate new identifier", comment: "")
    
    // advertisements
    static let dateAscending = NSLocalizedString("Date Ascending", comment: "")
    static let dateDescending = NSLocalizedString("Date Descending", comment: "")
    static let lowToHighPrice = NSLocalizedString("Price (Low to High)", comment: "")
    static let highToLowPrice = NSLocalizedString("Price (Hight to Low)", comment: "")
    static let filter = NSLocalizedString("Filter", comment: "")
    static let sort = NSLocalizedString("Sort", comment: "")
    
    // advertisement details
    static let details = NSLocalizedString("Details", comment: "")
    static let vinyl = NSLocalizedString("Vinyl", comment: "")
    static let other = NSLocalizedString("Other", comment: "")
    static let priceDescription = NSLocalizedString("Price:", comment: "")
    static let publishDateDescription = NSLocalizedString("Publish Date:", comment: "")
    static let categoryDescription = NSLocalizedString("Category:", comment: "")
    static let albumDescription = NSLocalizedString("Album:", comment: "")
    static let phoneDescription = NSLocalizedString("Phone:", comment: "")
    static let chatDescription = NSLocalizedString("Chat:", comment: "")
    static let open = NSLocalizedString("Open", comment: "")
    static let authorDescription = NSLocalizedString("Author:", comment: "")
    static let typeDescription = NSLocalizedString("Type:", comment: "")
    static let cityDescription = NSLocalizedString("City:", comment: "")
    static let countryDescription = NSLocalizedString("Country:", comment: "")
    static let advertisementIsArchived = NSLocalizedString("Advertisement is archived", comment: "")
    static let advertisementInfo = NSLocalizedString("Advertisement info", comment: "")
    static func contactDetailsTitle(name: String) -> String {
        return String(format: NSLocalizedString("%@'s contact info", comment: ""), name)
    }
    
    // my advertisements
    static let myAdvertisements = NSLocalizedString("My Advertisements", comment: "")
    static let view = NSLocalizedString("View", comment: "")
    static let unarchive = NSLocalizedString("Unarchive", comment: "")
    static let archived = NSLocalizedString("Archived", comment: "")
    static let archivedCapitalized = NSLocalizedString("ARCHIVED", comment: "")
    static let archive = NSLocalizedString("Archive", comment: "")
    static let cancel = NSLocalizedString("Cancel", comment: "")
    static let edit = NSLocalizedString("Edit", comment: "")
    static let failedToFetchAdvertisements = NSLocalizedString("Failed to fetch advertisements", comment: "")
    static let youHaveNoAdvertisements = NSLocalizedString("You have no advertisements", comment: "")
    static let options = NSLocalizedString("···", comment: "")
    
    // conversations
    static let conversations = NSLocalizedString("Conversations", comment: "")
    static let showDetails = NSLocalizedString("Show Details", comment: "")
    static let conversationStarted = NSLocalizedString("Conversation has been started!", comment: "")
    static let youHaveNoConversations = NSLocalizedString("You have no conversations", comment: "")
    static let you = NSLocalizedString("You", comment: "")
    
    // settings
    static let settings = NSLocalizedString("Settings", comment: "")
    static let myProfile = NSLocalizedString("My Profile", comment: "")
    static let resetPassword = NSLocalizedString("Reset Password", comment: "")
    static let shouldDisplayPhone = NSLocalizedString("Public Phone", comment: "")
    static let logout = NSLocalizedString("Logout", comment: "")
    
    // my profile
    static let myProfileEdit = NSLocalizedString("My Profile Edit", comment: "")
    static let updatedUserData = NSLocalizedString("Updated profile data", comment: "")
    
    // category selector
    static let selectCategory = NSLocalizedString("Select Category", comment: "")
    static let all = NSLocalizedString("All", comment: "")
    
    // chat
    static let message = NSLocalizedString("Type message...", comment: "")
    static let back = NSLocalizedString("Back", comment: "")
}
