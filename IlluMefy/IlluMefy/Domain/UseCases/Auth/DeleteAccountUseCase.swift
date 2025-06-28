//
//  DeleteAccountUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/28.
//

import Foundation

/// アカウント削除 UseCase
@MainActor
final class DeleteAccountUseCase: DeleteAccountUseCaseProtocol {
    
    private let authRepository: AuthRepositoryProtocol
    private let favoriteRepository: FavoriteRepositoryProtocol
    private let userPreferencesRepository: UserPreferencesRepositoryProtocol
    
    init(
        authRepository: AuthRepositoryProtocol,
        favoriteRepository: FavoriteRepositoryProtocol,
        userPreferencesRepository: UserPreferencesRepositoryProtocol
    ) {
        self.authRepository = authRepository
        self.favoriteRepository = favoriteRepository
        self.userPreferencesRepository = userPreferencesRepository
    }
    
    func execute() async throws -> DeleteAccountUseCaseResponse {
        do {
            // 1. 認証状態確認
            guard await authRepository.isAuthenticated() else {
                throw DeleteAccountUseCaseError.authenticationFailed
            }
            
            // 2. ローカルデータ削除（お気に入り、設定など）
            try await clearLocalData()
            
            // 3. アカウント削除（Firebase Auth）
            try await authRepository.deleteAccount()
            
            // 4. 完全ログアウト
            try await authRepository.logout()
            
            return DeleteAccountUseCaseResponse()
            
        } catch let error as AuthRepositoryError {
            throw mapAuthRepositoryError(error)
        } catch {
            throw DeleteAccountUseCaseError.unknownError
        }
    }
    
    /// ローカルデータをクリアする
    private func clearLocalData() async throws {
        // お気に入りデータ削除
        // TODO: favoriteRepository.clearAllFavorites() 実装時に有効化
        
        // ユーザー設定削除
        // TODO: userPreferencesRepository.clearAllPreferences() 実装時に有効化
    }
    
    /// AuthRepositoryError を DeleteAccountUseCaseError にマッピング
    private func mapAuthRepositoryError(_ error: AuthRepositoryError) -> DeleteAccountUseCaseError {
        switch error {
        case .userNotAuthenticated:
            return .authenticationFailed
        case .invalidCredentials:
            return .authenticationFailed
        case .networkError:
            return .networkError
        case .serverError:
            return .serverError
        case .userNotFound:
            return .accountNotFound
        case .unknownError:
            return .unknownError
        }
    }
}