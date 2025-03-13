//
//  AccountRegistrationError.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/13.
//

struct AcountRegistrationError: RepositoryErrorProtocol {
    var code: Int
    var message: String
}
