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
        registerDependencies()
    }
    private func registerDependencies() {
        // register concrete type of repositories
        container.register(AccountRegistrationRepository.self) { _ in
            AccountRegistrationRepository()
        }.inObjectScope(.container)
        // resolve all repositories's dependencies
        container.register((any AccountRegistrationRepositoryProtocol).self) { resolver in
            resolver.resolve(AccountRegistrationRepository.self)!
        }.inObjectScope(.transient)
        // resolve all usecase's dependencies
        container.register((any RegisterAccountUseCaseProtocol).self) { resolver in
            let accountRegistrationRepositoryProtocol =
            resolver.resolve((any AccountRegistrationRepositoryProtocol).self)!
            return RegisterAccountUseCase(registerAccountRepository: accountRegistrationRepositoryProtocol)
        }.inObjectScope(.transient)
        // resolve all view-model's dependencies
        container.register(SignUpViewModel.self) { resolver in
            let registrationAccountUseCase = resolver.resolve((any RegisterAccountUseCaseProtocol).self)!
            return SignUpViewModel(registrationAccountUseCase: registrationAccountUseCase)
        }.inObjectScope(.transient)
    }
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}
