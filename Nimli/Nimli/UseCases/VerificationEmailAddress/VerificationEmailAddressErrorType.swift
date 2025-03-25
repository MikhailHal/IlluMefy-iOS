//
//  VerificationEmailAddressUseCaseError.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/25.
//

enum VerificationEmailAddressUseCaseError: UseCaseErrorProtocol {
    case success
    case sendError
    case unknownUser
}
