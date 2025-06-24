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
        
        // ProfileCorrection repository
        container.register(ProfileCorrectionRepository.self) { _ in
            ProfileCorrectionRepository()
        }.inObjectScope(.container)
        
        container.register(MockProfileCorrectionRepository.self) { _ in
            MockProfileCorrectionRepository()
        }.inObjectScope(.container)
        
        // SearchHistory repository
        container.register(SearchHistoryRepository.self) { _ in
            SearchHistoryRepository()
        }.inObjectScope(.container)
        
        // Tag repository
        container.register(MockTagRepository.self) { _ in
            MockTagRepository()
        }.inObjectScope(.container)
        
        // Favorite repository
        container.register(FavoriteRepository.self) { _ in
            FavoriteRepository()
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
        
        // ProfileCorrection repository
        container.register(ProfileCorrectionRepositoryProtocol.self) { resolver in
            resolver.resolve(MockProfileCorrectionRepository.self)!
        }.inObjectScope(.transient)
        
        // SearchHistory repository
        container.register(SearchHistoryRepositoryProtocol.self) { resolver in
            resolver.resolve(SearchHistoryRepository.self)!
        }.inObjectScope(.transient)
        
        // Tag repository
        container.register(TagRepositoryProtocol.self) { resolver in
            resolver.resolve(MockTagRepository.self)!
        }.inObjectScope(.transient)
        
        // Favorite repository
        container.register(FavoriteRepositoryProtocol.self) { resolver in
            resolver.resolve(FavoriteRepository.self)!
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
        
        // SubmitProfileCorrection usecase
        container.register(SubmitProfileCorrectionUseCase.self) { resolver in
            let profileCorrectionRepository = resolver.resolve(ProfileCorrectionRepositoryProtocol.self)!
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return SubmitProfileCorrectionUseCase(
                profileCorrectionRepository: profileCorrectionRepository,
                creatorRepository: creatorRepository
            )
        }.inObjectScope(.transient)
        
        container.register((any SubmitProfileCorrectionUseCaseProtocol).self) { resolver in
            resolver.resolve(SubmitProfileCorrectionUseCase.self)!
        }.inObjectScope(.transient)
        
        // SearchCreatorsByName usecase
        container.register(SearchCreatorsByNameUseCase.self) { resolver in
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return SearchCreatorsByNameUseCase(creatorRepository: creatorRepository)
        }.inObjectScope(.transient)
        
        container.register((any SearchCreatorsByNameUseCaseProtocol).self) { resolver in
            resolver.resolve(SearchCreatorsByNameUseCase.self)!
        }.inObjectScope(.transient)
        
        // SaveSearchHistory usecase
        container.register(SaveSearchHistoryUseCase.self) { resolver in
            let searchHistoryRepository = resolver.resolve(SearchHistoryRepositoryProtocol.self)!
            return SaveSearchHistoryUseCase(repository: searchHistoryRepository)
        }.inObjectScope(.transient)
        
        // GetSearchHistory usecase
        container.register(GetSearchHistoryUseCase.self) { resolver in
            let searchHistoryRepository = resolver.resolve(SearchHistoryRepositoryProtocol.self)!
            return GetSearchHistoryUseCase(repository: searchHistoryRepository)
        }.inObjectScope(.transient)
        
        // ClearSearchHistory usecase
        container.register(ClearSearchHistoryUseCase.self) { resolver in
            let searchHistoryRepository = resolver.resolve(SearchHistoryRepositoryProtocol.self)!
            return ClearSearchHistoryUseCase(searchHistoryRepository: searchHistoryRepository)
        }.inObjectScope(.transient)
        
        // GetFavoriteCreators usecase
        container.register((any GetFavoriteCreatorsUseCaseProtocol).self) { resolver in
            let favoriteRepository = resolver.resolve(FavoriteRepositoryProtocol.self)!
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return GetFavoriteCreatorsUseCase(
                favoriteRepository: favoriteRepository,
                creatorRepository: creatorRepository
            )
        }.inObjectScope(.transient)
        
        // SearchTagsByName usecase
        container.register(SearchTagsByNameUseCase.self) { resolver in
            let tagRepository = resolver.resolve(TagRepositoryProtocol.self)!
            return SearchTagsByNameUseCase(tagRepository: tagRepository)
        }.inObjectScope(.transient)
        
        container.register((any SearchTagsByNameUseCaseProtocol).self) { resolver in
            resolver.resolve(SearchTagsByNameUseCase.self)!
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
        container.register(TagApplicationViewModel.self) {(resolver, creator: Creator, applicationType: TagApplicationRequest.ApplicationType) in
            let submitTagApplicationUseCase = resolver.resolve((any SubmitTagApplicationUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return TagApplicationViewModel(
                    creator: creator,
                    applicationType: applicationType,
                    submitTagApplicationUseCase: submitTagApplicationUseCase
                )
            }
        }.inObjectScope(.transient)
        
        // ProfileCorrection screen
        container.register(ProfileCorrectionViewModel.self) { (resolver, creator: Creator) in
            let submitProfileCorrectionUseCase = resolver.resolve((any SubmitProfileCorrectionUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return ProfileCorrectionViewModel(
                    creator: creator,
                    submitProfileCorrectionUseCase: submitProfileCorrectionUseCase
                )
            }
        }.inObjectScope(.transient)
        
        // Search screen
        container.register(SearchViewModel.self) { resolver in
            let searchTagsByNameUseCase = resolver.resolve((any SearchTagsByNameUseCaseProtocol).self)!
            let searchCreatorsByTagsUseCase = resolver.resolve((any SearchCreatorsByTagsUseCaseProtocol).self)!
            let saveSearchHistoryUseCase = resolver.resolve(SaveSearchHistoryUseCase.self)!
            let getSearchHistoryUseCase = resolver.resolve(GetSearchHistoryUseCase.self)!
            let clearSearchHistoryUseCase = resolver.resolve(ClearSearchHistoryUseCase.self)!
            return MainActor.assumeIsolated {
                return SearchViewModel(
                    searchTagsByNameUseCase: searchTagsByNameUseCase,
                    searchCreatorsByTagsUseCase: searchCreatorsByTagsUseCase,
                    saveSearchHistoryUseCase: saveSearchHistoryUseCase,
                    getSearchHistoryUseCase: getSearchHistoryUseCase,
                    clearSearchHistoryUseCase: clearSearchHistoryUseCase
                )
            }
        }.inObjectScope(.transient)
        
        // Favorite screen
        container.register(FavoriteViewModel.self) { resolver in
            let getFavoriteCreatorsUseCase = resolver.resolve((any GetFavoriteCreatorsUseCaseProtocol).self)!
            let favoriteRepository = resolver.resolve(FavoriteRepositoryProtocol.self)!
            return MainActor.assumeIsolated {
                return FavoriteViewModel(
                    getFavoriteCreatorsUseCase: getFavoriteCreatorsUseCase,
                    favoriteRepository: favoriteRepository
                )
            }
        }.inObjectScope(.transient)
        
        container.register((any FavoriteViewModelProtocol).self) { resolver in
            resolver.resolve(FavoriteViewModel.self)!
        }.inObjectScope(.transient)
    }
}
