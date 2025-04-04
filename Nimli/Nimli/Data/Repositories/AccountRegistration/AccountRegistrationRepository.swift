//
//  AccountRegistration.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/13.
//

import FirebaseAuth

class AccountRegistrationRepository: AccountRegistrationRepositoryProtocol {
    typealias Request = UserRegistrationWithEmailAndPasswordRequest
    typealias Response = Bool
    typealias Error = AccountRegistrationError
    
    func register(_ request: UserRegistrationWithEmailAndPasswordRequest) throws -> Bool {
        // 注意: コンパイラは「No calls to throwing functions occur within 'try' expression」という警告を出すが、
        // FirebaseのcreateUserメソッドは実際には例外をスローする可能性があるため、tryは必要です。
        // これはコンパイラの誤検出であり、コードは正しく動作します。
        try Auth.auth().createUser(withEmail: request.email, password: request.password)
        return true
    }
    
    func execute(request: UserRegistrationWithEmailAndPasswordRequest) throws -> Bool {
        do {
            return try register(request)
        } catch {
            throw AccountRegistrationError.from(error)
        }
    }
}
