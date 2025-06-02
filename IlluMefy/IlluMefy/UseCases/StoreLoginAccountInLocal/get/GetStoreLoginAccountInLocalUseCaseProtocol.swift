//
//  GetStoreLoginAccountInLocalUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

protocol GetStoreLoginAccountInLocalUseCaseProtocol {
    var userPreferencesRepository: any UserPreferencesRepositoryProtocol { get set }
    
    func execute() throws -> StoreLoginAccount
    func getStoreData() -> StoreLoginAccount
}