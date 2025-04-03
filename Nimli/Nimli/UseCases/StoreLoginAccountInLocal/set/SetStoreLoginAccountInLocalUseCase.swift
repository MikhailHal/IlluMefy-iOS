//
//  SetStoreLoginAccountInLocalUseCase.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

class SetStoreLoginAccountInLocalUseCase: SetStoreLoginAccountInLocalUseCaseProtocol {
    typealias Request = SetStoreLoginAccountInLocalUseCaseRequest
    typealias Response = Bool
    typealias Error = StoreLoginAccountInLocalUseCaseError
    
    var userPreferencesRepository: any UserPreferencesRepositoryProtocol
    
    init(userPreferencesRepository: any UserPreferencesRepositoryProtocol) {
        self.userPreferencesRepository = userPreferencesRepository
    }
    
    func setStoreData(request: SetStoreLoginAccountInLocalUseCaseRequest) async -> Bool {
        return await execute(request: request)
    }
    
    func execute(request: SetStoreLoginAccountInLocalUseCaseRequest) async -> Response {
        userPreferencesRepository.isStoreLoginInfo = request.isStore
        userPreferencesRepository.loginEmail = request.email
        userPreferencesRepository.loginPassowrd = request.password
        return true
    }
    
    func checkParameterValidation(request: SetStoreLoginAccountInLocalUseCaseRequest) throws ->
    StoreLoginAccountInLocalUseCaseError {
        if request.email.isEmpty || request.password.isEmpty {
            throw StoreLoginAccountInLocalUseCaseError.invalidFormat
        }
        return .success
    }
}
