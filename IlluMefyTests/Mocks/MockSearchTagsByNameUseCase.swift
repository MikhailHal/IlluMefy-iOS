//
//  MockSearchTagsByNameUseCase.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Foundation
@testable import IlluMefy

@MainActor
class MockSearchTagsByNameUseCase: SearchTagsByNameUseCaseProtocol {
    var lastRequest: SearchTagsByNameUseCaseRequest?
    var shouldThrowError = false
    var errorToThrow: SearchTagsByNameUseCaseError = .networkError
    var response = SearchTagsByNameUseCaseResponse(
        tags: [],
        totalCount: 0,
        hasMore: false
    )
    
    func execute(request: SearchTagsByNameUseCaseRequest) async throws -> SearchTagsByNameUseCaseResponse {
        lastRequest = request
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return response
    }
}