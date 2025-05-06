//
//  AccountLoginRequest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

/// To login existed account.
/// - parameter email: login email address
/// - parameter password: login password
struct AccountLoginRequest {
    var email: String
    var password: String
    func makeMe(email: String, password: String) -> AccountLoginRequest {
        return AccountLoginRequest(email: email, password: password)
    }
}
