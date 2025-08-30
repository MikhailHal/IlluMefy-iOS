//
//  SearchTagsWithAlgoliaUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/30.
//

import Foundation

/// Algoliaタグ検索UseCaseプロトコル
protocol SearchTagsWithAlgoliaUseCaseProtocol {
    func execute(request: SearchTagsWithAlgoliaUseCaseRequest) async throws -> SearchTagsWithAlgoliaUseCaseResponse
}