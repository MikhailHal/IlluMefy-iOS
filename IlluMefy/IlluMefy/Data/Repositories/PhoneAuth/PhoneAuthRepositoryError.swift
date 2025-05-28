//
//  PhoneAuthRepositoryError.swift
//  IlluMefy
//
//  電話番号認証リポジトリのエラー定義
//

import Foundation

/// 電話番号認証リポジトリのエラー
enum PhoneAuthRepositoryError: RepositoryErrorProtocol {
    /// ネットワークエラー
    case networkError
    /// 認証コード送信失敗
    case failedToSendCode
    /// 無効な電話番号形式
    case invalidPhoneNumber
    /// 認証コードが無効
    case invalidVerificationCode
    /// 認証コードの有効期限切れ
    case verificationCodeExpired
    /// 送信制限に到達
    case quotaExceeded
    /// 内部エラー
    case internalError
    /// 不明なエラー
    case unknownError
    
    // MARK: - RepositoryErrorProtocol
    
    var code: Int {
        switch self {
        case .networkError:
            return 1001
        case .failedToSendCode:
            return 1002
        case .invalidPhoneNumber:
            return 1003
        case .invalidVerificationCode:
            return 1004
        case .verificationCodeExpired:
            return 1005
        case .quotaExceeded:
            return 1006
        case .internalError:
            return 1007
        case .unknownError:
            return 1099
        }
    }
    
    var message: String {
        switch self {
        case .networkError:
            return L10n.PhoneAuth.Error.networkError
        case .failedToSendCode:
            return L10n.PhoneAuth.Error.failedToSendCode
        case .invalidPhoneNumber:
            return L10n.PhoneAuth.Error.invalidPhoneNumber
        case .invalidVerificationCode:
            return L10n.PhoneAuth.Error.invalidVerificationCode
        case .verificationCodeExpired:
            return L10n.PhoneAuth.Error.verificationCodeExpired
        case .quotaExceeded:
            return L10n.PhoneAuth.Error.quotaExceeded
        case .internalError:
            return L10n.PhoneAuth.Error.internalError
        case .unknownError:
            return L10n.PhoneAuth.Error.unknownError
        }
    }
    
    static func from(_ error: Error) -> PhoneAuthRepositoryError {
        // Firebaseのエラーコードに基づいてマッピング
        let nsError = error as NSError
        
        switch nsError.code {
        case 17010: // 無効な電話番号
            return .invalidPhoneNumber
        case 17042: // クォータ超過
            return .quotaExceeded
        case 17020: // ネットワークエラー
            return .networkError
        case 17044: // 無効な認証コード
            return .invalidVerificationCode
        case 17051: // 認証コード期限切れ
            return .verificationCodeExpired
        default:
            return .unknownError
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return L10n.PhoneAuth.Error.networkError
        case .failedToSendCode:
            return L10n.PhoneAuth.Error.failedToSendCode
        case .invalidPhoneNumber:
            return L10n.PhoneAuth.Error.invalidPhoneNumber
        case .invalidVerificationCode:
            return L10n.PhoneAuth.Error.invalidVerificationCode
        case .verificationCodeExpired:
            return L10n.PhoneAuth.Error.verificationCodeExpired
        case .quotaExceeded:
            return L10n.PhoneAuth.Error.quotaExceeded
        case .internalError:
            return L10n.PhoneAuth.Error.internalError
        case .unknownError:
            return L10n.PhoneAuth.Error.unknownError
        }
    }
}