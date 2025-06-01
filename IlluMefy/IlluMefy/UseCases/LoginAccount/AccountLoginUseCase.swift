//
//  AccountLoginUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

import Foundation
import FirebaseAuth

class AccountLoginUseCase: AccountLoginUseCaseProtocol {
    var accountLoginRepository: any AccountLoginRepositoryProtocol
    
    init(accountLoginRepository: any AccountLoginRepositoryProtocol) {
        self.accountLoginRepository = accountLoginRepository
    }
    
    func isValidPhoneNumber(phoneNumber: String) -> Bool {
        return !phoneNumber.isEmpty && phoneNumber.count >= 10
    }
    
    func validate(request: AccountLoginUseCaseRequest) throws {
        if !isValidPhoneNumber(phoneNumber: request.phoneNumber) {
            throw AccountLoginUseCaseError.invalidPhoneNumber
        }
        
        if request.password.count < 6 {
            throw AccountLoginUseCaseError.invalidPassword
        }
    }
    
    func execute(request: AccountLoginUseCaseRequest) async throws -> Bool {
        do {
            try validate(request: request)
            return try await accountLoginRepository.login(
                AccountLoginRequest(
                    phoneNumber: request.phoneNumber,
                    password: request.password
                )
            )
        } catch {
            throw AccountLoginUseCaseError.from(error)
        }
    }
}
