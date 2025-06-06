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
    
    // MARK: - Properties
    
    private let firebaseProvider: FirebasePhoneAuthProviderProtocol
    
    // MARK: - Initialization
    
    init(firebaseProvider: FirebasePhoneAuthProviderProtocol = FirebasePhoneAuthProvider()) {
        self.firebaseProvider = firebaseProvider
    }
    
    // MARK: - PhoneAuthRepositoryProtocol
    
    /// 認証コードを送信
    func sendVerificationCode(request: SendVerificationCodeRequest) async throws -> SendVerificationCodeResponse {
        let verificationID =
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
            firebaseProvider.verifyPhoneNumber(request.phoneNumber, uiDelegate: nil) { verificationID, error in
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
        do {
            let userID = try await firebaseProvider.signInWithVerificationCode(
                verificationID: request.verificationID,
                verificationCode: request.verificationCode
            )
            return VerifyCodeResponse(userID: userID)
        } catch {
            throw mapFirebaseError(error)
        }
    }
    
    /// 認証コードを検証（サインインなし）
    func verifyPhoneAuthCode(request: VerifyPhoneAuthCodeRequest) async throws -> VerifyPhoneAuthCodeResponse {
        do {
            // Firebase認証のCredentialを生成
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: request.verificationID,
                verificationCode: request.verificationCode
            )
            
            // Credentialをそのまま返す（実際のサインインはAccountLoginRepositoryで行う）
            return VerifyPhoneAuthCodeResponse(credential: credential)
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
