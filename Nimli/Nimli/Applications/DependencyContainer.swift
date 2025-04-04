//
//  DependencyContainer.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/20.
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
        // the concrete type of AccountRegistrationRepository
        container.register(AccountRegistrationRepository.self) { _ in
            AccountRegistrationRepository()
        }.inObjectScope(.container)
        // the concrete type of VerificationEmailAddressRepository
        container.register(VerificationEmailAddressRepository.self) { _ in
            VerificationEmailAddressRepository()
        }.inObjectScope(.container)
        // the concrete type of AccountLoginRepository
        container.register(AccountLoginRepository.self) { _ in
            AccountLoginRepository()
        }.inObjectScope(.container)
        // the concrete type of UserLocalSettingsDataSource
        container.register(UserLocalSettingsDataSource.self) { _ in
            UserLocalSettingsDataSource()
        }.inObjectScope(.container)
    }
    ///
    /// register all repositries
    ///
    private func registerRepositories() {
        // AccountRegistration repository
        container.register((any AccountRegistrationRepositoryProtocol).self) { resolver in
            resolver.resolve(AccountRegistrationRepository.self)!
        }.inObjectScope(.transient)
        // VerificationEmailAddressRepository repository
        container.register((any VerificationEmailAddressRepositoryProtocol).self) { resolver in
            resolver.resolve(VerificationEmailAddressRepository.self)!
        }.inObjectScope(.transient)
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
    }
    ///
    /// register all usecases
    ///
    private func registerUseCases() {
        // RegisterAccount usecase
        container.register((any RegisterAccountUseCaseProtocol).self) { resolver in
            let accountRegistrationRepositoryProtocol =
            resolver.resolve((any AccountRegistrationRepositoryProtocol).self)!
            return RegisterAccountUseCase(registerAccountRepository: accountRegistrationRepositoryProtocol)
        }.inObjectScope(.transient)
        // VerificationEmailAddress usecase
        container.register((any VerificationEmailAddressUseCaseProtocol).self) { resolver in
            let verificationEmailAddressRepositoryProtocol =
            resolver.resolve((any VerificationEmailAddressRepositoryProtocol).self)!
            return VerificationEmailAddressUseCase(
                verificationEmailAddressRepository: verificationEmailAddressRepositoryProtocol
            )
        }.inObjectScope(.transient)
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
    }
    ///
    /// register all view-models
    ///
    private func registerViewModels() {
        // SignUp screen
        container.register(SignUpViewModel.self) { resolver in
            let registrationAccountUseCase = resolver.resolve((any RegisterAccountUseCaseProtocol).self)!
            return SignUpViewModel(registrationAccountUseCase: registrationAccountUseCase)
        }.inObjectScope(.transient)
        // VerificationEmail screen
        container.register(VerificationEmailAddressViewModel.self) { resolver in
            let verificationEmailAddressUseCase = resolver.resolve((any VerificationEmailAddressUseCaseProtocol).self)!
            return VerificationEmailAddressViewModel(verificationEmailAddressUseCase: verificationEmailAddressUseCase)
        }.inObjectScope(.transient)
        // Login screen
        container.register(LoginViewModel.self) { resolver in
            let accountLoginUseCase = resolver.resolve((any AccountLoginUseCaseProtocol).self)!
            let setStoreLoginAccountUseCase = resolver.resolve((any SetStoreLoginAccountInLocalUseCaseProtocol).self)!
            let getStoreLoginAccountUseCase = resolver.resolve((any GetStoreLoginAccountInLocalUseCaseProtocol).self)!
            return LoginViewModel(
                loginUseCase: accountLoginUseCase,
                setStoreLoginAccountInLocalUseCase: setStoreLoginAccountUseCase,
                getStoreLoginAccountInLocalUseCase: getStoreLoginAccountUseCase)
        }.inObjectScope(.transient)
    }
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}
