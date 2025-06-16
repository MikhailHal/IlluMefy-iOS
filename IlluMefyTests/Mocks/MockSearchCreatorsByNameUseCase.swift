//
//  MockSearchCreatorsByNameUseCase.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/15.
//

import Foundation
@testable import IlluMefy

final class MockSearchCreatorsByNameUseCase: SearchCreatorsByNameUseCaseProtocol {
    var result: Result<SearchCreatorsByNameUseCaseResponse, SearchCreatorsByNameUseCaseError>?
    var lastRequest: SearchCreatorsByNameUseCaseRequest?
    var callCount = 0
    
    func execute(request: SearchCreatorsByNameUseCaseRequest) async throws -> SearchCreatorsByNameUseCaseResponse {
        callCount += 1
        lastRequest = request
        
        guard let result = result else {
            throw SearchCreatorsByNameUseCaseError.unknownError
        }
        
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}