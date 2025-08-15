//
//  MockCreatorRepository.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

/**
 クリエイターリポジトリのモック実装
 
 開発・テスト用のダミーデータを返す実装です。
 */
final class MockCreatorRepository: CreatorRepositoryProtocol {
    
    // MARK: - Mock Data
    
    private let mockCreators: [Creator] = [
        Creator(
            id: "creator_001",
            name: "ゲーム実況者A",
            thumbnailUrl: "https://picsum.photos/200/200?random=1",
            socialLinkClickCount: 1500,
            tag: ["tag_007", "tag_011"],
            description: "FPSゲームをメインに実況しています。毎日20時から配信！",
            youtube: YouTubeChannelDomainModel(
                channelId: "UCgameplayerA",
                channelName: "gameplayerA",
                subscriberCount: 150000,
                numberOfViews: 5000000
            ),
            createdAt: Date().addingTimeInterval(-86400 * 30),
            updatedAt: Date().addingTimeInterval(-3600),
            favoriteCount: 100
        ),
        Creator(
            id: "creator_002", 
            name: "VTuber B",
            thumbnailUrl: "https://picsum.photos/200/200?random=2",
            socialLinkClickCount: 2000,
            tag: ["tag_009", "tag_007", "tag_001", "tag_004"],
            description: "歌ってゲームして楽しく配信してます♪ アニメも大好き！",
            youtube: YouTubeChannelDomainModel(
                channelId: "UCvtuberB",
                channelName: "vtuberB",
                subscriberCount: 200000,
                numberOfViews: 8000000
            ),
            createdAt: Date().addingTimeInterval(-86400 * 60),
            updatedAt: Date().addingTimeInterval(-7200),
            favoriteCount: 100
        ),
        Creator(
            id: "creator_003",
            name: "プロゲーマーC",
            thumbnailUrl: "https://picsum.photos/200/200?random=3",
            socialLinkClickCount: 4000,
            tag: ["tag_007", "tag_005", "tag_014"],
            description: "プロゲーマーとして活動中。大会実績多数。",
            youtube: YouTubeChannelDomainModel(
                channelId: "UCprogamerC",
                channelName: "progamerC",
                subscriberCount: 400000,
                numberOfViews: 15000000
            ),
            createdAt: Date().addingTimeInterval(-86400 * 90),
            updatedAt: Date().addingTimeInterval(-86400),
            favoriteCount: 100
        ),
        Creator(
            id: "creator_004",
            name: "カジュアル実況D",
            thumbnailUrl: "https://picsum.photos/200/200?random=4",
            socialLinkClickCount: 500,
            tag: ["tag_001", "tag_013"],
            description: "マイクラ建築をまったり実況。初心者歓迎！",
            youtube: YouTubeChannelDomainModel(
                channelId: "UCcasualD",
                channelName: "casualD",
                subscriberCount: 50000,
                numberOfViews: 2000000
            ),
            createdAt: Date().addingTimeInterval(-86400 * 45),
            updatedAt: Date().addingTimeInterval(-86400 * 5),
            favoriteCount: 100
        ),
        Creator(
            id: "creator_005",
            name: "レトロゲーム愛好家E",
            thumbnailUrl: "https://picsum.photos/200/200?random=5",
            socialLinkClickCount: 800,
            tag: ["tag_001"],
            description: "レトロゲームのRTAやってます。週末配信。",
            youtube: YouTubeChannelDomainModel(
                channelId: "UCretroE",
                channelName: "retroE",
                subscriberCount: 80000,
                numberOfViews: 3000000
            ),
            createdAt: Date().addingTimeInterval(-86400 * 120),
            updatedAt: Date().addingTimeInterval(-86400 * 2),
            favoriteCount: 100
        ),
        Creator(
            id: "creator_006",
            name: "TikTokダンサーF",
            thumbnailUrl: "https://picsum.photos/200/200?random=6",
            socialLinkClickCount: 2500,
            tag: ["tag_003"],
            description: "バズるダンス動画を毎日投稿！フォロー待ってます！",
            youtube: nil,
            createdAt: Date().addingTimeInterval(-86400 * 15),
            updatedAt: Date().addingTimeInterval(-1800),
            favoriteCount: 100
        ),
        Creator(
            id: "creator_007",
            name: "Discord司会者G",
            thumbnailUrl: "https://picsum.photos/200/200?random=7",
            socialLinkClickCount: 400,
            tag: ["tag_005"],
            description: "ゲームコミュニティの運営とイベント司会をしています。",
            youtube: YouTubeChannelDomainModel(
                channelId: "UChostG",
                channelName: "hostG",
                subscriberCount: 40000,
                numberOfViews: 1200000
            ),
            createdAt: Date().addingTimeInterval(-86400 * 75),
            updatedAt: Date().addingTimeInterval(-86400 * 3),
            favoriteCount: 100
        ),
        Creator(
            id: "creator_008",
            name: "アニメ評論家H",
            thumbnailUrl: "https://picsum.photos/200/200?random=8",
            socialLinkClickCount: 3000,
            tag: ["tag_004", "tag_012"],
            description: "今期アニメの感想と考察を毎週配信。ネタバレ注意！",
            youtube: YouTubeChannelDomainModel(
                channelId: "UCanimecriticH",
                channelName: "animecriticH",
                subscriberCount: 300000,
                numberOfViews: 12000000
            ),
            createdAt: Date().addingTimeInterval(-86400 * 180),
            updatedAt: Date().addingTimeInterval(-86400),
            favoriteCount: 100
        ),
        Creator(
            id: "creator_009",
            name: "アニソンDJ_I",
            thumbnailUrl: "https://picsum.photos/200/200?random=9",
            socialLinkClickCount: 1800,
            tag: ["tag_004", "tag_003", "tag_010"],
            description: "アニソンRemixとDJ配信。毎週土曜日21時〜",
            youtube: YouTubeChannelDomainModel(
                channelId: "UCanisongDJ",
                channelName: "anisongDJ",
                subscriberCount: 180000,
                numberOfViews: 7000000
            ),
            createdAt: Date().addingTimeInterval(-86400 * 90),
            updatedAt: Date().addingTimeInterval(-7200),
            favoriteCount: 100
        )
    ]
    
