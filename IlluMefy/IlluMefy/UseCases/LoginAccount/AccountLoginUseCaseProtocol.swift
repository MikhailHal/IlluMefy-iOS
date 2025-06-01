//
//  AccountLoginUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

protocol AccountLoginUseCaseProtocol: UseCaseWithParametersAsyncProtocol where Request == AccountLoginUseCaseRequest, Response == Bool {
    var accountLoginRepository: any AccountLoginRepositoryProtocol { get }
    func isValidPhoneNumber(phoneNumber: String) -> Bool
}
