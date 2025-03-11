//
//  RegisterAccountError.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/12.
//

enum RegisterAccountUseCaseError: UseCaseErrorProtocol {
    case success
    case invalidEmail
    case invalidPassword
    case alreadyRegistered
    case networkError
}
