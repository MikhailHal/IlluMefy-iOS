//
//  SearchCreatorsByNameUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// 名前でクリエイターを検索するUseCaseのプロトコル
protocol SearchCreatorsByNameUseCaseProtocol {
    /// 名前でクリエイターを検索する
    /// - Parameter request: 検索リクエスト
    /// - Returns: 検索結果
    /// - Throws: SearchCreatorsByNameUseCaseError
    func execute(request: SearchCreatorsByNameUseCaseRequest) async throws -> SearchCreatorsByNameUseCaseResponse
}