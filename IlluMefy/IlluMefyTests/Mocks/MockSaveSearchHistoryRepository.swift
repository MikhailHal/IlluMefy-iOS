//
//  MockSaveSearchHistoryRepository.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Foundation
@testable import IlluMefy

@MainActor
class MockSaveSearchHistoryRepository: SearchHistoryRepositoryProtocol {
    var saveSearchHistoryResult: Result<Void, Error>?
    var lastSaveSearchHistoryQuery: String?
    var saveSearchHistoryCallCount = 0
    
    func saveSearchHistory(query: String) async throws {
        lastSaveSearchHistoryQuery = query
        saveSearchHistoryCallCount += 1
        
        if let result = saveSearchHistoryResult {
            switch result {
            case .success:
                return
            case .failure(let error):
                throw error
            }
        }
    }
    
    func getSearchHistory(limit: Int) async throws -> [String] {
        throw TestError.notImplemented
    }
    
    func deleteSearchHistory(query: String) async throws {
        throw TestError.notImplemented
    }
    
    func clearAllSearchHistory() async throws {
        throw TestError.notImplemented
    }
}

enum TestError: Error {
    case notImplemented
    case testError
}