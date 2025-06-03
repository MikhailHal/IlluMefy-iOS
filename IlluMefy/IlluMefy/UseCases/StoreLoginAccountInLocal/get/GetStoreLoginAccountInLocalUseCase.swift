//
//  GetStoreLoginAccountInLocalUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

import Foundation

final class GetStoreLoginAccountInLocalUseCase: GetStoreLoginAccountInLocalUseCaseProtocol {
    let userPreferencesRepository: any UserPreferencesRepositoryProtocol
    
    init(userPreferencesRepository: any UserPreferencesRepositoryProtocol) {
        self.userPreferencesRepository = userPreferencesRepository
    }
    
    func getStoreData() -> StoreLoginAccount {
        do {
            return try execute()
        } catch {
            return StoreLoginAccount(email: "", password: "", isStore: false)
        }
    }
    
    func execute() throws -> StoreLoginAccount {
        let email = userPreferencesRepository.loginEmail
        let password = userPreferencesRepository.loginPassowrd
        let isStoreLoginInfo = userPreferencesRepository.isStoreLoginInfo
        return StoreLoginAccount(email: email, password: password, isStore: isStoreLoginInfo)
    }
}
