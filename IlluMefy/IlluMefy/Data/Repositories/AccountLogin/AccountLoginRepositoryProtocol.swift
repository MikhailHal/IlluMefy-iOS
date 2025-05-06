//
//  AccountLoginRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

protocol AccountLoginRepositoryProtocol: RepositoryAsyncProtocol where
Request == AccountLoginRequest,
Response == Bool {
    func login(_ request: AccountLoginRequest) async throws -> Bool
}
