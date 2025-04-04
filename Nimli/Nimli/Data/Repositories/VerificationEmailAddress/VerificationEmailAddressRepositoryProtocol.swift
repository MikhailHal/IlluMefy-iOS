//
//  VerificationEmailAddressRepositoryProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/25.
//

import FirebaseAuth

protocol VerificationEmailAddressRepositoryProtocol: RepositorySyncProtocol where Request == User, Response == Bool {
    func sendVerificationMail(_ user: User) -> Bool
}
