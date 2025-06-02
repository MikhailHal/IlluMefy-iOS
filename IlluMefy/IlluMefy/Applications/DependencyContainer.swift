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
    
    func resolve<T>(_ serviceType: T.Type) -> T? {
        return container.resolve(serviceType)
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
        // the concrete type of UserPreferencesRepository
        container.register(UserPreferencesRepository.self) { resolver in
            let userLocalSettingsDataSource = resolver.resolve(UserLocalSettingsDataSource.self)!
            return UserPreferencesRepository(userLocalSettingsDataSource: userLocalSettingsDataSource)
        }.inObjectScope(.container)
    }
    ///
    /// register all repositories
    ///
    private func registerRepositories() {
        // AccountLogin repository
        container.register(AccountLoginRepositoryProtocol.self) { resolver in
            resolver.resolve(AccountLoginRepository.self)!
        }.inObjectScope(.transient)
        // UserLocalSettingsDataSource repository
        container.register(UserLocalSettingsDataSourceProtocol.self) { resolver in
            resolver.resolve(UserLocalSettingsDataSource.self)!
        }.inObjectScope(.transient)
        // UserPreferences repository
        container.register(UserPreferencesRepositoryProtocol.self) { resolver in
            resolver.resolve(UserPreferencesRepository.self)!
        }.inObjectScope(.transient)
        // PhoneAuth repository
        container.register(PhoneAuthRepositoryProtocol.self) { resolver in
            resolver.resolve(PhoneAuthRepository.self)!
        }.inObjectScope(.transient)
    }
    ///
    /// register all usecases
    ///
    private func registerUseCases() {
        // AccountLogin usecase
        container.register(AccountLoginUseCase.self) { resolver in
            let accountLoginRepository = resolver.resolve(AccountLoginRepositoryProtocol.self)!
            return AccountLoginUseCase(accountLoginRepository: accountLoginRepository)
        }.inObjectScope(.transient)
        // SetStoreLoginAccountInLocal usecase
        container.register(SetStoreLoginAccountInLocalUseCase.self) { resolver in
            let userPreferencesRepository = resolver.resolve(UserPreferencesRepositoryProtocol.self)!
            return SetStoreLoginAccountInLocalUseCase(userPreferencesRepository: userPreferencesRepository)
        }.inObjectScope(.transient)
        // GetStoreLoginAccountInLocal usecase
        container.register(GetStoreLoginAccountInLocalUseCase.self) { resolver in
            let userPreferencesRepository = resolver.resolve(UserPreferencesRepositoryProtocol.self)!
            return GetStoreLoginAccountInLocalUseCase(userPreferencesRepository: userPreferencesRepository)
        }.inObjectScope(.transient)
        // SendPhoneVerification usecase
        container.register(SendPhoneVerificationUseCase.self) { resolver in
            let phoneAuthRepository = resolver.resolve(PhoneAuthRepositoryProtocol.self)!
            return SendPhoneVerificationUseCase(phoneAuthRepository: phoneAuthRepository)
        }.inObjectScope(.transient)
        
        // Protocol registrations for use cases
        container.register((any AccountLoginUseCaseProtocol).self) { resolver in
            resolver.resolve(AccountLoginUseCase.self)!
        }.inObjectScope(.transient)
        
        container.register((any SetStoreLoginAccountInLocalUseCaseProtocol).self) { resolver in
            resolver.resolve(SetStoreLoginAccountInLocalUseCase.self)!
        }.inObjectScope(.transient)
        
        container.register((any GetStoreLoginAccountInLocalUseCaseProtocol).self) { resolver in
            resolver.resolve(GetStoreLoginAccountInLocalUseCase.self)!
        }.inObjectScope(.transient)
        
        container.register((any SendPhoneVerificationUseCaseProtocol).self) { resolver in
            resolver.resolve(SendPhoneVerificationUseCase.self)!
        }.inObjectScope(.transient)
    }
    ///
    /// register all view-models
    ///
    private func registerViewModels() {
        // PhoneRegistration screen
        container.register(PhoneNumberRegistrationViewModel.self) { resolver in
            let setStoreLoginAccountInLocalUseCase = resolver.resolve((any SetStoreLoginAccountInLocalUseCaseProtocol).self)!
            let sendPhoneVerificationUseCase = resolver.resolve((any SendPhoneVerificationUseCaseProtocol).self)!
            return PhoneNumberRegistrationViewModel(
                setStoreLoginAccountInLocalUseCase: setStoreLoginAccountInLocalUseCase,
                sendPhoneVerificationUseCase: sendPhoneVerificationUseCase
            )
        }.inObjectScope(.transient)
        // Login screen
        container.register(LoginViewModel.self) { resolver in
            let loginUseCase = resolver.resolve((any AccountLoginUseCaseProtocol).self)!
            let setStoreLoginAccountInLocalUseCase = resolver.resolve((any SetStoreLoginAccountInLocalUseCaseProtocol).self)!
            let getStoreLoginAccountInLocalUseCase = resolver.resolve((any GetStoreLoginAccountInLocalUseCaseProtocol).self)!
            return LoginViewModel(
                loginUseCase: loginUseCase,
                setStoreLoginAccountInLocalUseCase: setStoreLoginAccountInLocalUseCase,
                getStoreLoginAccountInLocalUseCase: getStoreLoginAccountInLocalUseCase
            )
        }.inObjectScope(.transient)
    }
}