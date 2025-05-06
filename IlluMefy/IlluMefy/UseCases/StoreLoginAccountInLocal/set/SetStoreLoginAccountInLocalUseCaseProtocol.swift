//
//  SetStoreLoginAccountInLocalUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

import Foundation

protocol SetStoreLoginAccountInLocalUseCaseProtocol: UseCaseWithParametersSyncProtocol {
    var userPreferencesRepository: any UserPreferencesRepositoryProtocol { get }
    
    func setStoreData(request: SetStoreLoginAccountInLocalUseCaseRequest) -> Bool
}
