//
//  AccountLoginRepositoryProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

protocol AccountLoginRepositoryProtocol {
    func login(_ request: AccountLoginRequest) async throws -> Bool
}
