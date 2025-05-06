//
//  VerificationEmailAddressUseCaseError.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/25.
//

enum VerificationEmailAddressUseCaseError: UseCaseErrorProtocol {
    case success
    case sendError
    case unknownUser
    case unknown(Error)
    
    var code: Int {
        switch self {
        case .success: return 0
        case .sendError: return 4001
        case .unknownUser: return 4002
        case .unknown: return 4003
        }
    }
    
    var message: String {
        switch self {
        case .success: return ""
        case .sendError: return ErrorMessages.EmailVerification.sendError
        case .unknownUser: return ErrorMessages.EmailVerification.unknownUser
        case .unknown: return ErrorMessages.Auth.unknownError
        }
    }
    
    var underlyingError: Error? {
        switch self {
        case .unknown(let error): return error
        default: return nil
        }
    }
    
    static func from(_ error: Error) -> VerificationEmailAddressUseCaseError {
        if let useCaseError = error as? VerificationEmailAddressUseCaseError {
            return useCaseError
        }
        return .unknown(error)
    }
}
