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