//
//  MockGetSearchHistoryRepository.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Foundation
@testable import IlluMefy

@MainActor
class MockGetSearchHistoryRepository: SearchHistoryRepositoryProtocol {
    var getSearchHistoryResult: Result<[String], Error>?
    var lastGetSearchHistoryLimit: Int?
    var getSearchHistoryCallCount = 0
    
    func getSearchHistory(limit: Int) async throws -> [String] {
        lastGetSearchHistoryLimit = limit
        getSearchHistoryCallCount += 1
        
        if let result = getSearchHistoryResult {
            switch result {
            case .success(let history):
                return history
            case .failure(let error):
                throw error
            }
        }
        
        throw TestError.notImplemented
    }
    
    func saveSearchHistory(query: String) async throws {
        throw TestError.notImplemented
    }
    
    func deleteSearchHistory(query: String) async throws {
        throw TestError.notImplemented
    }
    
    func clearAllSearchHistory() async throws {
        throw TestError.notImplemented
    }
}