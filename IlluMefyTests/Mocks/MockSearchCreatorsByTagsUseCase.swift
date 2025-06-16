//
//  MockSearchCreatorsByTagsUseCase.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/15.
//

import Foundation
@testable import IlluMefy

final class MockSearchCreatorsByTagsUseCase: SearchCreatorsByTagsUseCaseProtocol {
    var result: Result<SearchCreatorsByTagsUseCaseResponse, SearchCreatorsByTagsUseCaseError>?
    var lastRequest: SearchCreatorsByTagsUseCaseRequest?
    var callCount = 0
    
    func execute(request: SearchCreatorsByTagsUseCaseRequest) async throws -> SearchCreatorsByTagsUseCaseResponse {
        callCount += 1
        lastRequest = request
        
        guard let result = result else {
            throw SearchCreatorsByTagsUseCaseError.unknown(NSError(domain: "test", code: 0))
        }
        
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}