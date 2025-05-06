//
//  UserPreferencesRepositoryError.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/04.
//
import Foundation
struct UserPreferencesRepositoryError: RepositoryErrorProtocol {
    let code: Int
    let message: String
    let underlyingError: Error?
    
    static func from(_ error: Error) -> UserPreferencesRepositoryError {
        let nsError = error as NSError
        return UserPreferencesRepositoryError(
            code: nsError.code,
            message: ErrorMessages.LocalStorage.readError,
            underlyingError: error
        )
    }
}
