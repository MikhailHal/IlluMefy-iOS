//
//  SendPhoneVerificationUseCaseProtocol.swift
//  IlluMefy
//
//  電話番号認証コード送信ユースケースのプロトコル
//

import Foundation

/// 電話番号認証コード送信ユースケースのプロトコル
protocol SendPhoneVerificationUseCaseProtocol: UseCaseWithParametersAsyncProtocol
where Request == SendPhoneVerificationUseCaseRequest,
      Response == SendPhoneVerificationUseCaseResponse,
      Error == SendPhoneVerificationUseCaseError {
    /// 認証コードを送信
    func execute(request: Request) async throws -> Response
}
