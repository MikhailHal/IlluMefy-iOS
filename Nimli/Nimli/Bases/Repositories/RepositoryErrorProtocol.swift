//
//  RepositoryErrorProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/12.
//

// All repository errors will be required to inherit this.
protocol RepositoryErrorProtocol: Error {
    var code: Int { get }
    var message: String { get }
    var underlyingError: Error? { get }
    
    static func from(_ error: Error) -> Self
}

extension RepositoryErrorProtocol {
    var underlyingError: Error? { nil }
}
