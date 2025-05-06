//
//  UseCaseErrorProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/12.
//

// All usecase errors will be required to inherit this.
protocol UseCaseErrorProtocol: Error {
    var code: Int { get }
    var message: String { get }
    var underlyingError: Error? { get }
    
    static func from(_ error: Error) -> Self
}

extension UseCaseErrorProtocol {
    var underlyingError: Error? { nil }
}
