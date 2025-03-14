//
//  UseCaseWithoutParametesProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/12.
//

// All usecases will be required to inherit this.
protocol UseCaseWithoutParametesProtocol {
    associatedtype Response
    associatedtype Error: UseCaseErrorProtocol
    /// To call the method of repository.
    /// Restrict repository method calls to this function only.
    ///
    ///  - Returns: result of api-call
    func execute() async throws -> Response
    /// Validates the parameters.
    /// If the inherited class has no parameters, this function should be empty and return a successful status.
    ///
    ///  - Returns: Result of validation
    func checkParameterValidation() -> Error
}
