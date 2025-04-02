//
//  AccountLoginRepository.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

import FirebaseAuth

class AccountLoginRepository: AccountLoginRepositoryProtocol {
    func login(_ request: AccountLoginRequest) async throws -> Bool {
        do {
            try await Auth.auth().signIn(withEmail: request.email, password: request.password)
            return true
        } catch let authError as NSError {
            throw authError
        }
    }
}
