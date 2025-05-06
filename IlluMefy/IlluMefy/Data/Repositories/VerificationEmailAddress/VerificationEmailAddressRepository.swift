//
//  VerificationEmailAddressRepository.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/25.
//

import FirebaseAuth

class VerificationEmailAddressRepository: VerificationEmailAddressRepositoryProtocol {
    typealias Request = User
    typealias Response = Bool
    typealias Error = VerificationEmailAddressRepositoryError
    
    func sendVerificationMail(_ user: FirebaseAuth.User) -> Bool {
        var result: Bool = true
        user.sendEmailVerification { error in
            if error != nil {
                result = false
            }
        }
        return result
    }
    
    func execute(request: User) throws -> Bool {
        return sendVerificationMail(request)
    }
}
