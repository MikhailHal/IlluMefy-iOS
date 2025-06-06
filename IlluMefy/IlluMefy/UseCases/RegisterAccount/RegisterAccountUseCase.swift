//
//  RegisterAccountUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//
//  アカウント登録ユースケースの実装
//

import Foundation

/// アカウント登録ユースケースの実装
final class RegisterAccountUseCase: RegisterAccountUseCaseProtocol {
    
    // MARK: - Properties
    
    private let accountLoginRepository: AccountLoginRepositoryProtocol
    
    // MARK: - Initialization
    
    init(accountLoginRepository: AccountLoginRepositoryProtocol) {
        self.accountLoginRepository = accountLoginRepository
    }
    
    // MARK: - RegisterAccountUseCaseProtocol
    
    func execute(request: RegisterAccountUseCaseRequest) async throws -> RegisterAccountUseCaseResponse {
        // パラメータバリデーション
        try validate(request: request)
        
        do {
            // リポジトリ用のリクエストを作成
            let repositoryRequest = CreateAccountRequest(
                phoneNumber: request.phoneNumber,
                credential: request.credential
            )
            
            // アカウント作成
            let response = try await accountLoginRepository.createAccount(request: repositoryRequest)
            
            // レスポンスを返す
            return RegisterAccountUseCaseResponse(
                userID: response.userID,
                phoneNumber: response.phoneNumber
            )
            
        } catch let error as AccountLoginRepositoryError {
            // リポジトリエラーをユースケースエラーに変換
            throw mapRepositoryError(error)
        } catch {
            throw RegisterAccountUseCaseError.unknown
        }
    }
    
    // MARK: - Private Methods
    
    /// リクエストのバリデーション
    private func validate(request: RegisterAccountUseCaseRequest) throws {
        // 電話番号が空でないことを確認
        guard !request.phoneNumber.isEmpty else {
            throw RegisterAccountUseCaseError.unknown
        }
    }
    
    /// リポジトリエラーをユースケースエラーにマッピング
    private func mapRepositoryError(_ error: AccountLoginRepositoryError) -> RegisterAccountUseCaseError {
        switch error {
        case .userAlreadyExists:
            return .emailAlreadyExists
        case .networkError:
            return .networkError
        default:
            return .unknown
        }
    }
}
