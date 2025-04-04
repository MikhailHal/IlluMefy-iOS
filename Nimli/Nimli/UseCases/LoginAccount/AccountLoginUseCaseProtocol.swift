//
//  AccountLoginUseCaseProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

protocol AccountLoginUseCaseProtocol: UseCaseWithParametersAsyncProtocol where Request == AccountLoginUseCaseRequest {
    var accountLoginRepository: any AccountLoginRepositoryProtocol { get }
    func isValidEmail(email: String) -> Bool
}
