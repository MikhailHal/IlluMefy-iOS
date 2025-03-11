//
//  RegisterAccountUseCaseProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/12.
//

protocol RegisterAccountUseCaseProtocol: UseCaseProtocol {
    func isValidEmail(email: String) -> Bool
    func isValidPassword(password: String) -> Bool
}
