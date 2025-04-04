//
//  RepositorySyncProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/04.
//

// All synchronous repositories will be required to inherit this.
protocol RepositorySyncProtocol {
    associatedtype Request
    associatedtype Response
    associatedtype Error: RepositoryErrorProtocol
    
    /// To perform the operation.
    /// This is the only method that should be called from use cases.
    ///
    ///  - Parameters:
    ///     - request: request parameters
    ///
    ///  - Returns: result of operation
    func execute(request: Request) throws -> Response
}
