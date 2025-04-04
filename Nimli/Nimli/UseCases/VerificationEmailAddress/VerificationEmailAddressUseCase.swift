//
//  VerificationEmailAddressUseCase.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/25.
//

import FirebaseAuth

class VerificationEmailAddressUseCase: VerificationEmailAddressUseCaseProtocol {
    typealias Error = VerificationEmailAddressUseCaseError
    typealias Response = Bool
    
    var verificationEmailAddressRepository: any VerificationEmailAddressRepositoryProtocol
    
    init(verificationEmailAddressRepository: any VerificationEmailAddressRepositoryProtocol) {
        self.verificationEmailAddressRepository = verificationEmailAddressRepository
    }
    
    func checkParameterValidation(request: FirebaseAuth.User?) throws -> VerificationEmailAddressUseCaseError {
        if request == nil {
            throw VerificationEmailAddressUseCaseError.unknownUser
        }
        return .success
    }
    
    func execute(request: FirebaseAuth.User?) throws -> Bool {
        do {
            _ = try checkParameterValidation(request: request)
            let result = verificationEmailAddressRepository.sendVerificationMail(request!)
            if result == false {
                throw VerificationEmailAddressUseCaseError.sendError
            }
            return true
        }
    }
}
