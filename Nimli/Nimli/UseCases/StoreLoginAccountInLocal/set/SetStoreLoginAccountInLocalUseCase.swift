//
//  SetStoreLoginAccountInLocalUseCase.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

class SetStoreLoginAccountInLocalUseCase: SetStoreLoginAccountInLocalUseCaseProtocol {
    typealias Request = SetStoreLoginAccountInLocalUseCaseRequest
    typealias Response = StoreLoginAccount
    typealias Error = StoreLoginAccountInLocalUseCaseError
    
    var userPreferencesRepository: any UserPreferencesRepositoryProtocol
    
    init(userPreferencesRepository: any UserPreferencesRepositoryProtocol) {
        self.userPreferencesRepository = userPreferencesRepository
    }
    
    func execute(request: SetStoreLoginAccountInLocalUseCaseRequest) async throws -> Response {
        let email = userPreferencesRepository.loginEmail
        let password = userPreferencesRepository.loginPassowrd
        let isStoreLoginInfo = userPreferencesRepository.isStoreLoginInfo
        return StoreLoginAccount(email: email, password: password, isStore: isStoreLoginInfo)
    }
    
    func checkParameterValidation(request: SetStoreLoginAccountInLocalUseCaseRequest) throws ->
    StoreLoginAccountInLocalUseCaseError {
        if request.email.isEmpty || request.password.isEmpty {
            throw StoreLoginAccountInLocalUseCaseError.invalidFormat
        }
        return .success
    }
}
