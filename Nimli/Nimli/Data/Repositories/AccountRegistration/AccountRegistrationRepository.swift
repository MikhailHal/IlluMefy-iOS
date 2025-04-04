//
//  AccountRegistration.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/13.
//

import FirebaseAuth

class AccountRegistrationRepository: AccountRegistrationRepositoryProtocol {
    func register(_ request: UserRegistrationWithEmailAndPasswordRequest) async throws -> Bool {
        do {
            try await Auth.auth().createUser(withEmail: request.email, password: request.password)
            return true
        } catch {
            throw AccountRegistrationError.from(error)
        }
    }
}
