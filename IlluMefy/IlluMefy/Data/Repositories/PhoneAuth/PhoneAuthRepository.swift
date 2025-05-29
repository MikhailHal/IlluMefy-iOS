//
//  PhoneAuthRepository.swift
//  IlluMefy
//
//  電話番号認証リポジトリの実装
//

import Foundation
import FirebaseAuth

/// 電話番号認証リポジトリの実装
final class PhoneAuthRepository: PhoneAuthRepositoryProtocol {
    
    // MARK: - PhoneAuthRepositoryProtocol
    
    /// 認証コードを送信
    func sendVerificationCode(request: SendVerificationCodeRequest) async throws -> SendVerificationCodeResponse {
        let verificationID =
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
            PhoneAuthProvider.provider().verifyPhoneNumber(request.phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    // Firebaseエラーをリポジトリエラーに変換
                    let repositoryError = self.mapFirebaseError(error)
                    continuation.resume(throwing: repositoryError)
                } else if let verificationID = verificationID {
                    continuation.resume(returning: verificationID)
                } else {
                    continuation.resume(throwing: PhoneAuthRepositoryError.unknownError)
                }
            }
        }
        
        return SendVerificationCodeResponse(verificationID: verificationID)
    }
    
    /// 認証コードを検証してサインイン
    func verifyCode(request: VerifyCodeRequest) async throws -> VerifyCodeResponse {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: request.verificationID,
            verificationCode: request.verificationCode
        )
        
        do {
            let authResult = try await Auth.auth().signIn(with: credential)
            return VerifyCodeResponse(userID: authResult.user.uid)
        } catch {
            throw mapFirebaseError(error)
        }
    }
    
    // MARK: - Private Methods
    
    /// Firebaseエラーをリポジトリエラーにマッピング
    private func mapFirebaseError(_ error: Error) -> PhoneAuthRepositoryError {
        guard let errorCode = AuthErrorCode(rawValue: (error as NSError).code) else {
            return .unknownError
        }
        
        switch errorCode {
        case .networkError:
            return .networkError
        case .invalidPhoneNumber:
            return .invalidPhoneNumber
        case .invalidVerificationCode:
            return .invalidVerificationCode
        case .sessionExpired:
            return .verificationCodeExpired
        case .quotaExceeded, .tooManyRequests:
            return .quotaExceeded
        case .internalError:
            return .internalError
        default:
            return .unknownError
        }
    }
}
