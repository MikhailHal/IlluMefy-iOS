//
//  SearchTagsByNameUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// 名前でタグを検索するUseCaseのプロトコル
protocol SearchTagsByNameUseCaseProtocol {
    func execute(request: SearchTagsByNameUseCaseRequest) async throws -> SearchTagsByNameUseCaseResponse
}