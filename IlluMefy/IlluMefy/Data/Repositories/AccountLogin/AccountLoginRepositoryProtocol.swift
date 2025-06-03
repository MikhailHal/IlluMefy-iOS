//
//  AccountLoginRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

protocol AccountLoginRepositoryProtocol: Sendable {
    func login(_ request: AccountLoginRequest) async throws -> Bool
}