    // MARK: - CreatorRepositoryProtocol
    
    func getAllCreators() async throws -> [Creator] {
        // 実際のAPIでは遅延があるのでシミュレート
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5秒
        return mockCreators
    }
    
    func getCreatorsUpdatedAfter(date: Date) async throws -> [Creator] {
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3秒
        return mockCreators.filter { $0.updatedAt > date }
    }
    
    func searchCreatorsByTags(tagIds: [String]) async throws -> [Creator] {
        try await Task.sleep(nanoseconds: 400_000_000) // 0.4秒
        return mockCreators.filter { creator in
            // いずれかのタグが含まれていればヒット
            !Set(creator.tag).isDisjoint(with: Set(tagIds))
        }
    }
    
    func getPopularCreators(limit: Int) async throws -> GetPopularCreatorsResponse {
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3秒
        
        // socialLinkClickCountでソートして人気順を決定
        let popularCreators = Array(mockCreators
            .sorted { $0.socialLinkClickCount > $1.socialLinkClickCount }
            .prefix(limit))
        
        // CreatorをCreatorDataModelに変換
        let creatorResponses = popularCreators.map { creator in
            convertCreatorToResponse(creator)
        }
        
        return GetPopularCreatorsResponse(data: creatorResponses)
    }
    
    func getNewestCreators(limit: Int) async throws -> GetNewestCreatorsResponse {
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3秒
        
        // createdAtでソートして最新順を決定
        let newestCreators = Array(mockCreators
            .sorted { $0.createdAt > $1.createdAt }
            .prefix(limit))
        
        // CreatorをCreatorDataModelに変換
        let creatorResponses = newestCreators.map { creator in
            convertCreatorToResponse(creator)
        }
        
        return GetNewestCreatorsResponse(data: creatorResponses)
    }
    
    // MARK: - Helper Methods
    
    /// CreatorをCreatorDataModelに変換（Mock用）
    private func convertCreatorToResponse(_ creator: Creator) -> CreatorDataModel {
        // プラットフォーム情報を変換
        var platforms = PlatformsResponse(
            youtube: nil,
            twitch: nil,
            tiktok: nil,
            instagram: nil,
            niconico: nil
        )
        
        // YouTubeチャンネル情報を構造化
        if let youtube = creator.youtube {
            platforms = PlatformsResponse(
                youtube: YouTubeChannelDataModel(
                    username: youtube.channelName,
                    channelId: youtube.channelId,
                    subscriberCount: youtube.subscriberCount,
                    viewCount: youtube.numberOfViews
                ),
                twitch: nil,
                tiktok: nil,
                instagram: nil,
                niconico: nil
            )
        }
        
        return CreatorDataModel(
            id: creator.id,
            name: creator.name,
            profileImageUrl: creator.thumbnailUrl,
            description: creator.description ?? "",
            favoriteCount: creator.favoriteCount,
            platforms: platforms,
            tags: creator.tag,
            tagNames: creator.tag, // Mock用に同じ値を使用
            createdAt: FirebaseTimestamp(
                _seconds: Int(creator.createdAt.timeIntervalSince1970),
                _nanoseconds: 0
            ),
            updatedAt: FirebaseTimestamp(
                _seconds: Int(creator.updatedAt.timeIntervalSince1970),
                _nanoseconds: 0
            )
        )
    }
    
