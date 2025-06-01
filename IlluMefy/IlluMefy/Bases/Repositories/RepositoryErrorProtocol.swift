//
//  RepositoryErrorProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/04.
//

import Foundation

/// Base protocol for repository errors
protocol RepositoryErrorProtocol: Error {
    /// Unique error code
    var code: Int { get }
    
    /// Human-readable error message
    var message: String { get }
    
    /// The underlying error that caused this error, if any
    var underlyingError: Error? { get }
}

/// Common repository errors that can be reused across repositories
enum CommonRepositoryError: RepositoryErrorProtocol {
    case networkError(underlyingError: Error?)
    case decodingError(underlyingError: Error?)
    case encodingError(underlyingError: Error?)
    case notFound
    case unauthorized
    case serverError(message: String, underlyingError: Error?)
    case unknown(underlyingError: Error?)
    
    var code: Int {
        switch self {
        case .networkError: return 1001
        case .decodingError: return 1002
        case .encodingError: return 1003
        case .notFound: return 1004
        case .unauthorized: return 1005
        case .serverError: return 1006
        case .unknown: return 1999
        }
    }
    
    var message: String {
        switch self {
        case .networkError: return "Network connection error"
        case .decodingError: return "Failed to decode response"
        case .encodingError: return "Failed to encode request"
        case .notFound: return "Resource not found"
        case .unauthorized: return "Unauthorized access"
        case .serverError(let message, _): return message
        case .unknown: return "An unknown error occurred"
        }
    }
    
    var underlyingError: Error? {
        switch self {
        case .networkError(let error),
             .decodingError(let error),
             .encodingError(let error),
             .serverError(_, let error),
             .unknown(let error):
            return error
        case .notFound, .unauthorized:
            return nil
        }
    }
}