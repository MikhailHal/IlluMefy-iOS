//
//  MockGetSearchHistoryUseCase.swift
//  IlluMefy-Tests
//
//  Created by Assistant on 2025/06/15.
//

import Foundation
@testable import IlluMefy

final class MockGetSearchHistoryUseCase {
    var result: Result<[String], Error>?
    var lastLimit: Int?
    var callCount = 0
    
    func execute(limit: Int = 10) async throws -> [String] {
        callCount += 1
        lastLimit = limit
        
        guard let result = result else {
            return []
        }
        
        switch result {
        case .success(let history):
            return history
        case .failure(let error):
            throw error
        }
    }
}