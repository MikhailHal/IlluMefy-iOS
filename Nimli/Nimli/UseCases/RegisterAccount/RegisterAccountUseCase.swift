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
            return try await registerAccountRepository.register(
                UserRegistrationWithEmailAndPasswordRequest(
                    email: request.email,
                    password: request.password
                )
            )
        } catch {
            throw RegisterAccountUseCaseError.from(error)
        }
    }
}
