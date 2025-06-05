//
//  MockSendPhoneVerificationUseCase.swift
//  IlluMefyTests
//
//  Created by Haruto K. on 2025/06/04.
//

import Foundation
@testable import IlluMefy

final class MockSendPhoneVerificationUseCase: SendPhoneVerificationUseCaseProtocol {
    // テスト制御用プロパティ
    var shouldSucceed = true
    var shouldThrowUnexpectedError = false
    var mockVerificationID = "mock-verification-id"
    var mockError: IlluMefy.SendPhoneVerificationUseCaseError = .networkError
    var executeCallCount = 0
    var lastExecutedRequest: IlluMefy.SendPhoneVerificationUseCaseRequest?
    
    func execute(request: IlluMefy.SendPhoneVerificationUseCaseRequest) async throws -> IlluMefy.SendPhoneVerificationUseCaseResponse {
        executeCallCount += 1
        lastExecutedRequest = request
        
        if shouldThrowUnexpectedError {
            throw NSError(domain: "TestError", code: 999, userInfo: [NSLocalizedDescriptionKey: "Unexpected test error"])
        }
        
        if shouldSucceed {
            return IlluMefy.SendPhoneVerificationUseCaseResponse(verificationID: mockVerificationID)
        } else {
            throw mockError
        }
    }
    
    func validate(request: IlluMefy.SendPhoneVerificationUseCaseRequest) throws {
        // テスト用の簡単な実装
        if request.phoneNumber.isEmpty {
            throw SendPhoneVerificationUseCaseError.invalidPhoneNumber
        }
    }
}
