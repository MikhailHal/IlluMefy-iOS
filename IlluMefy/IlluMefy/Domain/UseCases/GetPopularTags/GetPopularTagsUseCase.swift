//
//  GetPopularTagsUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/14.
//

import Foundation

/**
 人気タグ取得ユースケース
 
 アプリ内で人気の高いタグを取得します。
 ホーム画面のタグ表示などで使用されます。
 */
final class GetPopularTagsUseCase: GetPopularTagsUseCaseProtocol {
    
    private let tagRepository: TagRepositoryProtocol
    
    init(tagRepository: TagRepositoryProtocol) {
        self.tagRepository = tagRepository
    }
    
    func execute(request: GetPopularTagsUseCaseRequest) async throws -> GetPopularTagsUseCaseResponse {
        do {
            let response = try await tagRepository.getPopularTags(limit: request.limit)
            let tags = convertResponseToTags(response)
            return GetPopularTagsUseCaseResponse(
                tags: tags,
                hasMore: tags.count == request.limit
            )
        } catch let error as TagRepositoryError {
            throw GetPopularTagsUseCaseError.repositoryError(error)
        } catch {
            throw GetPopularTagsUseCaseError.unknown(error)
        }
    }
    
    // MARK: - Private Methods
    
    /// GetPopularTagsResponseをTagの配列に変換
    private func convertResponseToTags(_ response: GetPopularTagsResponse) -> [Tag] {
        return response.data.map { tagDataModel in
            convertTagDataModel(tagDataModel)
        }
    }
    
    /// TagDataModelをTagドメインエンティティに変換
    private func convertTagDataModel(_ tagDataModel: TagDataModel) -> Tag {
        return Tag(
            id: tagDataModel.id,
            displayName: tagDataModel.name,
            tagName: tagDataModel.name.lowercased().replacingOccurrences(of: " ", with: "-"),
            clickedCount: tagDataModel.viewCount,
            createdAt: tagDataModel.createdAt.toDate,
            updatedAt: tagDataModel.updatedAt.toDate,
        )
    }
}
