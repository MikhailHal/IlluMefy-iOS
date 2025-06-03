//
//  AccountLoginRepository.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

import FirebaseAuth

final class AccountLoginRepository: AccountLoginRepositoryProtocol {
    func login(_ request: AccountLoginRequest) async throws -> Bool {
        do {
            // For phone number authentication, we would typically use Firebase Phone Auth
            // For now, treating phone number as email for compatibility
            // In a real implementation, this would use Firebase Phone Authentication
            try await Auth.auth().signIn(withEmail: request.phoneNumber, password: request.password)
            return true
        } catch {
            throw AccountLoginRepositoryError.from(error)
        }
    }
}
