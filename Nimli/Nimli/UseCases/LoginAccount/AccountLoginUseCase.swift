//
//  AccountLoginUseCase.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

import Foundation
import FirebaseAuth

class AccountLoginUseCase: AccountLoginUseCaseProtocol {
    var accountLoginRepository: any AccountLoginRepositoryProtocol
    typealias Response = Bool
    typealias Error = RegisterAccountUseCaseError
    init(accountLoginRepository: any AccountLoginRepositoryProtocol) {
        self.accountLoginRepository = accountLoginRepository
    }
    func isValidEmail(email: String) -> Bool {
        return email.isValidEmail()
    }
    func isValidPassword(password: String) -> Bool {
        return true
    }
    func checkParameterValidation(request: RegistrationAccount) throws -> RegisterAccountUseCaseError {
        if !isValidEmail(email: request.email) {
            throw RegisterAccountUseCaseError.invalidEmail
        }
        if !isValidPassword(password: request.password) {
            throw RegisterAccountUseCaseError.invalidPassword
        }
        return .success
    }
    func execute(request: RegistrationAccount) async throws -> Response {
        do {
            _ = try checkParameterValidation(request: request)
            return try await accountLoginRepository.login(
                AccountLoginRequest(
                    email: request.email,
                    password: request.password
                )
            )
        } catch let error as NSError {
            switch error.code {
            case
                AuthErrorCode.accountExistsWithDifferentCredential.rawValue,
                AuthErrorCode.emailAlreadyInUse.rawValue:
                throw RegisterAccountUseCaseError.alreadyRegistered
            default:
                throw RegisterAccountUseCaseError.networkError
            }
        } catch let error as RegisterAccountUseCaseError {
            throw error
        }
    }
}
