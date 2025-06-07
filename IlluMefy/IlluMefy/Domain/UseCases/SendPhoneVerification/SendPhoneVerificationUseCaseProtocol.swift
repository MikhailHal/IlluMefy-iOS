//
//  SendPhoneVerificationUseCaseProtocol.swift
//  IlluMefy
//
//  電話番号認証コード送信ユースケースのプロトコル
//

import Foundation

/// 電話番号認証コード送信ユースケースのプロトコル
protocol SendPhoneVerificationUseCaseProtocol {
    func execute(request: SendPhoneVerificationUseCaseRequest) async throws -> SendPhoneVerificationUseCaseResponse
    func validate(request: SendPhoneVerificationUseCaseRequest) throws
}
