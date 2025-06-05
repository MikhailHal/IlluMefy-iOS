//
//  MockSetStoreLoginAccountInLocalUseCase.swift
//  IlluMefyTests
//
//  Created by Haruto K. on 2025/06/04.
//

import Foundation
@testable import IlluMefy

final class MockSetStoreLoginAccountInLocalUseCase: SetStoreLoginAccountInLocalUseCaseProtocol {
    // プロトコル要求
    var userPreferencesRepository: any UserPreferencesRepositoryProtocol
    
    // テスト制御用プロパティ
    var shouldSucceed = true
    var mockError: StoreLoginAccountInLocalUseCaseError = .invalidFormat
    var executeCallCount = 0
    var validateCallCount = 0
    var setStoreDataCallCount = 0
    var lastExecutedRequest: SetStoreLoginAccountInLocalUseCaseRequest?
    var lastValidatedRequest: SetStoreLoginAccountInLocalUseCaseRequest?
    var lastSetStoreDataRequest: SetStoreLoginAccountInLocalUseCaseRequest?
    
    init() {
        self.userPreferencesRepository = MockUserPreferencesRepository()
    }
    
    func execute(request: SetStoreLoginAccountInLocalUseCaseRequest) throws -> Bool {
        executeCallCount += 1
        lastExecutedRequest = request
        
        if shouldSucceed {
            return true
        } else {
            throw mockError
        }
    }
    
    func validate(request: SetStoreLoginAccountInLocalUseCaseRequest) throws {
        validateCallCount += 1
        lastValidatedRequest = request
        
        if !shouldSucceed {
            throw mockError
        }
        
        // 簡単なバリデーション
        if request.email.isEmpty || request.password.isEmpty {
            throw StoreLoginAccountInLocalUseCaseError.invalidFormat
        }
    }
    
    func setStoreData(request: SetStoreLoginAccountInLocalUseCaseRequest) -> Bool {
        setStoreDataCallCount += 1
        lastSetStoreDataRequest = request
        
        return shouldSucceed
    }
}