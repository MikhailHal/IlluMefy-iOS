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
            viewCount: 5000,
            socialLinkClickCount: 1500,
            platformClickRatio: [
                .youtube: 0.7,
                .twitch: 0.3
            ],
            relatedTag: ["fps", "apex-legends", "valorant"],
            description: "FPSゲームをメインに実況しています。毎日20時から配信！",
            platform: [
                .youtube: "https://youtube.com/@gameplayerA",
                .twitch: "https://twitch.tv/gameplayerA",
                .x: "https://twitter.com/gameplayerA"
            ],
            createdAt: Date().addingTimeInterval(-86400 * 30),
            updatedAt: Date().addingTimeInterval(-3600),
            isActive: true
        ),
        Creator(
            id: "creator_002", 
            name: "VTuber B",
            thumbnailUrl: "https://picsum.photos/200/200?random=2",
            viewCount: 9000,
            socialLinkClickCount: 2000,
            platformClickRatio: [
                .x: 0.6,
                .youtube: 0.4
            ],
            relatedTag: ["vtuber", "fps", "minecraft", "singing"],
            description: "歌ってゲームして楽しく配信してます♪",
            platform: [
                .youtube: "https://youtube.com/@vtuberB",
                .x: "https://twitter.com/vtuberB"
            ],
            createdAt: Date().addingTimeInterval(-86400 * 60),
            updatedAt: Date().addingTimeInterval(-7200),
            isActive: true
        ),
        Creator(
            id: "creator_003",
            name: "プロゲーマーC",
            thumbnailUrl: "https://picsum.photos/200/200?random=3",
            viewCount: 11000,
            socialLinkClickCount: 4000,
            platformClickRatio: [
                .instagram: 0.5,
                .twitch: 0.3,
                .youtube: 0.2
            ],
            relatedTag: ["fps", "valorant", "professional", "tournament"],
            description: "プロゲーマーとして活動中。大会実績多数。",
            platform: [
                .twitch: "https://twitch.tv/progamerC",
                .youtube: "https://youtube.com/@progamerC",
                .x: "https://twitter.com/progamerC",
                .instagram: "https://instagram.com/progamerC"
            ],
            createdAt: Date().addingTimeInterval(-86400 * 90),
            updatedAt: Date().addingTimeInterval(-86400),
            isActive: true
        ),
        Creator(
            id: "creator_004",
            name: "カジュアル実況D",
            thumbnailUrl: "https://picsum.photos/200/200?random=4",
            viewCount: 3000,
            socialLinkClickCount: 500,
            platformClickRatio: [
                .youtube: 1.0
            ],
            relatedTag: ["minecraft", "casual", "building"],
            description: "マイクラ建築をまったり実況。初心者歓迎！",
            platform: [
                .youtube: "https://youtube.com/@casualD"
            ],
            createdAt: Date().addingTimeInterval(-86400 * 45),
            updatedAt: Date().addingTimeInterval(-86400 * 5),
            isActive: true
        ),
        Creator(
            id: "creator_005",
            name: "レトロゲーム愛好家E",
            thumbnailUrl: "https://picsum.photos/200/200?random=5",
            viewCount: 10000,
            socialLinkClickCount: 800,
            platformClickRatio: [
                .niconico: 0.7,
                .youtube: 0.3
            ],
            relatedTag: ["retro", "speedrun", "classic-games"],
            description: "レトロゲームのRTAやってます。週末配信。",
            platform: [
                .youtube: "https://youtube.com/@retroE",
                .niconico: "https://www.nicovideo.jp/user/12345678"
            ],
            createdAt: Date().addingTimeInterval(-86400 * 120),
            updatedAt: Date().addingTimeInterval(-86400 * 2),
            isActive: true
        ),
        Creator(
            id: "creator_006",
            name: "TikTokダンサーF",
            thumbnailUrl: "https://picsum.photos/200/200?random=6",
            viewCount: 7500,
            socialLinkClickCount: 2500,
            platformClickRatio: [
                .tiktok: 0.8,
                .instagram: 0.2
            ],
            relatedTag: ["dance", "trending", "entertainment"],
            description: "バズるダンス動画を毎日投稿！フォロー待ってます！",
            platform: [
                .tiktok: "https://tiktok.com/@dancerF",
                .instagram: "https://instagram.com/dancerF"
            ],
            createdAt: Date().addingTimeInterval(-86400 * 15),
            updatedAt: Date().addingTimeInterval(-1800),
            isActive: true
        ),
        Creator(
            id: "creator_007",
            name: "Discord司会者G",
            thumbnailUrl: "https://picsum.photos/200/200?random=7",
            viewCount: 8000,
            socialLinkClickCount: 400,
            platformClickRatio: [
                .discord: 0.7,
                .youtube: 0.3
            ],
            relatedTag: ["community", "events", "discussion"],
            description: "ゲームコミュニティの運営とイベント司会をしています。",
            platform: [
                .discord: "https://discord.gg/communityG",
                .youtube: "https://youtube.com/@hostG"
            ],
            createdAt: Date().addingTimeInterval(-86400 * 75),
            updatedAt: Date().addingTimeInterval(-86400 * 3),
            isActive: true
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
            !Set(creator.relatedTag).isDisjoint(with: Set(tagIds))
        }
    }
    
    func getPopularCreators(limit: Int) async throws -> [Creator] {
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3秒
        return Array(mockCreators
            .sorted { $0.viewCount > $1.viewCount }
            .prefix(limit))
    }
}
