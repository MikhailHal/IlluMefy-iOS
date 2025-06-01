//
//  RepositorySyncProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/11.
//

import Foundation

/// Base protocol for all synchronous repository operations
protocol RepositorySyncProtocol {
    associatedtype Request
    associatedtype Response
    
    /// Performs the repository operation synchronously
    /// - Parameter request: The request parameters
    /// - Returns: The response from the operation
    /// - Throws: An error if the operation fails
    func execute(request: Request) throws -> Response
}

/// Convenience protocol for repositories that don't require request parameters
protocol RepositorySyncWithoutParametersProtocol {
    associatedtype Response
    
    /// Performs the repository operation without parameters
    /// - Returns: The response from the operation
    /// - Throws: An error if the operation fails
    func execute() throws -> Response
}