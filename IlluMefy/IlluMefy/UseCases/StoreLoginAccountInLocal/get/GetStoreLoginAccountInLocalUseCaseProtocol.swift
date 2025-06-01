//
//  GetStoreLoginAccountInLocalUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

protocol GetStoreLoginAccountInLocalUseCaseProtocol: UseCaseWithoutParametersSyncProtocol where Response == StoreLoginAccount {
    var userPreferencesRepository: any UserPreferencesRepositoryProtocol { get set }
    func getStoreData() -> StoreLoginAccount
}