//
//  APIError.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/10.
//

enum APIError: Error {
    case notAuthenticated
    case unauthorized
    case notFound
    case serverError(message: String)
    case networkError
    case unknown
}
