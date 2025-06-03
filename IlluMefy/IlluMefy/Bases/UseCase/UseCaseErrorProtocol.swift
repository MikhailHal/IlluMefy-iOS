//
//  UseCaseErrorProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/04.
//

import Foundation

/// Base protocol for use case errors
protocol UseCaseErrorProtocol: Error {
    /// Unique error code
    var code: Int { get }
    
    /// Human-readable error message
    var message: String { get }
    
    /// The underlying error that caused this error, if any
    var underlyingError: Error? { get }
}

/// Common use case errors that can be reused across use cases
enum CommonUseCaseError: UseCaseErrorProtocol {
    case validationFailed(message: String)
    case repositoryError(underlyingError: Error)
    case businessLogicError(message: String)
    case unauthorized
    case notFound
    case unknown(underlyingError: Error?)
    
    var code: Int {
        switch self {
        case .validationFailed: return 2001
        case .repositoryError: return 2002
        case .businessLogicError: return 2003
        case .unauthorized: return 2004
        case .notFound: return 2005
        case .unknown: return 2999
        }
    }
    
    var message: String {
        switch self {
        case .validationFailed(let message): return message
        case .repositoryError(let error):
            if let repoError = error as? RepositoryErrorProtocol {
                return repoError.message
            }
            return "Repository operation failed"
        case .businessLogicError(let message): return message
        case .unauthorized: return "Unauthorized operation"
        case .notFound: return "Resource not found"
        case .unknown: return "An unknown error occurred"
        }
    }
    
    var underlyingError: Error? {
        switch self {
        case .repositoryError(let error):
            return error
        case .unknown(let error):
            return error
        case .validationFailed, .businessLogicError, .unauthorized, .notFound:
            return nil
        }
    }
}
