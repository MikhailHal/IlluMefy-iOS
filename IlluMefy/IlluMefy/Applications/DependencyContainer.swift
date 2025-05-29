//
//  DependencyContainer.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/20.
//  Updated on 2025/04/04.
//

import Swinject

class DependencyContainer {
    static let shared = DependencyContainer()
    let container = Container()
    private init() {
        makeConcreteObjects()
        registerRepositories()
        registerUseCases()
        registerViewModels()
    }
    ///
    /// make concrete type of objects
    ///
    private func makeConcreteObjects() {
        // the concrete type of AccountLoginRepository
        container.register(AccountLoginRepository.self) { _ in
            AccountLoginRepository()
        }.inObjectScope(.container)
        // the concrete type of UserLocalSettingsDataSource
        container.register(UserLocalSettingsDataSource.self) { _ in
            UserLocalSettingsDataSource()
        }.inObjectScope(.container)
        // the concrete type of PhoneAuthRepository
        container.register(PhoneAuthRepository.self) { _ in
            PhoneAuthRepository() // デフォルトでFirebasePhoneAuthProvider()が使われる
        }.inObjectScope(.container)
    }
    ///
    /// register all repositries
    ///
    private func registerRepositories() {
        // AccountLogin repository
        container.register((any AccountLoginRepositoryProtocol).self) { resolver in
            resolver.resolve(AccountLoginRepository.self)!
        }.inObjectScope(.transient)
        // UserLocalSettingsDataSource repository
        container.register((any UserLocalSettingsDataSourceProtocol).self) { resolver in
            resolver.resolve(UserLocalSettingsDataSource.self)!
        }.inObjectScope(.transient)
        // UserPreferences repository
        container.register((any UserPreferencesRepositoryProtocol).self) { resolver in
            let userLocalSettingsDataSource = resolver.resolve((any UserLocalSettingsDataSourceProtocol).self)!
            return UserPreferencesRepository(userLocalSettingsDataSource: userLocalSettingsDataSource)
        }.inObjectScope(.transient)
        // PhoneAuth repository
        container.register((any PhoneAuthRepositoryProtocol).self) { resolver in
            resolver.resolve(PhoneAuthRepository.self)!
        }.inObjectScope(.transient)
    }
    ///
    /// register all usecases
    ///
    private func registerUseCases() {
        // AccountLogin usecase
        container.register((any AccountLoginUseCaseProtocol).self) { resolver in
            let accountLoginRepositoryProtocol =
            resolver.resolve((any AccountLoginRepositoryProtocol).self)!
            return AccountLoginUseCase(accountLoginRepository: accountLoginRepositoryProtocol)
        }.inObjectScope(.transient)
        // SetStoreLoginAccountInLocal usecase
        container.register((any SetStoreLoginAccountInLocalUseCaseProtocol).self) { resolver in
            let userPreferencesRepository = resolver.resolve((any UserPreferencesRepositoryProtocol).self)!
            return SetStoreLoginAccountInLocalUseCase(userPreferencesRepository: userPreferencesRepository)
        }.inObjectScope(.transient)
        // GetStoreLoginAccountInLocal usecase
        container.register((any GetStoreLoginAccountInLocalUseCaseProtocol).self) { resolver in
            let userPreferencesRepository = resolver.resolve((any UserPreferencesRepositoryProtocol).self)!
            return GetStoreLoginAccountInLocalUseCase(userPreferencesRepository: userPreferencesRepository)
        }.inObjectScope(.transient)
        // SendPhoneVerification usecase
        container.register((any SendPhoneVerificationUseCaseProtocol).self) { resolver in
            let phoneAuthRepository = resolver.resolve((any PhoneAuthRepositoryProtocol).self)!
            return SendPhoneVerificationUseCase(phoneAuthRepository: phoneAuthRepository)
        }.inObjectScope(.transient)
    }
    ///
    /// register all view-models
    ///
    private func registerViewModels() {
        // PhoneRegistration screen
        container.register(PhoneNumberRegistrationViewModel.self) { resolver in
            let setStoreLoginAccountInLocalUseCase =
            resolver.resolve((any SetStoreLoginAccountInLocalUseCaseProtocol).self)!
            let sendPhoneVerificationUseCase = resolver.resolve((any SendPhoneVerificationUseCaseProtocol).self)!
            return PhoneNumberRegistrationViewModel(
                setStoreLoginAccountInLocalUseCase: setStoreLoginAccountInLocalUseCase,
                sendPhoneVerificationUseCase: sendPhoneVerificationUseCase
            )
        }.inObjectScope(.transient)
        // Login screen
        container.register(LoginViewModel.self) { resolver in
            let accountLoginUseCase = resolver.resolve((any AccountLoginUseCaseProtocol).self)!
            let setStoreLoginAccountInLocalUseCase =
            resolver.resolve((any SetStoreLoginAccountInLocalUseCaseProtocol).self)!
            let getStoreLoginAccountInLocalUseCase =
            resolver.resolve((any GetStoreLoginAccountInLocalUseCaseProtocol).self)!
            return LoginViewModel(
                loginUseCase: accountLoginUseCase,
                setStoreLoginAccountInLocalUseCase: setStoreLoginAccountInLocalUseCase,
                getStoreLoginAccountInLocalUseCase: getStoreLoginAccountInLocalUseCase)
        }.inObjectScope(.transient)
    }
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}
