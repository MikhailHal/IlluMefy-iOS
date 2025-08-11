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
                id: "creator_001",
                name: "ゲーム実況者A",
                thumbnailUrl: "https://picsum.photos/200/200?random=1",
                socialLinkClickCount: 1500,
                tag: ["tag_007", "tag_011"],
                description: "FPSゲームをメインに実況しています。毎日20時から配信！",
                platform: [
                    .youtube: "https://youtube.com/@gameplayerA",
                    .twitch: "https://twitch.tv/gameplayerA",
                    .x: "https://twitter.com/gameplayerA"
                ],
                createdAt: Date().addingTimeInterval(-86400 * 30),
                updatedAt: Date().addingTimeInterval(-3600),
                favoriteCount: 100
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
