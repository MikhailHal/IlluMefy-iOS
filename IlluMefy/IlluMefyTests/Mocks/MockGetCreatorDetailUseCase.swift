//
//  MockGetCreatorDetailUseCase.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/15.
//

import Foundation
@testable import IlluMefy

final class MockGetCreatorDetailUseCase: GetCreatorDetailUseCaseProtocol {
    // MARK: - Mock Properties
    var shouldSucceed = true
    var mockCreator: Creator?
    var mockSimilarCreators: [Creator] = []
    var mockError: GetCreatorDetailUseCaseError = .creatorNotFound
    var shouldThrowUnexpectedError = false
    
    // MARK: - Call Tracking
    var executeCallCount = 0
    var lastExecutedRequest: GetCreatorDetailUseCaseRequest?
    
    // MARK: - GetCreatorDetailUseCaseProtocol
    func execute(request: GetCreatorDetailUseCaseRequest) async throws -> GetCreatorDetailUseCaseResponse {
        executeCallCount += 1
        lastExecutedRequest = request
        
        if shouldThrowUnexpectedError {
            struct UnexpectedError: Error {
                let description: String
            }
            throw UnexpectedError(description: "Unexpected error occurred")
        }
        
        if shouldSucceed {
            let creator = mockCreator ?? Creator(
                id: request.creatorId,
                name: "Test Creator",
                thumbnailUrl: "https://example.com/thumbnail.jpg",
                viewCount: 1000,
                socialLinkClickCount: 500,
                platformClickRatio: [
                    .youtube: 0.6,
                    .x: 0.4
                ],
                relatedTag: ["tag1", "tag2"],
                description: "Test self introduction",
                platform: [
                    .youtube: "https://youtube.com/test",
                    .x: "https://x.com/test"
                ],
                createdAt: Date(),
                updatedAt: Date(),
                isActive: true,
                favoriteCount: 0
            )
            
            return GetCreatorDetailUseCaseResponse(
                creator: creator,
                similarCreators: mockSimilarCreators
            )
        } else {
            throw mockError
        }
    }
    
    // MARK: - Helper Methods
    func reset() {
        shouldSucceed = true
        mockCreator = nil
        mockSimilarCreators = []
        mockError = .creatorNotFound
        shouldThrowUnexpectedError = false
        executeCallCount = 0
        lastExecutedRequest = nil
    }
}
