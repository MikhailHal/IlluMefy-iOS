//
//  MockSaveSearchHistoryUseCase.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/15.
//

import Foundation
@testable import IlluMefy

final class MockSaveSearchHistoryUseCase {
    var result: Result<Void, Error>?
    var lastQuery: String?
    var callCount = 0
    
    func execute(query: String) async throws {
        callCount += 1
        lastQuery = query
        
        if let result = result {
            switch result {
            case .success:
                return
            case .failure(let error):
                throw error
            }
        }
    }
}