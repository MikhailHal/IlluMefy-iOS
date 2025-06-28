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
}