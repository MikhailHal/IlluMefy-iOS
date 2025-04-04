//
//  VerificationEmailAddressRepositoryError.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/25.
//

import Foundation

struct VerificationEmailAddressRepositoryError: RepositoryErrorProtocol {
    let code: Int
    let message: String
    let underlyingError: Error?
    
    static func from(_ error: Error) -> VerificationEmailAddressRepositoryError {
        let nsError = error as NSError
        return VerificationEmailAddressRepositoryError(
            code: nsError.code,
            message: ErrorMessages.EmailVerification.sendError,
            underlyingError: error
        )
    }
}
