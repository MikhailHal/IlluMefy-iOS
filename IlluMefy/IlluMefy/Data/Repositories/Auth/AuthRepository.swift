//
//  AuthRepository.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/28.
//

import Foundation
import FirebaseAuth

/// 認証リポジトリの実装
final class AuthRepository: AuthRepositoryProtocol {
    
    // MARK: - AuthRepositoryProtocol
    
    func signOut() async throws {
        try Auth.auth().signOut()
    }
    
    func isAuthenticated() async -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func logout() async throws {
        try Auth.auth().signOut()
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthRepositoryError.userNotAuthenticated
        }
        
        do {
            try await user.delete()
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
    }
    
    // MARK: - Private Methods
    
    /// Firebase エラーを AuthRepositoryError にマッピング
    private func mapFirebaseError(_ error: NSError) -> AuthRepositoryError {
        guard let authErrorCode = AuthErrorCode(rawValue: error.code) else {
            return .unknownError
        }
        
        switch authErrorCode {
        case .userNotFound:
            return .userNotFound
        case .invalidCredential:
            return .invalidCredentials
        case .networkError:
            return .networkError
        case .internalError:
            return .serverError
        default:
            return .unknownError
        }
    }
}