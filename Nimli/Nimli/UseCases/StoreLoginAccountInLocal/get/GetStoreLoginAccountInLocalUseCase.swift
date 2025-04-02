//
//  GetStoreLoginAccountInLocalUseCase.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

class GetStoreLoginAccountInLocalUseCase: GetStoreLoginAccountInLocalUseCaseProtocol {
    
    typealias Response = StoreLoginAccount
    typealias Error = StoreLoginAccountInLocalUseCaseError
    
    var userPreferencesRepository: any UserPreferencesRepositoryProtocol
    
    init(userPreferencesRepository: any UserPreferencesRepositoryProtocol) {
        self.userPreferencesRepository = userPreferencesRepository
    }
    
    func execute() throws -> StoreLoginAccount {
        let email = userPreferencesRepository.loginEmail
        let password = userPreferencesRepository.loginPassowrd
        let isStoreLoginInfo = userPreferencesRepository.isStoreLoginInfo
        return StoreLoginAccount(email: email, password: password, isStore: isStoreLoginInfo)
    }
    
    func checkParameterValidation() -> StoreLoginAccountInLocalUseCaseError {
        return .success
    }
}
