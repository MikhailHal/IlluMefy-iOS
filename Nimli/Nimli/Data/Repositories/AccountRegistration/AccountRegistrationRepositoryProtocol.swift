//
//  AccountRegistrationRepositoryProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/13.
//

protocol AccountRegistrationRepositoryProtocol: RepositoryAsyncProtocol where Request == UserRegistrationWithEmailAndPasswordRequest, Response == Bool {
    func register(_ request: UserRegistrationWithEmailAndPasswordRequest) async throws -> Bool
}
