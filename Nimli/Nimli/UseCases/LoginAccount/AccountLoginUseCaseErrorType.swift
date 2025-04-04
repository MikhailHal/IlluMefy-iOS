//
//  AccountLoginUseCaseError.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//
import FirebaseAuth
enum AccountLoginUseCaseError: UseCaseErrorProtocol {
    case success
    case wrongPassword
    case invalidEmail
    case invalidCredential
    case userNotFound
    case userDisabled
    case tooManyRequests
    case networkError
    case unknown(Error)
    
    var code: Int {
        switch self {
        case .success: return 0
        case .wrongPassword: return 2001
        case .invalidEmail: return 2002
        case .invalidCredential: return 2003
        case .userNotFound: return 2004
        case .userDisabled: return 2005
        case .tooManyRequests: return 2006
        case .networkError: return 2007
        case .unknown: return 2008
        }
    }
    
    var message: String {
        switch self {
        case .success: return ""
        case .wrongPassword: return ErrorMessages.Auth.wrongPassword
        case .invalidEmail: return ErrorMessages.Auth.invalidEmail
        case .invalidCredential: return ErrorMessages.Auth.invalidCredential
        case .userNotFound: return ErrorMessages.Auth.userNotFound
        case .userDisabled: return ErrorMessages.Auth.userDisabled
        case .tooManyRequests: return ErrorMessages.Auth.tooManyRequests
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
    
    static func from(_ error: Error) -> AccountLoginUseCaseError {
        if let useCaseError = error as? AccountLoginUseCaseError {
            return useCaseError
        }
        
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.wrongPassword.rawValue:
            return .wrongPassword
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
        case AuthErrorCode.invalidCredential.rawValue:
            return .invalidCredential
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound
        case AuthErrorCode.userDisabled.rawValue:
            return .userDisabled
        case AuthErrorCode.tooManyRequests.rawValue:
            return .tooManyRequests
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        default:
            return .unknown(error)
        }
    }
}
