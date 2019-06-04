// Generated using Sourcery 0.14.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable all
protocol BuilderProvider {
    func getAddAdvertisementBuilder() -> AddAdvertisementBuilder
    func getAdvertisementDetailsBuilder() -> AdvertisementDetailsBuilder
    func getAdvertisementsBuilder() -> AdvertisementsBuilder
    func getCategorySelectorBuilder() -> CategorySelectorBuilder
    func getChatBuilder() -> ChatBuilder
    func getConversationsBuilder() -> ConversationsBuilder
    func getForgotPasswordBuilder() -> ForgotPasswordBuilder
    func getMyAdvertisementsBuilder() -> MyAdvertisementsBuilder
    func getMyProfileBuilder() -> MyProfileBuilder
    func getSettingsBuilder() -> SettingsBuilder
    func getSignInBuilder() -> SignInBuilder
    func getSignUpBuilder() -> SignUpBuilder
    func getTabBarBuilder() -> TabBarBuilder
}

extension AppDependency: BuilderProvider {
    func getAddAdvertisementBuilder() -> AddAdvertisementBuilder {
        return AddAdvertisementBuilderImp(appDependency: self)
    }
    func getAdvertisementDetailsBuilder() -> AdvertisementDetailsBuilder {
        return AdvertisementDetailsBuilderImp(appDependency: self)
    }
    func getAdvertisementsBuilder() -> AdvertisementsBuilder {
        return AdvertisementsBuilderImp(appDependency: self)
    }
    func getCategorySelectorBuilder() -> CategorySelectorBuilder {
        return CategorySelectorBuilderImp(appDependency: self)
    }
    func getChatBuilder() -> ChatBuilder {
        return ChatBuilderImp(appDependency: self)
    }
    func getConversationsBuilder() -> ConversationsBuilder {
        return ConversationsBuilderImp(appDependency: self)
    }
    func getForgotPasswordBuilder() -> ForgotPasswordBuilder {
        return ForgotPasswordBuilderImp(appDependency: self)
    }
    func getMyAdvertisementsBuilder() -> MyAdvertisementsBuilder {
        return MyAdvertisementsBuilderImp(appDependency: self)
    }
    func getMyProfileBuilder() -> MyProfileBuilder {
        return MyProfileBuilderImp(appDependency: self)
    }
    func getSettingsBuilder() -> SettingsBuilder {
        return SettingsBuilderImp(appDependency: self)
    }
    func getSignInBuilder() -> SignInBuilder {
        return SignInBuilderImp(appDependency: self)
    }
    func getSignUpBuilder() -> SignUpBuilder {
        return SignUpBuilderImp(appDependency: self)
    }
    func getTabBarBuilder() -> TabBarBuilder {
        return TabBarBuilderImp(appDependency: self)
    }
}
