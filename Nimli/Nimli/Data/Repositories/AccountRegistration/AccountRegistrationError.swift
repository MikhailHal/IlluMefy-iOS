//
//  AccountRegistrationError.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/13.
//
import Foundation
import FirebaseAuth
struct AccountRegistrationError: RepositoryErrorProtocol {
    let code: Int
    let message: String
    let underlyingError: Error?
    
    static func from(_ error: Error) -> AccountRegistrationError {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return AccountRegistrationError(
                code: nsError.code,
                message: ErrorMessages.Auth.alreadyRegistered,
                underlyingError: error
            )
        case AuthErrorCode.invalidEmail.rawValue:
            return AccountRegistrationError(
                code: nsError.code,
                message: ErrorMessages.Auth.invalidEmail,
                underlyingError: error
            )
        case AuthErrorCode.weakPassword.rawValue:
            return AccountRegistrationError(
                code: nsError.code,
                message: ErrorMessages.Auth.invalidPassword,
                underlyingError: error
            )
        default:
            return AccountRegistrationError(
                code: nsError.code,
                message: ErrorMessages.Auth.unknownError,
                underlyingError: error
            )
        }
    }
}
