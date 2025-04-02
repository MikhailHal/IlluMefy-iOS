//
//  AccountLoginUseCaseError.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

enum AccountLoginUseCaseError: UseCaseErrorProtocol {
    case success
    case wrongPassword
    case invalidEmail
    case invalidCredential
    case userNotFound
    case userDisabled
    case tooManyRequests
    case networkError
}
