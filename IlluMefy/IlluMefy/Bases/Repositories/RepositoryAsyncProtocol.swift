//
//  RepositoryAsyncProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/04.
//

import Foundation

/// Base protocol for all asynchronous repository operations
protocol RepositoryAsyncProtocol {
    associatedtype Request
    associatedtype Response
    
    /// Performs the repository operation
    /// - Parameter request: The request parameters
    /// - Returns: The response from the operation
    /// - Throws: An error if the operation fails
    func execute(request: Request) async throws -> Response
}

/// Convenience protocol for repositories that don't require request parameters
protocol RepositoryAsyncWithoutParametersProtocol {
    associatedtype Response
    
    /// Performs the repository operation without parameters
    /// - Returns: The response from the operation
    /// - Throws: An error if the operation fails
    func execute() async throws -> Response
}