    func getCreatorById(id: String) async throws -> Creator {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2秒
        guard let creator = mockCreators.first(where: { $0.id == id }) else {
            throw CreatorRepositoryError.creatorNotFound
        }
        return creator
    }
    
    func getSimilarCreators(creatorId: String, limit: Int) async throws -> [Creator] {
        try await Task.sleep(nanoseconds: 400_000_000) // 0.4秒
        
        guard let targetCreator = mockCreators.first(where: { $0.id == creatorId }) else {
            throw CreatorRepositoryError.creatorNotFound
        }
        
        // 類似度計算：共通タグ数とYouTubeチャンネル有無で評価
        let similarCreators = mockCreators
            .filter { $0.id != creatorId } // 自分自身は除外
            .map { creator in
                let commonTags = Set(creator.tag).intersection(Set(targetCreator.tag)).count
                let youtubeBonus = (creator.youtube != nil && targetCreator.youtube != nil) ? 1 : 0
                let similarityScore = commonTags * 2 + youtubeBonus // タグの重みを高く設定
                return (creator: creator, score: similarityScore)
            }
            .sorted { $0.score > $1.score }
            .filter { $0.score > 0 } // 類似度が0より大きいもののみ
            .map { $0.creator }
        
        return Array(similarCreators.prefix(limit))
    }
    
    func searchByName(
        query: String,
        sortOrder: CreatorSortOrder,
        offset: Int,
        limit: Int
    ) async throws -> CreatorSearchResult {
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3秒
        
        // 名前でフィルタリング
        let filteredCreators = mockCreators.filter { creator in
            creator.name.localizedCaseInsensitiveContains(query)
        }
        
        // ソート
        let sortedCreators = sortCreators(filteredCreators, by: sortOrder)
        
        // ページネーション
        let totalCount = sortedCreators.count
        let startIndex = offset
        let endIndex = min(startIndex + limit, totalCount)
        
        guard startIndex < totalCount else {
            return CreatorSearchResult(
                creators: [],
                totalCount: totalCount,
                hasMore: false
            )
        }
        
        let pageCreators = Array(sortedCreators[startIndex..<endIndex])
        let hasMore = endIndex < totalCount
        
        return CreatorSearchResult(
            creators: pageCreators,
            totalCount: totalCount,
            hasMore: hasMore
        )
    }
    
    func searchByTags(
        tagIds: [String],
        searchMode: TagSearchMode,
        sortOrder: CreatorSortOrder,
        offset: Int,
        limit: Int
    ) async throws -> CreatorSearchResult {
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3秒
        
        // タグでフィルタリング
        let filteredCreators = mockCreators.filter { creator in
            let creatorTags = Set(creator.tag)
            let searchTags = Set(tagIds)
            
            switch searchMode {
            case .all:
                // すべてのタグを含む（AND検索）
                return searchTags.isSubset(of: creatorTags)
            case .any:
                // いずれかのタグを含む（OR検索）
                return !creatorTags.isDisjoint(with: searchTags)
            }
        }
        
        // ソート
        let sortedCreators = sortCreators(filteredCreators, by: sortOrder)
        
        // ページネーション
        let totalCount = sortedCreators.count
        let startIndex = offset
        let endIndex = min(startIndex + limit, totalCount)
        
        guard startIndex < totalCount else {
            return CreatorSearchResult(
                creators: [],
                totalCount: totalCount,
                hasMore: false
            )
        }
        
        let pageCreators = Array(sortedCreators[startIndex..<endIndex])
        let hasMore = endIndex < totalCount
        
        return CreatorSearchResult(
            creators: pageCreators,
            totalCount: totalCount,
            hasMore: hasMore
        )
    }
    
    // MARK: - Helper Methods
    
    private func sortCreators(_ creators: [Creator], by sortOrder: CreatorSortOrder) -> [Creator] {
        switch sortOrder {
        case .popularity:
            return creators.sorted { $0.socialLinkClickCount > $1.socialLinkClickCount }
        case .newest:
            return creators.sorted { $0.createdAt > $1.createdAt }
        case .name:
            return creators.sorted { $0.name < $1.name }
        }
    }
}
