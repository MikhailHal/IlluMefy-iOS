//
//  UseCaseBase.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/12.
//

// All usecases will be required to inherit this.
protocol UseCaseProtocol {
    associatedtype Request
    associatedtype Response
    associatedtype UseCaseError: UseCaseErrorProtocol
    /// To call the method of repository.
    /// Restrict repository method calls to this function only.
    ///
    ///  - Parameters:
    ///     - request: api-request
    ///
    ///  - Returns: result of api-call
    func execute(request: Request) async throws -> Response
    /// Validates the parameters.
    /// If the inherited class has no parameters, this function should be empty and return a successful status.
    ///
    ///  - Returns: Result of validation
    func checkParameterValidation() -> UseCaseError
}
