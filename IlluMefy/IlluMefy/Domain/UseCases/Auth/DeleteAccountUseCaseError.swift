//
//  DeleteAccountUseCaseError.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/28.
//

import Foundation

/// アカウント削除 UseCase エラー
enum DeleteAccountUseCaseError: Error, UseCaseErrorProtocol {
    case authenticationFailed
    case accountNotFound
    case networkError
    case serverError
    case unknownError
    
    var code: Int {
        switch self {
        case .authenticationFailed:
            return 3001
        case .accountNotFound:
            return 3002
        case .networkError:
            return 3003
        case .serverError:
            return 3004
        case .unknownError:
            return 3999
        }
    }
    
    var title: String {
        switch self {
        case .authenticationFailed:
            return L10n.Common.Dialog.Title.error
        case .accountNotFound:
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
        case .authenticationFailed:
            return L10n.pleaseLoginAgain
        case .accountNotFound:
            return "アカウントが見つかりませんでした"
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