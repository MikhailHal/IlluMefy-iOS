//
//  SetStoreLoginAccountInLocalUseCaseProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

protocol SetStoreLoginAccountInLocalUseCaseProtocol: UseCaseWithParametesProtocol {
    var userPreferencesRepository: any UserPreferencesRepositoryProtocol { get set }
}
