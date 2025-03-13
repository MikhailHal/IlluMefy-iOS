//
//  RepositoryWithoutParametersProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/13.
//

protocol RepositoryWithoutParametersProtocol {
    associatedtype DataEntityForResponse
    associatedtype DomainEntity
    associatedtype Error: RepositoryErrorProtocol
    /// Fetches default data without requiring specific parameters
    /// - Returns: The domain entity after transformation from data entity
    /// - Throws: Repository-specific errors
    func execute() async throws -> DomainEntity
    /// Transforms data entity to domain entity
    /// - Parameter dataEntity: The raw data entity from the data source
    /// - Returns: The transformed domain entity
    func transform(dataEntity: DataEntityForResponse) -> DomainEntity
}
