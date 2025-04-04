//
//  AccountLoginRepository.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

import FirebaseAuth

class AccountLoginRepository: AccountLoginRepositoryProtocol {
    typealias Request = AccountLoginRequest
    typealias Response = Bool
    typealias Error = AccountLoginRepositoryError
    
    func login(_ request: AccountLoginRequest) async throws -> Bool {
        do {
            try await Auth.auth().signIn(withEmail: request.email, password: request.password)
            return true
        } catch {
            throw AccountLoginRepositoryError.from(error)
        }
    }
    
    func execute(request: AccountLoginRequest) async throws -> Bool {
        return try await login(request)
    }
}
