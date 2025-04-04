//
//  GetStoreLoginAccountInLocalUseCase.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

import Foundation

class GetStoreLoginAccountInLocalUseCase: GetStoreLoginAccountInLocalUseCaseProtocol {
    typealias Response = StoreLoginAccount
    typealias Error = StoreLoginAccountInLocalUseCaseError
    
    var userPreferencesRepository: any UserPreferencesRepositoryProtocol
    
    init(userPreferencesRepository: any UserPreferencesRepositoryProtocol) {
        self.userPreferencesRepository = userPreferencesRepository
    }
    
    func getStoreData() -> StoreLoginAccount {
        do {
            return try execute(request: ())
        } catch {
            return StoreLoginAccount(email: "", password: "", isStore: false)
        }
    }
    
    func execute(request: Void) throws -> StoreLoginAccount {
        let email = userPreferencesRepository.loginEmail
        let password = userPreferencesRepository.loginPassowrd
        let isStoreLoginInfo = userPreferencesRepository.isStoreLoginInfo
        return StoreLoginAccount(email: email, password: password, isStore: isStoreLoginInfo)
    }
    
    func checkParameterValidation(request: Void) throws -> StoreLoginAccountInLocalUseCaseError {
        return .success
    }
}
