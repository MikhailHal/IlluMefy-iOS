//
//  RegisterAccountUseCase.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/12.
//

class RegisterAccountUseCase: RegisterAccountUseCaseProtocol {
    typealias Request = (username: String, password: String)
    typealias Response = (username: String, password: String)
    typealias Error = RegisterAccountUseCaseError
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
    func execute(request: Request) async throws -> Response {
        return ("", "")
    }
}
