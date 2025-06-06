//
//  VerifyPhoneAuthCodeUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//
//  電話番号認証コード検証ユースケースの実装
//

import Foundation

/// 電話番号認証コード検証ユースケースの実装
final class VerifyPhoneAuthCodeUseCase: VerifyPhoneAuthCodeUseCaseProtocol {
    
    // MARK: - Properties
    
    private let phoneAuthRepository: PhoneAuthRepositoryProtocol
    
    // MARK: - Initialization
    
    init(phoneAuthRepository: PhoneAuthRepositoryProtocol) {
        self.phoneAuthRepository = phoneAuthRepository
    }
    
    // MARK: - VerifyPhoneAuthCodeUseCaseProtocol
    
    func execute(request: VerifyPhoneAuthCodeUseCaseRequest) async throws -> VerifyPhoneAuthCodeUseCaseResponse {
        // パラメータバリデーション
        try validate(request: request)
        
        do {
            // リポジトリ用のリクエストを作成
            let repositoryRequest = VerifyPhoneAuthCodeRequest(
                verificationID: request.verificationID,
                verificationCode: request.verificationCode
            )
            
            // 認証コードの検証
            let response = try await phoneAuthRepository.verifyPhoneAuthCode(request: repositoryRequest)
            
            // レスポンスを返す
            return VerifyPhoneAuthCodeUseCaseResponse(credential: response.credential)
            
        } catch let error as PhoneAuthRepositoryError {
            // リポジトリエラーをユースケースエラーに変換
            throw mapRepositoryError(error)
        } catch {
            throw VerifyPhoneAuthCodeUseCaseError.unknown
        }
    }
    
    // MARK: - Private Methods
    
    /// リクエストのバリデーション
    private func validate(request: VerifyPhoneAuthCodeUseCaseRequest) throws {
        // 認証コードが6桁の数字であることを確認
        let code = request.verificationCode
        guard code.count == 6,
              code.allSatisfy({ $0.isNumber }) else {
            throw VerifyPhoneAuthCodeUseCaseError.invalidVerificationCode
        }
        
        // verificationIDが空でないことを確認
        guard !request.verificationID.isEmpty else {
            throw VerifyPhoneAuthCodeUseCaseError.invalidVerificationCode
        }
    }
    
    /// リポジトリエラーをユースケースエラーにマッピング
    private func mapRepositoryError(_ error: PhoneAuthRepositoryError) -> VerifyPhoneAuthCodeUseCaseError {
        switch error {
        case .invalidVerificationCode:
            return .invalidVerificationCode
        case .verificationCodeExpired:
            return .verificationCodeExpired
        case .networkError:
            return .networkError
        default:
            return .unknown
        }
    }
}
