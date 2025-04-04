//
//  AccountLoginError.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//
import FirebaseAuth
import Foundation
struct AccountLoginError: RepositoryErrorProtocol {
    let code: Int
    let message: String
    let underlyingError: Error?
    
    static func from(_ error: Error) -> AccountLoginError {
        if let nsError = error as? NSError {
            switch nsError.code {
            case AuthErrorCode.wrongPassword.rawValue:
                return AccountLoginError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.wrongPassword,
                    underlyingError: error
                )
            case AuthErrorCode.invalidEmail.rawValue:
                return AccountLoginError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.invalidEmail,
                    underlyingError: error
                )
            case AuthErrorCode.invalidCredential.rawValue:
                return AccountLoginError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.invalidCredential,
                    underlyingError: error
                )
            case AuthErrorCode.userNotFound.rawValue:
                return AccountLoginError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.userNotFound,
                    underlyingError: error
                )
            case AuthErrorCode.userDisabled.rawValue:
                return AccountLoginError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.userDisabled,
                    underlyingError: error
                )
            case AuthErrorCode.tooManyRequests.rawValue:
                return AccountLoginError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.tooManyRequests,
                    underlyingError: error
                )
            case AuthErrorCode.networkError.rawValue:
                return AccountLoginError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.networkError,
                    underlyingError: error
                )
            default:
                return AccountLoginError(
                    code: nsError.code,
                    message: ErrorMessages.Auth.unknownError,
                    underlyingError: error
                )
            }
        }
        
        // NSError以外のエラーの場合
        return AccountLoginError(
            code: -1,
            message: ErrorMessages.Auth.unknownError,
            underlyingError: error
        )
    }
}
