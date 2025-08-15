//
//  MockGetTagListByTagIdListUseCase.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/08/14.
//

import Foundation
@testable import IlluMefy

@MainActor
class MockGetTagListByTagIdListUseCase: GetTagListByTagIdListUseCaseProtocol {
    var lastRequest: GetTagListByTagIdListUseCaseRequest?
    var shouldThrowError = false
    var errorToThrow: GetTagListByTagIdListUseCaseError = .unknown(nil)
    var response = GetTagListByTagIdListUseCaseResponse(tags: [])
    
    func execute(request: GetTagListByTagIdListUseCaseRequest) async throws -> GetTagListByTagIdListUseCaseResponse {
        lastRequest = request
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return response
    }
}