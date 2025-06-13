//
//  GetCreatorDetailUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// クリエイター詳細取得ユースケースプロトコル
protocol GetCreatorDetailUseCaseProtocol {
    /// クリエイター詳細情報と類似クリエイターを取得する
    ///
    /// - Parameter request: リクエスト情報
    /// - Returns: クリエイター詳細レスポンス
    /// - Throws: GetCreatorDetailUseCaseError
    func execute(request: GetCreatorDetailUseCaseRequest) async throws -> GetCreatorDetailUseCaseResponse
}
