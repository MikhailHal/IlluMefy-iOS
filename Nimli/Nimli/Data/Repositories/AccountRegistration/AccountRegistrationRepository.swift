//
//  AccountRegistration.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/13.
//

import FirebaseAuth

class AccountRegistrationRepository: AccountRegistrationRepositoryProtocol {
    typealias Request = UserRegistrationWithEmailAndPasswordRequest
    typealias Response = Bool
    typealias Error = AccountRegistrationError
    
    func register(_ request: UserRegistrationWithEmailAndPasswordRequest) throws -> Bool {
        do {
            try Auth.auth().createUser(withEmail: request.email, password: request.password)
            return true
        } catch {
            throw AccountRegistrationError.from(error)
        }
    }
    
    func execute(request: UserRegistrationWithEmailAndPasswordRequest) throws -> Bool {
        return try register(request)
    }
}
