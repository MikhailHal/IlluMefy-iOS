//
//  UseCaseWithoutParametesProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/05/07.
//

import Foundation

/// Base protocol for all asynchronous use cases without parameters
protocol UseCaseWithoutParametersAsyncProtocol {
    associatedtype Response
    
    /// Executes the use case without parameters
    /// - Returns: The response from the use case
    /// - Throws: An error if the operation fails
    func execute() async throws -> Response
}

/// Base protocol for all synchronous use cases without parameters
protocol UseCaseWithoutParametersSyncProtocol {
    associatedtype Response
    
    /// Executes the use case without parameters
    /// - Returns: The response from the use case
    /// - Throws: An error if the operation fails
    func execute() throws -> Response
}