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
        // プラットフォームURLマップの構築
        var platformMap: [PlatformDomainModel: String] = [:]
        
        // YouTube
        if let youtube = response.platforms.youtube {
            let youtubeUrl = "https://youtube.com/@\(youtube.username)"
            platformMap[.youtube] = youtubeUrl
        }
        
        // Twitch
        if let twitch = response.platforms.twitch {
            platformMap[.twitch] = twitch.socialLink
        }
        
        // TikTok
        if let tiktok = response.platforms.tiktok {
            platformMap[.tiktok] = tiktok.socialLink
        }
        
        // Instagram
        if let instagram = response.platforms.instagram {
            platformMap[.instagram] = instagram.socialLink
        }
        
        // ニコニコ動画
        if let niconico = response.platforms.niconico {
            platformMap[.niconico] = niconico.socialLink
        }
        
        // プラットフォームクリック率（バックエンドにないので均等配分）
        var platformClickRatio: [PlatformDomainModel: Double] = [:]
        let platformCount = Double(platformMap.count)
        if platformCount > 0 {
            let ratio = 1.0 / platformCount
            for platform in platformMap.keys {
                platformClickRatio[platform] = ratio
            }
        }
        
        return Creator(
            id: response.id,
            name: response.name,
            thumbnailUrl: response.profileImageUrl,
            socialLinkClickCount: 0, // バックエンドにないのでデフォルト値
            tag: response.tags,
            description: response.description,
            platform: platformMap,
            createdAt: response.createdAt.toDate,
            updatedAt: response.updatedAt.toDate,
            favoriteCount: response.favoriteCount
        )
    }
}
