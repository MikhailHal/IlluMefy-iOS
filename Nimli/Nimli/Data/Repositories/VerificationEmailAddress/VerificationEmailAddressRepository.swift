//
//  VerificationEmailAddressRepository.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/25.
//

import FirebaseAuth

class VerificationEmailAddressRepository: VerificationEmailAddressRepositoryProtocol {
    func sendVerificationMail(_ user: FirebaseAuth.User) async -> Bool {
        var result: Bool = true
        user.sendEmailVerification { error in
            if error != nil {
                result = false
            }
        }
        return result
    }
}
