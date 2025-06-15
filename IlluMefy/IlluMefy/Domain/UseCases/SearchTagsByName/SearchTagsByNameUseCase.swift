//
//  SearchTagsByNameUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// 名前でタグを検索するUseCase
final class SearchTagsByNameUseCase: SearchTagsByNameUseCaseProtocol {
    private let tagRepository: TagRepositoryProtocol
    
    init(tagRepository: TagRepositoryProtocol) {
        self.tagRepository = tagRepository
    }
    
    func execute(request: SearchTagsByNameUseCaseRequest) async throws -> SearchTagsByNameUseCaseResponse {
        // 入力検証
        let trimmedAndQuery = request.andQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedOrQuery = request.orQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 空のクエリの場合は全タグを返す（オートコンプリートのため）
        
        do {
            let result = try await tagRepository.searchByName(
                andQuery: trimmedAndQuery,
                orQuery: trimmedOrQuery,
                offset: request.offset,
                limit: request.limit
            )
            
            return SearchTagsByNameUseCaseResponse(
                tags: result.tags,
                totalCount: result.totalCount,
                hasMore: result.hasMore
            )
        } catch let error as TagRepositoryError {
            throw SearchTagsByNameUseCaseError.repositoryError(error)
        } catch {
            throw SearchTagsByNameUseCaseError.unknownError
        }
    }
}