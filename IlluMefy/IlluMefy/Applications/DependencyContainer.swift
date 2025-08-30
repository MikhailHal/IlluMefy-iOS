//
//  DependencyContainer.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/20.
//  Updated on 2025/04/04.
//TODO: 日本語に変えてこう

import Swinject
import Foundation

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
    
    /// Algoliaの初期化処理
    func initializeAlgolia() async {
        guard let algoliaRepository = resolve(AlgoliaRepositoryProtocol.self) as? AlgoliaRepository else {
            print("Failed to resolve AlgoliaRepository")
            return
        }
        await algoliaRepository.initialize()
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
        // APIClient
        container.register(ApiClient.self) { _ in
            ApiClient()
        }.inObjectScope(.container)
        
        // the concrete type of MockCreatorRepository
        container.register(MockCreatorRepository.self) { _ in
            MockCreatorRepository()
        }.inObjectScope(.container)
        
        // Firebase Remote Config
        container.register(FirebaseRemoteConfigProtocol.self) { _ in
            FirebaseRemoteConfig()
        }.inObjectScope(.container)
        
        // the concrete type of CreatorRepository
        container.register(CreatorRepository.self) { resolver in
            let apiClient = resolver.resolve(ApiClientProtocol.self)!
            return CreatorRepository(apiClient: apiClient)
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
        
        container.register(TagRepository.self) { resolver in
            let apiClient = resolver.resolve(ApiClientProtocol.self)!
            return TagRepository(apiClient: apiClient)
        }.inObjectScope(.container)
        
        // Favorite repository
        container.register(FavoriteRepository.self) { _ in
            FavoriteRepository()
        }.inObjectScope(.container)
        
        // 運営からのお知らせ
        container.register(OfficialNotificationRepository.self) { resolver in
            let firebaseRemoteConfig = resolver.resolve(FirebaseRemoteConfigProtocol.self)!
            return MainActor.assumeIsolated {
                return OfficialNotificationRepository(firebaseRemoteConfig: firebaseRemoteConfig)
            }
        }.inObjectScope(.container)
        
        // 開発状況
        container.register(DevelopmentStatusRepository.self) { resolver in
            let firebaseRemoteConfig = resolver.resolve(FirebaseRemoteConfigProtocol.self)!
            return MainActor.assumeIsolated {
                return DevelopmentStatusRepository(firebaseRemoteConfig: firebaseRemoteConfig)
            }
        }.inObjectScope(.container)
        
        // バグ状況
        container.register(BugStatusRepository.self) { resolver in
            let firebaseRemoteConfig = resolver.resolve(FirebaseRemoteConfigProtocol.self)!
            return MainActor.assumeIsolated {
                return BugStatusRepository(firebaseRemoteConfig: firebaseRemoteConfig)
            }
        }.inObjectScope(.container)
        
        // Auth repository
        container.register(AuthRepository.self) { _ in
            AuthRepository()
        }.inObjectScope(.container)
        
        // Algolia repository
        container.register(AlgoliaRepository.self) { resolver in
            // プレビューモードではダミーのFirebaseRemoteConfigを使用
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                // プレビュー用のモック実装
                class MockFirebaseRemoteConfig: FirebaseRemoteConfigProtocol {
                    func fetchValue<T>(key: String) -> T? {
                        return nil // プレビューでは何も返さない
                    }
                }
                return AlgoliaRepository(firebaseRemoteConfig: MockFirebaseRemoteConfig())
            } else {
                let firebaseRemoteConfig = resolver.resolve(FirebaseRemoteConfigProtocol.self)!
                return AlgoliaRepository(firebaseRemoteConfig: firebaseRemoteConfig)
            }
        }.inObjectScope(.container)
    }
    ///
    /// register all repositories
    ///
    private func registerRepositories() {
        // ApiClient repository
        container.register(ApiClientProtocol.self) { resolver in
            resolver.resolve(ApiClient.self)!
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
        // Creator repository - 本物のAPIを使用
        container.register(CreatorRepositoryProtocol.self) { resolver in
            resolver.resolve(CreatorRepository.self)!
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
        
        // Tag repository - 本物のAPIを使用
        container.register(TagRepositoryProtocol.self) { resolver in
            resolver.resolve(TagRepository.self)!
        }.inObjectScope(.transient)
        
        // Favorite repository
        container.register(FavoriteRepositoryProtocol.self) { resolver in
            resolver.resolve(FavoriteRepository.self)!
        }.inObjectScope(.transient)
        
        // OperatorMessage repository
        container.register(OfficialNotificationRepositoryProtocol.self) { resolver in
            resolver.resolve(OfficialNotificationRepository.self)!
        }.inObjectScope(.transient)
        
        // DevelopmentStatus repository
        container.register(DevelopmentStatusRepositoryProtocol.self) { resolver in
            resolver.resolve(DevelopmentStatusRepository.self)!
        }.inObjectScope(.transient)
        
        // BugStatus repository
        container.register(BugStatusRepositoryProtocol.self) { resolver in
            resolver.resolve(BugStatusRepository.self)!
        }.inObjectScope(.transient)
        
        // Auth repository
        container.register(AuthRepositoryProtocol.self) { resolver in
            resolver.resolve(AuthRepository.self)!
        }.inObjectScope(.transient)
        
        // Algolia repository
        container.register(AlgoliaRepositoryProtocol.self) { resolver in
            resolver.resolve(AlgoliaRepository.self)!
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
        
        // GetNewestCreators usecase
        container.register(GetNewestCreatorsUseCase.self) { resolver in
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return GetNewestCreatorsUseCase(creatorRepository: creatorRepository)
        }.inObjectScope(.transient)
        
        container.register((any GetNewestCreatorsUseCaseProtocol).self) { resolver in
            resolver.resolve(GetNewestCreatorsUseCase.self)!
        }.inObjectScope(.transient)
        
        // GetPopularTags usecase
        container.register(GetPopularTagsUseCase.self) { resolver in
            let tagRepository = resolver.resolve(TagRepositoryProtocol.self)!
            return GetPopularTagsUseCase(tagRepository: tagRepository)
        }.inObjectScope(.transient)
        
        container.register((any GetPopularTagsUseCaseProtocol).self) { resolver in
            resolver.resolve(GetPopularTagsUseCase.self)!
        }.inObjectScope(.transient)
        
        // GetTagListByTagIdList usecase
        container.register(GetTagListByTagIdListUseCase.self) { resolver in
            let tagRepository = resolver.resolve(TagRepositoryProtocol.self)!
            return GetTagListByTagIdListUseCase(tagRepository: tagRepository)
        }.inObjectScope(.transient)
        
        container.register((any GetTagListByTagIdListUseCaseProtocol).self) { resolver in
            resolver.resolve(GetTagListByTagIdListUseCase.self)!
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
            return GetFavoriteCreatorsUseCase(
                favoriteRepository: favoriteRepository,
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
        
        // GetOfficialNotification usecase
        container.register(GetOfficialNotificationUseCase.self) { resolver in
            let officialNotificationRepository = resolver.resolve(OfficialNotificationRepositoryProtocol.self)!
            return GetOfficialNotificationUseCase(officialNotificationRepository: officialNotificationRepository)
        }.inObjectScope(.transient)
        
        container.register((any GetOfficialNotificationUseCaseProtocol).self) { resolver in
            resolver.resolve(GetOfficialNotificationUseCase.self)!
        }.inObjectScope(.transient)
        
        // GetDevelopmentStatus usecase
        container.register(GetDevelopmentStatusUseCase.self) { resolver in
            let developmentStatusRepository = resolver.resolve(DevelopmentStatusRepositoryProtocol.self)!
            return GetDevelopmentStatusUseCase(repository: developmentStatusRepository)
        }.inObjectScope(.transient)
        
        container.register((any GetDevelopmentStatusUseCaseProtocol).self) { resolver in
            resolver.resolve(GetDevelopmentStatusUseCase.self)!
        }.inObjectScope(.transient)
        
        // GetBugStatus usecase
        container.register(GetBugStatusUseCase.self) { resolver in
            let bugStatusRepository = resolver.resolve(BugStatusRepositoryProtocol.self)!
            return GetBugStatusUseCase(repository: bugStatusRepository)
        }.inObjectScope(.transient)
        
        container.register((any GetBugStatusUseCaseProtocol).self) { resolver in
            resolver.resolve(GetBugStatusUseCase.self)!
        }.inObjectScope(.transient)
        
        // Logout usecase
        container.register(LogoutUseCase.self) { resolver in
            let authRepository = resolver.resolve(AuthRepositoryProtocol.self)!
            return LogoutUseCase(authRepository: authRepository)
        }.inObjectScope(.transient)
        
        container.register((any LogoutUseCaseProtocol).self) { resolver in
            resolver.resolve(LogoutUseCase.self)!
        }.inObjectScope(.transient)
        
        // DeleteAccount usecase
        container.register(DeleteAccountUseCase.self) { resolver in
            let authRepository = resolver.resolve(AuthRepositoryProtocol.self)!
            let favoriteRepository = resolver.resolve(FavoriteRepositoryProtocol.self)!
            let userPreferencesRepository = resolver.resolve(UserPreferencesRepositoryProtocol.self)!
            return MainActor.assumeIsolated {
                return DeleteAccountUseCase(
                    authRepository: authRepository,
                    favoriteRepository: favoriteRepository,
                    userPreferencesRepository: userPreferencesRepository
                )
            }
        }.inObjectScope(.transient)
        
        container.register((any DeleteAccountUseCaseProtocol).self) { resolver in
            resolver.resolve(DeleteAccountUseCase.self)!
        }.inObjectScope(.transient)
        
        // ToggleFavoriteCreator usecase
        container.register(ToggleFavoriteCreatorUseCase.self) { resolver in
            let favoriteRepository = resolver.resolve(FavoriteRepositoryProtocol.self)!
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return ToggleFavoriteCreatorUseCase(favoriteRepository: favoriteRepository, creatorRepository: creatorRepository)
        }.inObjectScope(.transient)
        
        container.register((any ToggleFavoriteCreatorUseCaseProtocol).self) { resolver in
            resolver.resolve(ToggleFavoriteCreatorUseCase.self)!
        }.inObjectScope(.transient)
        
        // CheckAlreadyFavoriteCreator usecase
        container.register(CheckAlreadyFavoriteCreatorUseCase.self) { resolver in
            let favoriteRepository = resolver.resolve(FavoriteRepositoryProtocol.self)!
            return CheckAlreadyFavoriteCreatorUseCase(favoriteRepository: favoriteRepository)
        }.inObjectScope(.transient)
        
        container.register((any CheckAlreadyFavoriteCreatorUseCaseProtocol).self) { resolver in
            resolver.resolve(CheckAlreadyFavoriteCreatorUseCase.self)!
        }.inObjectScope(.transient)
        
        // SearchTagsWithAlgolia usecase
        container.register(SearchTagsWithAlgoliaUseCase.self) { resolver in
            let algoliaRepository = resolver.resolve(AlgoliaRepositoryProtocol.self)!
            return SearchTagsWithAlgoliaUseCase(algoliaRepository: algoliaRepository)
        }.inObjectScope(.transient)
        
        container.register(SearchTagsWithAlgoliaUseCaseProtocol.self) { resolver in
            resolver.resolve(SearchTagsWithAlgoliaUseCase.self)!
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
            let getNewestCreatorsUseCase = resolver.resolve((any GetNewestCreatorsUseCaseProtocol).self)!
            let getPopularTagsUseCase = resolver.resolve((any GetPopularTagsUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return HomeViewModel(
                    getPopularCreatorsUseCase: getPopularCreatorsUseCase,
                    searchCreatorsByTagsUseCase: searchCreatorsByTagsUseCase,
                    getNewestCreatorsUseCase: getNewestCreatorsUseCase,
                    getPopularTagsUseCase: getPopularTagsUseCase
                )
            }
        }.inObjectScope(.transient)
        
        container.register((any HomeViewModelProtocol).self) { resolver in
            resolver.resolve(HomeViewModel.self)!
        }.inObjectScope(.transient)
        
        // CreatorDetail screen
        container.register(CreatorDetailViewModel.self) { (resolver, creator: Creator) in
            let getCreatorDetailUseCase = resolver.resolve((any GetCreatorDetailUseCaseProtocol).self)!
            let getTagListByTagIdListUseCase = resolver.resolve((any GetTagListByTagIdListUseCaseProtocol).self)!
            let toggleFavoriteCreatorUseCase = resolver.resolve((any ToggleFavoriteCreatorUseCaseProtocol).self)!
            let checkAlreadyFavoriteCreatorUseCase = resolver.resolve((any CheckAlreadyFavoriteCreatorUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return CreatorDetailViewModel(
                    creator: creator,
                    getCreatorDetailUseCase: getCreatorDetailUseCase,
                    getTagListByTagIdListUseCase: getTagListByTagIdListUseCase,
                    toggleFavoriteCreatorUseCase: toggleFavoriteCreatorUseCase,
                    checkAlreadyFavoriteCreatorUseCase: checkAlreadyFavoriteCreatorUseCase
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
            let getPopularCreatorsUseCase = resolver.resolve(GetPopularCreatorsUseCase.self)!
            let searchTagsWithAlgoliaUseCase = resolver.resolve((any SearchTagsWithAlgoliaUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return SearchViewModel(
                    searchTagsByNameUseCase: searchTagsByNameUseCase,
                    searchCreatorsByTagsUseCase: searchCreatorsByTagsUseCase,
                    saveSearchHistoryUseCase: saveSearchHistoryUseCase,
                    getSearchHistoryUseCase: getSearchHistoryUseCase,
                    clearSearchHistoryUseCase: clearSearchHistoryUseCase,
                    getPopularCreatorsUseCase: getPopularCreatorsUseCase,
                    searchTagsWithAlgoliaUseCase: searchTagsWithAlgoliaUseCase
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
        
        // Account screen
        container.register(AccountViewModel.self) { resolver in
            let deleteAccountUseCase = resolver.resolve((any DeleteAccountUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return AccountViewModel(deleteAccountUseCase: deleteAccountUseCase)
            }
        }.inObjectScope(.transient)
        
        // Setting screen
        container.register(SettingTabViewModel.self) { resolver in
            let logoutUseCase = resolver.resolve((any LogoutUseCaseProtocol).self)!
            let deleteUseCase = resolver.resolve((any DeleteAccountUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return SettingTabViewModel(logoutUseCase: logoutUseCase, deleteUseCase: deleteUseCase)
            }
        }.inObjectScope(.transient)
        
        container.register((any FavoriteViewModelProtocol).self) { resolver in
            resolver.resolve(FavoriteViewModel.self)!
        }.inObjectScope(.transient)
        
        // 公式からのお知らせ
        container.register((any NotificationTabViewViewModelProtocol).self) { resolver in
            let getNotificationUseCase = resolver.resolve((any GetOfficialNotificationUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return NotificationTabViewViewModel(getOfficialNotificationUseCase: getNotificationUseCase)
            }
        }.inObjectScope(.transient)
        
        // 開発状況
        container.register(DevelopmentTabViewViewModel.self) { resolver in
            let getDevelopmentStatusUseCase = resolver.resolve((any GetDevelopmentStatusUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return DevelopmentTabViewViewModel(getDevelopmentStatusUseCase: getDevelopmentStatusUseCase)
            }
        }.inObjectScope(.transient)
        
        container.register((any DevelopmentTabViewViewModelProtocol).self) { resolver in
            resolver.resolve(DevelopmentTabViewViewModel.self)!
        }.inObjectScope(.transient)
        
        // バグ状況
        container.register(BugTabViewViewModel.self) { resolver in
            let getBugStatusUseCase = resolver.resolve((any GetBugStatusUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return BugTabViewViewModel(getBugStatusUseCase: getBugStatusUseCase)
            }
        }.inObjectScope(.transient)
        
        container.register((any BugTabViewViewModelProtocol).self) { resolver in
            resolver.resolve(BugTabViewViewModel.self)!
        }.inObjectScope(.transient)
    }
}
