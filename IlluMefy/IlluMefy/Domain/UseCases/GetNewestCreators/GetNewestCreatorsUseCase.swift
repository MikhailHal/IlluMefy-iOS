//
//  GetNewestCreatorsUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/12.
//

import Foundation

/**
 最新クリエイター取得ユースケース
 
 アプリ内で最新のクリエイターを取得します。
 ホーム画面の最新表示などで使用されます。
 */
final class GetNewestCreatorsUseCase: GetNewestCreatorsUseCaseProtocol {
    
    private let creatorRepository: CreatorRepositoryProtocol
    
    init(creatorRepository: CreatorRepositoryProtocol) {
        self.creatorRepository = creatorRepository
    }
    
    func execute(request: GetNewestCreatorsUseCaseRequest) async throws -> GetNewestCreatorsUseCaseResponse {
        do {
            let response = try await creatorRepository.getNewestCreators(limit: request.limit)
            let creators = convertResponseToCreators(response)
            return GetNewestCreatorsUseCaseResponse(
                creators: creators,
                hasMore: creators.count == request.limit
            )
        } catch let error as CreatorRepositoryError {
            throw GetNewestCreatorsUseCaseError.repositoryError(error)
        } catch {
            throw GetNewestCreatorsUseCaseError.unknown(error)
        }
    }
    
    // MARK: - Private Methods
    
    /// GetNewestCreatorsResponseをCreatorの配列に変換
    private func convertResponseToCreators(_ response: GetNewestCreatorsResponse) -> [Creator] {
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