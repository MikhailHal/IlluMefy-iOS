//
//  SendPhoneVerificationUseCaseError.swift
//  IlluMefy
//
//  電話番号認証コード送信ユースケースのエラー
//

import Foundation

/// 電話番号認証コード送信ユースケースのエラー
enum SendPhoneVerificationUseCaseError: UseCaseErrorProtocol {
    /// 無効な電話番号形式
    case invalidPhoneNumber
    /// ネットワークエラー
    case networkError
    /// 送信制限超過
    case quotaExceeded
    /// その他のエラー
    case unknown
    
    // MARK: - UseCaseErrorProtocol
    
    var code: Int {
        switch self {
        case .invalidPhoneNumber:
            return 2001
        case .networkError:
            return 2002
        case .quotaExceeded:
            return 2003
        case .unknown:
            return 2099
        }
    }
    
    var message: String {
        switch self {
        case .invalidPhoneNumber:
            return L10n.PhoneAuth.Error.invalidPhoneNumber
        case .networkError:
            return L10n.PhoneAuth.Error.networkError
        case .quotaExceeded:
            return L10n.PhoneAuth.Error.quotaExceeded
        case .unknown:
            return L10n.PhoneAuth.Error.unknownError
        }
    }
    
    var underlyingError: Error? {
        return nil
    }
    
    static func from(_ error: Error) -> SendPhoneVerificationUseCaseError {
        if let repositoryError = error as? PhoneAuthRepositoryError {
            switch repositoryError {
            case .invalidPhoneNumber:
                return .invalidPhoneNumber
            case .networkError:
                return .networkError
            case .quotaExceeded:
                return .quotaExceeded
            default:
                return .unknown
            }
        }
        return .unknown
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidPhoneNumber:
            return L10n.PhoneAuth.Error.invalidPhoneNumber
        case .networkError:
            return L10n.PhoneAuth.Error.networkError
        case .quotaExceeded:
            return L10n.PhoneAuth.Error.quotaExceeded
        case .unknown:
            return L10n.PhoneAuth.Error.unknownError
        }
    }
}
