//
//  ErrorMessages.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/04.
//

import Foundation

enum ErrorMessages {
    enum Auth {
        static let invalidEmail = "Invalid email format"
        static let invalidPassword = "Invalid password format"
        static let wrongPassword = "Incorrect password"
        static let userNotFound = "User not found"
        static let userDisabled = "User account is disabled"
        static let tooManyRequests = "Too many requests. Please try again later"
        static let networkError = "Network error occurred"
        static let invalidCredential = "Invalid credentials"
        static let alreadyRegistered = "Email is already registered"
        static let unknownError = "An unknown error occurred"
    }
    
    enum LocalStorage {
        static let readError = "Failed to read data from local storage"
        static let writeError = "Failed to write data to local storage"
        static let invalidFormat = "Invalid data format"
    }
    
    enum EmailVerification {
        static let sendError = "Failed to send verification email"
        static let unknownUser = "User information is not available"
    }
    
    static func getMessage(for error: Error) -> String {
        if let useCaseError = error as? UseCaseErrorProtocol {
            return useCaseError.message
        }
        if let repositoryError = error as? RepositoryErrorProtocol {
            return repositoryError.message
        }
        return "An unexpected error occurred"
    }
}
