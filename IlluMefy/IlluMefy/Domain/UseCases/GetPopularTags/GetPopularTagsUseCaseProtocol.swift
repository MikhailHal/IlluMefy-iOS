//
//  GetPopularTagsUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/14.
//

import Foundation

protocol GetPopularTagsUseCaseProtocol {
    func execute(request: GetPopularTagsUseCaseRequest) async throws -> GetPopularTagsUseCaseResponse
}