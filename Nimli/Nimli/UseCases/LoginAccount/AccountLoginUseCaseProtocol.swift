//
//  AccountLoginUseCaseProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

protocol AccountLoginUseCaseProtocol: UseCaseWithParametesProtocol where Request == AccountLoginUseCaseRequest {
    var accountLoginRepository: any AccountLoginRepositoryProtocol { get set }
    func isValidEmail(email: String) -> Bool
}
