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
    }
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}
