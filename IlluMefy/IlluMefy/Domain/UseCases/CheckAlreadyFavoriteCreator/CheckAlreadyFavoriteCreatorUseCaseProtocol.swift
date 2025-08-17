//
//  CheckAlreadyFavoriteCreatorUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/17.
//

import Foundation

protocol CheckAlreadyFavoriteCreatorUseCaseProtocol {
    func execute(request: CheckAlreadyFavoriteCreatorUseCaseRequest) async throws -> CheckAlreadyFavoriteCreatorUseCaseResponse
}