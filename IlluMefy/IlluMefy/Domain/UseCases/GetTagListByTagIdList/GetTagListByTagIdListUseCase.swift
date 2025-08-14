//
//  GetTagListByTagIdListUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/14.
//

import Foundation

final class GetTagListByTagIdListUseCase: GetTagListByTagIdListUseCaseProtocol {
    
    private let tagRepository: TagRepositoryProtocol
    
    init(tagRepository: TagRepositoryProtocol) {
        self.tagRepository = tagRepository
    }
    
    func execute(request: GetTagListByTagIdListUseCaseRequest) async throws -> GetTagListByTagIdListUseCaseResponse {
        guard !request.tagIdList.isEmpty else {
            throw GetTagListByTagIdListUseCaseError.invalidTagIdList("タグIDリストが空です")
        }
        
        do {
            let response = try await tagRepository.getTagListByIdList(tagIdList: request.tagIdList)
            
            // TagDataModel から Tag ドメインモデルに変換
            let tags = response.data.map { tagDataModel in
                Tag(
                    id: tagDataModel.id,
                    displayName: tagDataModel.name,
                    tagName: tagDataModel.name.lowercased(),
                    clickedCount: tagDataModel.viewCount,
                    createdAt: tagDataModel.createdAt.toDate,
                    updatedAt: tagDataModel.updatedAt.toDate
                )
            }
            
            return GetTagListByTagIdListUseCaseResponse(tags: tags)
            
        } catch let error as RepositoryErrorProtocol {
            throw GetTagListByTagIdListUseCaseError.repositoryError(error)
        } catch {
            if error.localizedDescription.contains("network") || error.localizedDescription.contains("Network") {
                throw GetTagListByTagIdListUseCaseError.networkError(error)
            } else {
                throw GetTagListByTagIdListUseCaseError.unknown(error)
            }
        }
    }
}