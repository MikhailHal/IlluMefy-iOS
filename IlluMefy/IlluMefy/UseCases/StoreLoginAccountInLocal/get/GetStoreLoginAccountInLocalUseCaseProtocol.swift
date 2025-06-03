//
//  GetStoreLoginAccountInLocalUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

protocol GetStoreLoginAccountInLocalUseCaseProtocol: Sendable {
    var userPreferencesRepository: any UserPreferencesRepositoryProtocol { get }
    
    func execute() throws -> StoreLoginAccount
    func getStoreData() -> StoreLoginAccount
}
