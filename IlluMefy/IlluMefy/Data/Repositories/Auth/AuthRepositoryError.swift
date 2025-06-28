//
//  AuthRepositoryError.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/28.
//

import Foundation

/// 認証リポジトリエラー
enum AuthRepositoryError: Error, RepositoryErrorProtocol {
    case userNotAuthenticated
    case userNotFound
    case invalidCredentials
    case networkError
    case serverError
    case unknownError
    
    var code: Int {
        switch self {
        case .userNotAuthenticated:
            return 4001
        case .userNotFound:
            return 4002
        case .invalidCredentials:
            return 4003
        case .networkError:
            return 4004
        case .serverError:
            return 4005
        case .unknownError:
            return 4999
        }
    }
    
    var title: String {
        switch self {
        case .userNotAuthenticated:
            return L10n.authenticationRequired
        case .userNotFound:
            return L10n.Common.Dialog.Title.error
        case .invalidCredentials:
            return L10n.Common.Dialog.Title.error
        case .networkError:
            return L10n.Common.Dialog.Title.error
        case .serverError:
            return L10n.Common.Dialog.Title.error
        case .unknownError:
            return L10n.Common.Dialog.Title.error
        }
    }
    
    var message: String {
        switch self {
        case .userNotAuthenticated:
            return L10n.pleaseLoginAgain
        case .userNotFound:
            return "ユーザーが見つかりません"
        case .invalidCredentials:
            return "認証情報が無効です"
        case .networkError:
            return L10n.loadingFailed
        case .serverError:
            return L10n.tryAgainLater
        case .unknownError:
            return L10n.tryAgainLater
        }
    }
    
    var underlyingError: Error? {
        return nil
    }
}