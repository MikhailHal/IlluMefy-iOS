//
//  GetStoreLoginAccountInLocalUseCaseProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

protocol GetStoreLoginAccountInLocalUseCaseProtocol: UseCaseWithoutParametesProtocol {
    var userPreferencesRepository: any UserPreferencesRepositoryProtocol { get set }
}
