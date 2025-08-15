//
//  GetPopularCreatorsUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

/**
 人気クリエイター取得ユースケース
 
 アプリ内で人気の高いクリエイターを取得します。
 ホーム画面のおすすめ表示などで使用されます。
 */
final class GetPopularCreatorsUseCase: GetPopularCreatorsUseCaseProtocol {
    
    private let creatorRepository: CreatorRepositoryProtocol
    
    init(creatorRepository: CreatorRepositoryProtocol) {
        self.creatorRepository = creatorRepository
    }
    
    func execute(request: GetPopularCreatorsUseCaseRequest) async throws -> GetPopularCreatorsUseCaseResponse {
        do {
            let response = try await creatorRepository.getPopularCreators(limit: request.limit)
            let creators = convertResponseToCreators(response)
            return GetPopularCreatorsUseCaseResponse(
                creators: creators,
                hasMore: creators.count == request.limit
            )
        } catch let error as CreatorRepositoryError {
            throw GetPopularCreatorsUseCaseError.repositoryError(error)
        } catch {
            throw GetPopularCreatorsUseCaseError.unknown(error)
        }
    }
    
    // MARK: - Private Methods
    
    /// GetPopularCreatorsResponseをCreatorの配列に変換
    private func convertResponseToCreators(_ response: GetPopularCreatorsResponse) -> [Creator] {
        return response.data.map { creatorResponse in
            convertCreatorDataModel(creatorResponse)
        }
    }
    
    /// CreatorDataModelをCreatorドメインエンティティに変換
    private func convertCreatorDataModel(_ response: CreatorDataModel) -> Creator {
        // YouTubeチャンネル情報の構築
        var youtubeChannel: YouTubeChannelDomainModel?
        if let youtube = response.platforms.youtube {
            youtubeChannel = YouTubeChannelDomainModel(
                channelId: youtube.channelId,
                channelName: youtube.username,
                subscriberCount: youtube.subscriberCount,
                numberOfViews: youtube.viewCount
            )
        }
        
        return Creator(
            id: response.id,
            name: response.name,
            thumbnailUrl: response.profileImageUrl,
            socialLinkClickCount: 0, // バックエンドにないのでデフォルト値
            tag: response.tags,
            description: response.description,
            youtube: youtubeChannel,
            createdAt: response.createdAt.toDate,
            updatedAt: response.updatedAt.toDate,
            favoriteCount: response.favoriteCount
        )
    }
}
