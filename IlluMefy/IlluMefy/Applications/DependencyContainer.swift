//
//  DependencyContainer.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/20.
//  Updated on 2025/04/04.
//

import Swinject

final class DependencyContainer: @unchecked Sendable {
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
        // the concrete type of MockCreatorRepository
        container.register(MockCreatorRepository.self) { _ in
            MockCreatorRepository()
        }.inObjectScope(.container)
        
        // TagApplication repository
        container.register(TagApplicationRepository.self) { _ in
            TagApplicationRepository()
        }.inObjectScope(.container)
    }
    ///
    /// register all repositories
    ///
    private func registerRepositories() {
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
        // Creator repository
        container.register(CreatorRepositoryProtocol.self) { resolver in
            resolver.resolve(MockCreatorRepository.self)!
        }.inObjectScope(.transient)
        
        // TagApplication repository
        container.register(TagApplicationRepositoryProtocol.self) { resolver in
            resolver.resolve(TagApplicationRepository.self)!
        }.inObjectScope(.transient)
    }
    ///
    /// register all usecases
    ///
    private func registerUseCases() {
        // SendPhoneVerification usecase
        container.register(SendPhoneVerificationUseCase.self) { resolver in
            let phoneAuthRepository = resolver.resolve(PhoneAuthRepositoryProtocol.self)!
            return SendPhoneVerificationUseCase(phoneAuthRepository: phoneAuthRepository)
        }.inObjectScope(.transient)
        
        // VerifyPhoneAuthCode usecase
        container.register(VerifyPhoneAuthCodeUseCase.self) { resolver in
            let phoneAuthRepository = resolver.resolve(PhoneAuthRepositoryProtocol.self)!
            return VerifyPhoneAuthCodeUseCase(phoneAuthRepository: phoneAuthRepository)
        }.inObjectScope(.transient)
        
        // Protocol registrations for use cases
        container.register((any SendPhoneVerificationUseCaseProtocol).self) { resolver in
            resolver.resolve(SendPhoneVerificationUseCase.self)!
        }.inObjectScope(.transient)
        
        container.register((any VerifyPhoneAuthCodeUseCaseProtocol).self) { resolver in
            resolver.resolve(VerifyPhoneAuthCodeUseCase.self)!
        }.inObjectScope(.transient)
        
        // GetPopularCreators usecase
        container.register(GetPopularCreatorsUseCase.self) { resolver in
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return GetPopularCreatorsUseCase(creatorRepository: creatorRepository)
        }.inObjectScope(.transient)
        
        container.register((any GetPopularCreatorsUseCaseProtocol).self) { resolver in
            resolver.resolve(GetPopularCreatorsUseCase.self)!
        }.inObjectScope(.transient)
        
        // SearchCreatorsByTags usecase
        container.register(SearchCreatorsByTagsUseCase.self) { resolver in
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return SearchCreatorsByTagsUseCase(creatorRepository: creatorRepository)
        }.inObjectScope(.transient)
        
        container.register((any SearchCreatorsByTagsUseCaseProtocol).self) { resolver in
            resolver.resolve(SearchCreatorsByTagsUseCase.self)!
        }.inObjectScope(.transient)
        
        // GetCreatorDetail usecase
        container.register(GetCreatorDetailUseCase.self) { resolver in
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return GetCreatorDetailUseCase(creatorRepository: creatorRepository)
        }.inObjectScope(.transient)
        
        container.register((any GetCreatorDetailUseCaseProtocol).self) { resolver in
            resolver.resolve(GetCreatorDetailUseCase.self)!
        }.inObjectScope(.transient)
        
        // SubmitTagApplication usecase
        container.register(SubmitTagApplicationUseCase.self) { resolver in
            let tagApplicationRepository = resolver.resolve(TagApplicationRepositoryProtocol.self)!
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return SubmitTagApplicationUseCase(
                tagApplicationRepository: tagApplicationRepository,
                creatorRepository: creatorRepository
            )
        }.inObjectScope(.transient)
        
        container.register((any SubmitTagApplicationUseCaseProtocol).self) { resolver in
            resolver.resolve(SubmitTagApplicationUseCase.self)!
        }.inObjectScope(.transient)
        
    }
    ///
    /// register all view-models
    ///
    private func registerViewModels() {
        // PhoneRegistration screen
        container.register(PhoneNumberRegistrationViewModel.self) { resolver in
            let sendPhoneVerificationUseCase = resolver.resolve((any SendPhoneVerificationUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return PhoneNumberRegistrationViewModel(
                    sendPhoneVerificationUseCase: sendPhoneVerificationUseCase
                )
            }
        }.inObjectScope(.transient)
        
        // Home screen
        container.register(HomeViewModel.self) { resolver in
            let getPopularCreatorsUseCase = resolver.resolve((any GetPopularCreatorsUseCaseProtocol).self)!
            let searchCreatorsByTagsUseCase = resolver.resolve((any SearchCreatorsByTagsUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return HomeViewModel(
                    getPopularCreatorsUseCase: getPopularCreatorsUseCase,
                    searchCreatorsByTagsUseCase: searchCreatorsByTagsUseCase
                )
            }
        }.inObjectScope(.transient)
        
        container.register((any HomeViewModelProtocol).self) { resolver in
            resolver.resolve(HomeViewModel.self)!
        }.inObjectScope(.transient)
        
        // CreatorDetail screen
        container.register(CreatorDetailViewModel.self) { (resolver, creatorId: String) in
            let getCreatorDetailUseCase = resolver.resolve((any GetCreatorDetailUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return CreatorDetailViewModel(
                    creatorId: creatorId,
                    getCreatorDetailUseCase: getCreatorDetailUseCase
                )
            }
        }.inObjectScope(.transient)
        
        // TagApplication screen
        container.register(TagApplicationViewModel.self) { (resolver, creator: Creator, applicationType: TagApplicationRequest.ApplicationType) in
            let submitTagApplicationUseCase = resolver.resolve((any SubmitTagApplicationUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return TagApplicationViewModel(
                    creator: creator,
                    applicationType: applicationType,
                    submitTagApplicationUseCase: submitTagApplicationUseCase
                )
            }
        }.inObjectScope(.transient)
    }
}
