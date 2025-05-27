//
//  AccountLoginUseCaseError.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//
import FirebaseAuth
enum AccountLoginUseCaseError: UseCaseErrorProtocol {
    case success
    case wrongPassword
    case invalidEmail
    case invalidPhoneNumber
    case invalidPassword
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
        case .invalidPhoneNumber: return 2003
        case .invalidPassword: return 2004
        case .invalidCredential: return 2005
        case .userNotFound: return 2006
        case .userDisabled: return 2007
        case .tooManyRequests: return 2008
        case .networkError: return 2009
        case .unknown: return 2010
        }
    }
    
    var message: String {
        switch self {
        case .success: return ""
        case .wrongPassword: return ErrorMessages.Auth.wrongPassword
        case .invalidEmail: return ErrorMessages.Auth.invalidEmail
        case .invalidPhoneNumber: return "Invalid phone number format"
        case .invalidPassword: return ErrorMessages.Auth.invalidPassword
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
        
        if let repositoryError = error as? AccountLoginRepositoryError {
            switch repositoryError.code {
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
        
        return .unknown(error)
    }
}
