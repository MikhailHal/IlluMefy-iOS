//
//  RegisterAccountUseCaseError.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//
//  アカウント登録ユースケースのエラー
//

import Foundation

/// アカウント登録ユースケースのエラー
enum RegisterAccountUseCaseError: UseCaseErrorProtocol {
    /// メールアドレスが既に使用されている
    case emailAlreadyExists
    /// 無効なメールアドレス形式
    case invalidEmailFormat
    /// ネットワークエラー
    case networkError
    /// その他のエラー
    case unknown
    
    // MARK: - UseCaseErrorProtocol
    
    var code: Int {
        switch self {
        case .emailAlreadyExists:
            return 4001
        case .invalidEmailFormat:
            return 4002
        case .networkError:
            return 4003
        case .unknown:
            return 4099
        }
    }
    
    var message: String {
        switch self {
        case .emailAlreadyExists:
            return L10n.PhoneAuth.Error.unknownError
        case .invalidEmailFormat:
            return L10n.PhoneAuth.Error.invalidPhoneNumber // 適切なメッセージがないため暫定的に使用
        case .networkError:
            return L10n.PhoneAuth.Error.networkError
        case .unknown:
            return L10n.PhoneAuth.Error.unknownError
        }
    }
    
    var underlyingError: Error? {
        return nil
    }
    
    static func from(_ error: Error) -> RegisterAccountUseCaseError {
        if let repositoryError = error as? AccountLoginRepositoryError {
            switch repositoryError {
            case .userAlreadyExists:
                return .emailAlreadyExists
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
