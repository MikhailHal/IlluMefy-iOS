//
//  ToggleFavoriteCreatorUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/17.
//

import Foundation

protocol ToggleFavoriteCreatorUseCaseProtocol {
    func execute(request: ToggleFavoriteCreatorUseCaseRequest) async throws -> ToggleFavoriteCreatorUseCaseResponse
}