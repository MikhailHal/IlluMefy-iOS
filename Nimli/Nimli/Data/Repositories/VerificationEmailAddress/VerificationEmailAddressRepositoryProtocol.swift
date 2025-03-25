//
//  VerificationEmailAddressRepositoryProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/25.
//

import FirebaseAuth

protocol VerificationEmailAddressRepositoryProtocol {
    func sendVerificationMail(_ user: User) async -> Bool
}
