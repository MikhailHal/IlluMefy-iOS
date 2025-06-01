//
//  UseCaseWithParametersAsyncProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/12.
//

import Foundation

/// Base protocol for all asynchronous use cases with parameters
protocol UseCaseWithParametersAsyncProtocol {
    associatedtype Request
    associatedtype Response
    
    /// Executes the use case with the given request
    /// - Parameter request: The request parameters
    /// - Returns: The response from the use case
    /// - Throws: An error if validation fails or the operation fails
    func execute(request: Request) async throws -> Response
    
    /// Validates the request parameters before execution
    /// - Parameter request: The request to validate
    /// - Throws: An error if validation fails
    func validate(request: Request) throws
}

/// Default implementation for validation
extension UseCaseWithParametersAsyncProtocol {
    /// Default validation that does nothing (always passes)
    func validate(request: Request) throws {
        // Default implementation does nothing
    }
}