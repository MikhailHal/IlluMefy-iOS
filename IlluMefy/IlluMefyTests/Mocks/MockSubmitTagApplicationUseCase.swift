//
//  MockSubmitTagApplicationUseCase.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/15.
//

import Foundation
@testable import IlluMefy

final class MockSubmitTagApplicationUseCase: SubmitTagApplicationUseCaseProtocol {
    // MARK: - Mock Properties
    var shouldSucceed = true
    var mockResponse: SubmitTagApplicationUseCaseResponse?
    var mockError: SubmitTagApplicationUseCaseError = .networkError
    var shouldThrowUnexpectedError = false
    
    // MARK: - Call Tracking
    var executeCallCount = 0
    var lastExecutedRequest: SubmitTagApplicationUseCaseRequest?
    
    // MARK: - SubmitTagApplicationUseCaseProtocol
    func execute(_ request: SubmitTagApplicationUseCaseRequest) async throws -> SubmitTagApplicationUseCaseResponse {
        executeCallCount += 1
        lastExecutedRequest = request
        
        if shouldThrowUnexpectedError {
            struct UnexpectedError: Error {
                let description: String
            }
            throw UnexpectedError(description: "Unexpected error occurred")
        }
        
        if shouldSucceed {
            let response = mockResponse ?? {
                let mockApplication = TagApplication(
                    id: "test-application-id-\(executeCallCount)",
                    creatorId: request.creatorId,
                    tagName: request.tagName,
                    reason: request.reason,
                    applicationType: request.applicationType,
                    status: .pending,
                    requestedAt: Date(),
                    reviewedAt: nil,
                    reviewerId: nil,
                    reviewComment: nil
                )
                return SubmitTagApplicationUseCaseResponse(application: mockApplication)
            }()
            
            return response
        } else {
            throw mockError
        }
    }
    
    // MARK: - Helper Methods
    func reset() {
        shouldSucceed = true
        mockResponse = nil
        mockError = .networkError
        shouldThrowUnexpectedError = false
        executeCallCount = 0
        lastExecutedRequest = nil
    }
}