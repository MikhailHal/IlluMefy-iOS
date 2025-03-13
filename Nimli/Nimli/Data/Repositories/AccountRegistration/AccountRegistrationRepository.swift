//
//  AccountRegistration.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/13.
//

import FirebaseAuth

class AccountRegistrationRepository: AccountRegistrationRepositoryProtocol {
    typealias DataEntityForRequest = UserRegistrationWithEmailAndPasswordRequest
    typealias DataEntityForResponse = Bool
    typealias DomainEntity = Bool
    typealias Error = AcountRegistrationError
    func execute(_ request: DataEntityForRequest) async throws -> Bool {
        do {
            try await Auth.auth().createUser(withEmail: request.email, password: request.password)
            return true
        } catch let authError as NSError {
            throw authError
        }
    }
    func transform(dataEntity: Bool) -> Bool {
        // Don't need to call it
        return true
    }
}
