//
//  AccountLoginUseCaseError.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

enum AccountLoginUseCaseError: UseCaseErrorProtocol {
    case success
    case invalidEmail
    case invalidPassword
    case alreadyRegistered
    case networkError
}
