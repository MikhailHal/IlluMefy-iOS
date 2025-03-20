//
//  RegisterAccountUseCase.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/12.
//

import Foundation
import FirebaseAuth

class RegisterAccountUseCase: RegisterAccountUseCaseProtocol {
    var registerAccountRepository: any AccountRegistrationRepositoryProtocol
    typealias Response = Bool
    typealias Error = RegisterAccountUseCaseError
    init(registerAccountRepository: any AccountRegistrationRepositoryProtocol) {
        self.registerAccountRepository = registerAccountRepository
    }
    func isValidEmail(email: String) -> Bool {
        return email.isValidEmail()
    }
    func isValidPassword(password: String) -> Bool {
        return true
    }
    func checkParameterValidation() -> RegisterAccountUseCaseError {
        if !isValidEmail(email: "") {
            return .invalidEmail
        }
        if !isValidPassword(password: "") {
            return .invalidPassword
        }
        return .success
    }
    func execute(request: RegistrationAccount) async throws -> Response {
        do {
            return try await registerAccountRepository.register(
                UserRegistrationWithEmailAndPasswordRequest(
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
        }
    }
}
