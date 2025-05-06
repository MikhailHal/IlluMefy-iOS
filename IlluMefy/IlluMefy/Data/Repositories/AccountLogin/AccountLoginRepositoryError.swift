//
//  AccountLoginRepositoryError.swift
//  IlluMefy
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
        let nsError = error as NSError
        return AccountLoginRepositoryError(
            code: nsError.code,
            message: getErrorMessage(for: nsError.code),
            underlyingError: error
        )
    }
    
    private static func getErrorMessage(for code: Int) -> String {
        switch code {
        case AuthErrorCode.wrongPassword.rawValue:
            return ErrorMessages.Auth.wrongPassword
        case AuthErrorCode.invalidCredential.rawValue:
            return ErrorMessages.Auth.invalidCredential
        case AuthErrorCode.invalidEmail.rawValue:
            return ErrorMessages.Auth.invalidEmail
        case AuthErrorCode.userNotFound.rawValue:
            return ErrorMessages.Auth.userNotFound
        case AuthErrorCode.userDisabled.rawValue:
            return ErrorMessages.Auth.userDisabled
        case AuthErrorCode.tooManyRequests.rawValue:
            return ErrorMessages.Auth.tooManyRequests
        case AuthErrorCode.networkError.rawValue:
            return ErrorMessages.Auth.networkError
        default:
            return ErrorMessages.Auth.unknownError
        }
    }
}
