//
//  MockRegisterAccountUseCase.swift
//  IlluMefyTests
//
//  Created by Haruto K. on 2025/06/06.
//

import Foundation
@testable import IlluMefy

final class MockRegisterAccountUseCase: RegisterAccountUseCaseProtocol, @unchecked Sendable {
    
    // MARK: - Mock Properties
    
    /// 実行回数をカウント
    var executeCallCount = 0
    
    /// 最後に実行されたリクエスト
    var lastExecutedRequest: RegisterAccountUseCaseRequest?
    
    /// 成功時に返すレスポンス
    var mockResponse = RegisterAccountUseCaseResponse(
        userID: "mock-user-id",
        phoneNumber: "09012345678"
    )
    
    /// 失敗時に投げるエラー
    var mockError: RegisterAccountUseCaseError?
    
    /// 成功させるかどうか
    var shouldSucceed = true
    
    /// 予期しないエラーを投げるかどうか
    var shouldThrowUnexpectedError = false
    
    // MARK: - RegisterAccountUseCaseProtocol
    
    func execute(request: RegisterAccountUseCaseRequest) async throws -> RegisterAccountUseCaseResponse {
        executeCallCount += 1
        lastExecutedRequest = request
        
        if shouldThrowUnexpectedError {
            throw NSError(domain: "UnexpectedError", code: -1)
        }
        
        if shouldSucceed {
            return mockResponse
        } else {
            throw mockError ?? RegisterAccountUseCaseError.unknown
        }
    }
}