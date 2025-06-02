//
//  AccountLoginUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

protocol AccountLoginUseCaseProtocol {
    var accountLoginRepository: any AccountLoginRepositoryProtocol { get }
    
    func execute(request: AccountLoginUseCaseRequest) async throws -> Bool
    func validate(request: AccountLoginUseCaseRequest) throws
    func isValidPhoneNumber(phoneNumber: String) -> Bool
}
