//
//  UseCaseWithParametersSyncProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/04.
//

// All synchronous usecases will be required to inherit this.
protocol UseCaseWithParametersSyncProtocol {
    associatedtype Request
    associatedtype Response
    associatedtype Error: UseCaseErrorProtocol
    
    /// To call the method of repository.
    /// Restrict repository method calls to this function only.
    ///
    ///  - Parameters:
    ///     - request: request parameters
    ///
    ///  - Returns: result of operation
    func execute(request: Request) throws -> Response
    
    /// Validates the parameters.
    /// If the inherited class has no parameters, this function should be empty and return a successful status.
    ///
    ///  - Returns: Result of validation
    func checkParameterValidation(request: Request) throws -> Error
}
