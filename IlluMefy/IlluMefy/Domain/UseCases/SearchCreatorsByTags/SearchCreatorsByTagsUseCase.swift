//
//  SearchCreatorsByTagsUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

/**
 タグによるクリエイター検索ユースケース
 
 指定されたタグに関連するクリエイターを検索します。
 フォークソノミーによるタグ検索の中核機能です。
 */
final class SearchCreatorsByTagsUseCase: SearchCreatorsByTagsUseCaseProtocol {
    
    private let creatorRepository: CreatorRepositoryProtocol
    
    init(creatorRepository: CreatorRepositoryProtocol) {
        self.creatorRepository = creatorRepository
    }
    
    func execute(request: SearchCreatorsByTagsUseCaseRequest) async throws -> SearchCreatorsByTagsUseCaseResponse {
        // バリデーション
        guard !request.tagIds.isEmpty else {
            throw SearchCreatorsByTagsUseCaseError.emptyTags
        }
        
        guard request.tagIds.count <= 10 else {
            throw SearchCreatorsByTagsUseCaseError.tooManyTags
        }
        
        do {
            let creators = try await creatorRepository.searchCreatorsByTags(tagIds: request.tagIds)
            
            // ビジネスロジック: アクティブなクリエイターのみ & 関連度でソート
            let filteredCreators = creators
                .filter { $0.isActive }
                .sorted { creator1, creator2 in
                    // タグの一致数でソート
                    let matches1 = Set(creator1.relatedTag).intersection(Set(request.tagIds)).count
                    let matches2 = Set(creator2.relatedTag).intersection(Set(request.tagIds)).count
                    
                    if matches1 != matches2 {
                        return matches1 > matches2
                    }
                    // 一致数が同じならviewCountでソート
                    return creator1.viewCount > creator2.viewCount
                }
            
            return SearchCreatorsByTagsUseCaseResponse(
                creators: filteredCreators,
                searchedTags: request.tagIds
            )
        } catch let error as CreatorRepositoryError {
            throw SearchCreatorsByTagsUseCaseError.repositoryError(error)
        } catch {
            throw SearchCreatorsByTagsUseCaseError.unknown(error)
        }
    }
}
