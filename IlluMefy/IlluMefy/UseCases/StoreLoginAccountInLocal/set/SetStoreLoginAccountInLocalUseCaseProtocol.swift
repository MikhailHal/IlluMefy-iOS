//
//  SetStoreLoginAccountInLocalUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

import Foundation

protocol SetStoreLoginAccountInLocalUseCaseProtocol {
    var userPreferencesRepository: any UserPreferencesRepositoryProtocol { get set }
    
    func execute(request: SetStoreLoginAccountInLocalUseCaseRequest) throws -> Bool
    func validate(request: SetStoreLoginAccountInLocalUseCaseRequest) throws
    func setStoreData(request: SetStoreLoginAccountInLocalUseCaseRequest) -> Bool
}
