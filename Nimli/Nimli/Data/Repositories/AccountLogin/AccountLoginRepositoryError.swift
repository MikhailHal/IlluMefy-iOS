//
//  AccountLoginRepositoryError.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

import Foundation
import FirebaseAuth

struct AccountLoginRepositoryError: RepositoryErrorProtocol {
    let code: Int
    let message: String
    let underlyingError: Error?
    
    static func from(_ error: Error) -> AccountLoginRepositoryError {
        if let nsError = error as? NSError {
            switch nsError.code {
            case AuthErrorCode.wrongPassword.rawValue:
                return AccountLoginRepositoryError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.wrongPassword,
                    underlyingError: error
                )
            case AuthErrorCode.invalidCredential.rawValue:
                return AccountLoginRepositoryError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.invalidCredential,
                    underlyingError: error
                )
            case AuthErrorCode.invalidEmail.rawValue:
                return AccountLoginRepositoryError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.invalidEmail,
                    underlyingError: error
                )
            case AuthErrorCode.userNotFound.rawValue:
                return AccountLoginRepositoryError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.userNotFound,
                    underlyingError: error
                )
            case AuthErrorCode.userDisabled.rawValue:
                return AccountLoginRepositoryError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.userDisabled,
                    underlyingError: error
                )
            case AuthErrorCode.tooManyRequests.rawValue:
                return AccountLoginRepositoryError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.tooManyRequests,
                    underlyingError: error
                )
            case AuthErrorCode.networkError.rawValue:
                return AccountLoginRepositoryError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.networkError,
                    underlyingError: error
                )
            default:
                return AccountLoginRepositoryError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.unknownError,
                    underlyingError: error
                )
            }
        }
        
        return AccountLoginRepositoryError(
            code: -1,
            message: ErrorMessages.Auth.unknownError,
            underlyingError: error
        )
    }
} 