//
//  UserPreferencesRepositoryError.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/04.
//
import Foundation
struct UserPreferencesRepositoryError: RepositoryErrorProtocol {
    let code: Int
    let message: String
    let underlyingError: Error?
    
    static func from(_ error: Error) -> UserPreferencesRepositoryError {
        if let nsError = error as? NSError {
            return UserPreferencesRepositoryError(
                code: nsError.code,
                message: ErrorMessages.LocalStorage.readError,
                underlyingError: error
            )
        }
        
        return UserPreferencesRepositoryError(
            code: -1,
            message: ErrorMessages.LocalStorage.readError,
            underlyingError: error
        )
    }
} 
