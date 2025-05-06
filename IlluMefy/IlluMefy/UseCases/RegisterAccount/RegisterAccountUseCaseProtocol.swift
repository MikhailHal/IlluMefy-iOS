//
//  RegisterAccountUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/12.
//

protocol RegisterAccountUseCaseProtocol: UseCaseWithParametersAsyncProtocol where Request == RegistrationAccount {
    var registerAccountRepository: any AccountRegistrationRepositoryProtocol { get }
    func isValidEmail(email: String) -> Bool
    func isValidPassword(password: String) -> Bool
}
