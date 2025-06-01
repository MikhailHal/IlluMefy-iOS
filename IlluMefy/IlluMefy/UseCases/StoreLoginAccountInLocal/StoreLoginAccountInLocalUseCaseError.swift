//
//  StoreLoginAccounInLocaltUseCaseError.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

enum StoreLoginAccountInLocalUseCaseError: UseCaseErrorProtocol {
    case readError
    case invalidFormat
    case unknown(Error)
    
    var code: Int {
        switch self {
        case .readError: return 3001
        case .invalidFormat: return 3002
        case .unknown: return 3003
        }
    }
    
    var message: String {
        switch self {
        case .readError: return ErrorMessages.LocalStorage.readError
        case .invalidFormat: return ErrorMessages.LocalStorage.invalidFormat
        case .unknown: return ErrorMessages.Auth.unknownError
        }
    }
    
    var underlyingError: Error? {
        switch self {
        case .unknown(let error): return error
        default: return nil
        }
    }
    
    static func from(_ error: Error) -> StoreLoginAccountInLocalUseCaseError {
        if let useCaseError = error as? StoreLoginAccountInLocalUseCaseError {
            return useCaseError
        }
        return .unknown(error)
    }
}
