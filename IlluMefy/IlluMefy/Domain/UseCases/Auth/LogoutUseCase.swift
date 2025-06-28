//
//  LogoutUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/28.
//

import Foundation

/// ログアウト処理のユースケース
protocol LogoutUseCaseProtocol {
    /// ログアウト処理を実行
    func execute() async throws
}

/// ログアウト処理のユースケース実装
final class LogoutUseCase: LogoutUseCaseProtocol {
    
    // MARK: - Dependencies
    private let authRepository: AuthRepositoryProtocol
    
    // MARK: - Initialization
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    // MARK: - LogoutUseCaseProtocol
    
    func execute() async throws {
        try await authRepository.signOut()
    }
}