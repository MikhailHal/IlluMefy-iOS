//
//  VerifyPhoneAuthCodeUseCaseError.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//
//  電話番号認証コード検証ユースケースのエラー
//

import Foundation

/// 電話番号認証コード検証ユースケースのエラー
enum VerifyPhoneAuthCodeUseCaseError: UseCaseErrorProtocol {
    /// 無効な認証コード
    case invalidVerificationCode
    /// 認証コードの有効期限切れ
    case verificationCodeExpired
    /// ネットワークエラー
    case networkError
    /// その他のエラー
    case unknown
    
    // MARK: - UseCaseErrorProtocol
    
    var code: Int {
        switch self {
        case .invalidVerificationCode:
            return 3001
        case .verificationCodeExpired:
            return 3002
        case .networkError:
            return 3003
        case .unknown:
            return 3099
        }
    }
    
    var message: String {
        switch self {
        case .invalidVerificationCode:
            return L10n.PhoneVerification.Error.invalidVerificationCode
        case .verificationCodeExpired:
            return L10n.PhoneVerification.Error.verificationCodeExpired
        case .networkError:
            return L10n.PhoneAuth.Error.networkError
        case .unknown:
            return L10n.PhoneAuth.Error.unknownError
        }
    }
    
    var underlyingError: Error? {
        return nil
    }
    
    static func from(_ error: Error) -> VerifyPhoneAuthCodeUseCaseError {
        if let repositoryError = error as? PhoneAuthRepositoryError {
            switch repositoryError {
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
        return .unknown
    }
    
    var errorDescription: String? {
        return message
    }
}
