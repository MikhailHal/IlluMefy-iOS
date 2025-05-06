//
//  UserRegistrationWithEmailAndPasswordRequest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/13.
//

/// To register new account.
/// - parameter email: registration email address
/// - parameter password: registration password
struct UserRegistrationWithEmailAndPasswordRequest {
    var email: String
    var password: String
    func makeMe(email: String, password: String) -> UserRegistrationWithEmailAndPasswordRequest {
        return UserRegistrationWithEmailAndPasswordRequest(email: email, password: password)
    }
}
