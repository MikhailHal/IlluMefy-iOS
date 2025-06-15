//
//  ProfileCorrectionRepository.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import Foundation

/// プロフィール修正依頼リポジトリ実装
final class ProfileCorrectionRepository: ProfileCorrectionRepositoryProtocol {
    
    // MARK: - Dependencies
    
    // MARK: - Private Types
    
    private protocol APIClientProtocol {
        func request<T: Codable>(_ endpoint: APIEndpoint) async throws -> T
    }
    
    private protocol APIEndpoint {
        var path: String { get }
        var method: HTTPMethod { get }
        var parameters: [String: Any]? { get }
    }

    private enum HTTPMethod {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    // MARK: - Dependencies
    
    private let apiClient: APIClientProtocol?
    
    // MARK: - Initializer
    
    init() {
        self.apiClient = nil // モック実装のため
    }
    
    // MARK: - ProfileCorrectionRepositoryProtocol
    
    func submitCorrectionRequest(_ request: ProfileCorrectionRequest) async throws -> ProfileCorrectionRequest {
        // モック実装 - 実際のAPI呼び出しはここで行う
        return ProfileCorrectionRequest(
            id: UUID().uuidString,
            creatorId: request.creatorId,
            requesterId: request.requesterId,
            correctionItems: request.correctionItems,
            reason: request.reason,
            referenceUrl: request.referenceUrl,
            status: .pending,
            requestedAt: Date(),
            reviewedAt: nil,
            reviewerId: nil,
            reviewComment: nil
        )
    }
    
    func getCorrectionHistory(userId: String, limit: Int) async throws -> [ProfileCorrectionRequest] {
        // モック実装
        return []
    }
    
    func getCorrectionRequest(requestId: String) async throws -> ProfileCorrectionRequest {
        // モック実装
        throw ProfileCorrectionRepositoryError.requestNotFound
    }
    
    func cancelCorrectionRequest(requestId: String) async throws -> Bool {
        // モック実装
        return true
    }
}

// MARK: - Mock Implementation

/// モックプロフィール修正依頼リポジトリ
final class MockProfileCorrectionRepository: ProfileCorrectionRepositoryProtocol {
    
    // MARK: - Mock State
    
    private var mockRequests: [ProfileCorrectionRequest] = []
    var shouldReturnError = false
    var errorToReturn: ProfileCorrectionRepositoryError = .networkError
    
    // MARK: - ProfileCorrectionRepositoryProtocol
    
    func submitCorrectionRequest(_ request: ProfileCorrectionRequest) async throws -> ProfileCorrectionRequest {
        if shouldReturnError {
            throw errorToReturn
        }
        
        let submittedRequest = ProfileCorrectionRequest(
            id: UUID().uuidString,
            creatorId: request.creatorId,
            requesterId: request.requesterId,
            correctionItems: request.correctionItems,
            reason: request.reason,
            referenceUrl: request.referenceUrl,
            status: .pending,
            requestedAt: Date(),
            reviewedAt: nil,
            reviewerId: nil,
            reviewComment: nil
        )
        
        mockRequests.append(submittedRequest)
        return submittedRequest
    }
    
    func getCorrectionHistory(userId: String, limit: Int) async throws -> [ProfileCorrectionRequest] {
        if shouldReturnError {
            throw errorToReturn
        }
        
        return Array(mockRequests.filter { $0.requesterId == userId }.prefix(limit))
    }
    
    func getCorrectionRequest(requestId: String) async throws -> ProfileCorrectionRequest {
        if shouldReturnError {
            throw errorToReturn
        }
        
        guard let request = mockRequests.first(where: { $0.id == requestId }) else {
            throw ProfileCorrectionRepositoryError.requestNotFound
        }
        
        return request
    }
    
    func cancelCorrectionRequest(requestId: String) async throws -> Bool {
        if shouldReturnError {
            throw errorToReturn
        }
        
        guard let index = mockRequests.firstIndex(where: { $0.id == requestId }) else {
            throw ProfileCorrectionRepositoryError.requestNotFound
        }
        
        mockRequests[index] = ProfileCorrectionRequest(
            id: mockRequests[index].id,
            creatorId: mockRequests[index].creatorId,
            requesterId: mockRequests[index].requesterId,
            correctionItems: mockRequests[index].correctionItems,
            reason: mockRequests[index].reason,
            referenceUrl: mockRequests[index].referenceUrl,
            status: .rejected,
            requestedAt: mockRequests[index].requestedAt,
            reviewedAt: Date(),
            reviewerId: "system",
            reviewComment: "ユーザーによってキャンセルされました"
        )
        
        return true
    }
}