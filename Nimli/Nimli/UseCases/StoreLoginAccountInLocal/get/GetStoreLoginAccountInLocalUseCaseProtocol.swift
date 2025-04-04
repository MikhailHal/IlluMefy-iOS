//
//  GetStoreLoginAccountInLocalUseCaseProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

protocol GetStoreLoginAccountInLocalUseCaseProtocol: UseCaseWithParametersSyncProtocol where Request == Void {
    var userPreferencesRepository: any UserPreferencesRepositoryProtocol { get set }
    func getStoreData() -> StoreLoginAccount
}
