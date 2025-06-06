//
//  MockVerifyPhoneAuthCodeUseCase.swift
//  IlluMefyTests
//
//  Created by Haruto K. on 2025/06/06.
//

import Foundation
@testable import IlluMefy

final class MockVerifyPhoneAuthCodeUseCase: VerifyPhoneAuthCodeUseCaseProtocol, @unchecked Sendable {
    
    // MARK: - Mock Properties
    
    /// 実行回数をカウント
    var executeCallCount = 0
    
    /// 最後に実行されたリクエスト
    var lastExecutedRequest: VerifyPhoneAuthCodeUseCaseRequest?
    
    /// 成功時に返すレスポンス
    var mockResponse = VerifyPhoneAuthCodeUseCaseResponse(credential: "mock-credential")
    
    /// 失敗時に投げるエラー
    var mockError: VerifyPhoneAuthCodeUseCaseError?
    
    /// 成功させるかどうか
    var shouldSucceed = true
    
    /// 予期しないエラーを投げるかどうか
    var shouldThrowUnexpectedError = false
    
    // MARK: - VerifyPhoneAuthCodeUseCaseProtocol
    
    func execute(request: VerifyPhoneAuthCodeUseCaseRequest) async throws -> VerifyPhoneAuthCodeUseCaseResponse {
        executeCallCount += 1
        lastExecutedRequest = request
        
        if shouldThrowUnexpectedError {
            throw NSError(domain: "UnexpectedError", code: -1)
        }
        
        if shouldSucceed {
            return mockResponse
        } else {
            throw mockError ?? VerifyPhoneAuthCodeUseCaseError.unknown
        }
    }
}