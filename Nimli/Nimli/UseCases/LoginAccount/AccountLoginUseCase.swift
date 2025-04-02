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
    typealias Error = AccountLoginUseCaseError
    init(accountLoginRepository: any AccountLoginRepositoryProtocol) {
        self.accountLoginRepository = accountLoginRepository
    }
    func isValidEmail(email: String) -> Bool {
        return email.isValidEmail()
    }
    func checkParameterValidation(request: AccountLoginUseCaseRequest) throws -> AccountLoginUseCaseError {
        return .success
    }
    func execute(request: AccountLoginUseCaseRequest) async throws -> Response {
        do {
            _ = try checkParameterValidation(request: request)
            return try await accountLoginRepository.login(
                AccountLoginRequest(
                    email: request.email,
                    password: request.password
                )
            )
        } catch let error as NSError {
            let authError = AuthErrorCode(rawValue: error.code) ?? nil
            if authError == nil {
                throw error
            } else {
                switch authError!.code {
                case AuthErrorCode.wrongPassword:
                    throw AccountLoginUseCaseError.wrongPassword
                    
                case AuthErrorCode.invalidCredential:
                    throw AccountLoginUseCaseError.invalidCredential
                    
                case AuthErrorCode.invalidEmail:
                    throw AccountLoginUseCaseError.invalidEmail
                    
                case AuthErrorCode.userNotFound:
                    throw AccountLoginUseCaseError.userNotFound
                    
                case AuthErrorCode.userDisabled:
                    throw AccountLoginUseCaseError.userDisabled
                
                case AuthErrorCode.tooManyRequests:
                    throw AccountLoginUseCaseError.tooManyRequests
                    
                case AuthErrorCode.networkError:
                    throw AccountLoginUseCaseError.networkError
                    
                default:
                    throw RegisterAccountUseCaseError.networkError
                }
            }
        }
    }
}
