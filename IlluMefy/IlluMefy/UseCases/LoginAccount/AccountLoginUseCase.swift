//
//  AccountLoginUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

import Foundation
import FirebaseAuth

class AccountLoginUseCase: AccountLoginUseCaseProtocol {
    typealias Request = AccountLoginUseCaseRequest
    typealias Response = Bool
    typealias Error = AccountLoginUseCaseError
    
    var accountLoginRepository: any AccountLoginRepositoryProtocol
    
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
        } catch {
            throw AccountLoginUseCaseError.from(error)
        }
    }
}
