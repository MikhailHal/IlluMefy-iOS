//
//  AccountLoginError.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

struct AccountLoginError: RepositoryErrorProtocol {
    var code: Int
    var message: String
}
