//
//  RegisterAccountUseCaseProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/12.
//

protocol RegisterAccountUseCaseProtocol: UseCaseWithParametesProtocol where Request == RegistrationAccount {
    var registerAccountRepository: any AccountRegistrationRepositoryProtocol { get set }
    func isValidEmail(email: String) -> Bool
    func isValidPassword(password: String) -> Bool
}
