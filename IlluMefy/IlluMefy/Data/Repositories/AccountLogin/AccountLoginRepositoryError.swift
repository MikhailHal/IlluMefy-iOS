//
//  AccountLoginRepositoryError.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

import Foundation
import FirebaseAuth

enum AccountLoginRepositoryError: RepositoryErrorProtocol {
    case wrongPassword
    case invalidCredential
    case invalidEmail
    case userNotFound
    case userDisabled
    case tooManyRequests
    case networkError
    case userAlreadyExists
    case unknownError
    
    var code: Int {
        switch self {
        case .wrongPassword:
            return AuthErrorCode.wrongPassword.rawValue
        case .invalidCredential:
            return AuthErrorCode.invalidCredential.rawValue
        case .invalidEmail:
            return AuthErrorCode.invalidEmail.rawValue
        case .userNotFound:
            return AuthErrorCode.userNotFound.rawValue
        case .userDisabled:
            return AuthErrorCode.userDisabled.rawValue
        case .tooManyRequests:
            return AuthErrorCode.tooManyRequests.rawValue
        case .networkError:
            return AuthErrorCode.networkError.rawValue
        case .userAlreadyExists:
            return AuthErrorCode.emailAlreadyInUse.rawValue
        case .unknownError:
            return 99999
        }
    }
    
    var message: String {
        switch self {
        case .wrongPassword:
            return ErrorMessages.Auth.wrongPassword
        case .invalidCredential:
            return ErrorMessages.Auth.invalidCredential
        case .invalidEmail:
            return ErrorMessages.Auth.invalidEmail
        case .userNotFound:
            return ErrorMessages.Auth.userNotFound
        case .userDisabled:
            return ErrorMessages.Auth.userDisabled
        case .tooManyRequests:
            return ErrorMessages.Auth.tooManyRequests
        case .networkError:
            return ErrorMessages.Auth.networkError
        case .userAlreadyExists:
            return L10n.PhoneAuth.Error.unknownError
        case .unknownError:
            return ErrorMessages.Auth.unknownError
        }
    }
    
    var underlyingError: Error? {
        return nil
    }
    
    static func from(_ error: Error) -> AccountLoginRepositoryError {
        let nsError = error as NSError
        
        switch nsError.code {
        case AuthErrorCode.wrongPassword.rawValue:
            return .wrongPassword
        case AuthErrorCode.invalidCredential.rawValue:
            return .invalidCredential
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound
        case AuthErrorCode.userDisabled.rawValue:
            return .userDisabled
        case AuthErrorCode.tooManyRequests.rawValue:
            return .tooManyRequests
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .userAlreadyExists
        default:
            return .unknownError
        }
    }
}
