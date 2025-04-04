//
//  RegisterAccountError.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/12.
//
import FirebaseAuth
enum RegisterAccountUseCaseError: UseCaseErrorProtocol {
    case success
    case invalidEmail
    case invalidPassword
    case alreadyRegistered
    case networkError
    case unknown(Error)
    
    var code: Int {
        switch self {
        case .success: return 0
        case .invalidEmail: return 1001
        case .invalidPassword: return 1002
        case .alreadyRegistered: return 1003
        case .networkError: return 1004
        case .unknown: return 1005
        }
    }
    
    var message: String {
        switch self {
        case .success: return ""
        case .invalidEmail: return ErrorMessages.Auth.invalidEmail
        case .invalidPassword: return ErrorMessages.Auth.invalidPassword
        case .alreadyRegistered: return ErrorMessages.Auth.alreadyRegistered
        case .networkError: return ErrorMessages.Auth.networkError
        case .unknown: return ErrorMessages.Auth.unknownError
        }
    }
    
    var underlyingError: Error? {
        switch self {
        case .unknown(let error): return error
        default: return nil
        }
    }
    
    static func from(_ error: Error) -> RegisterAccountUseCaseError {
        if let useCaseError = error as? RegisterAccountUseCaseError {
            return useCaseError
        }
        if let repositoryError = error as? AccountRegistrationError {
            switch repositoryError.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                return .alreadyRegistered
            case AuthErrorCode.invalidEmail.rawValue:
                return .invalidEmail
            case AuthErrorCode.weakPassword.rawValue:
                return .invalidPassword
            default:
                return .unknown(error)
            }
        }
        return .unknown(error)
    }
}
