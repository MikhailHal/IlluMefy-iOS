//
//  AccountLoginRequest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

/// To login existed account.
/// - parameter phoneNumber: login phone number
/// - parameter password: login password
struct AccountLoginRequest {
    var phoneNumber: String
    var password: String
    func makeMe(phoneNumber: String, password: String) -> AccountLoginRequest {
        return AccountLoginRequest(phoneNumber: phoneNumber, password: password)
    }
}
