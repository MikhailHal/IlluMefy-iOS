//
//  MockCreatorDetailData.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// CreatorDetail画面のプレビュー用モックデータ
struct MockCreatorDetailData {
    
    /// プレビュー用のクリエイターデータ
    static let sampleCreator = Creator(
        id: "preview_creator_001",
        name: "プレビュークリエイター",
        thumbnailUrl: "https://picsum.photos/200/200?random=99",
        viewCount: 12500,
        socialLinkClickCount: 3400,
        platformClickRatio: [
            .youtube: 0.6,
            .twitch: 0.3,
            .x: 0.1
        ],
        relatedTag: ["gaming", "fps", "streaming", "entertainment"],
        description: "ゲーム実況をメインに活動中。主にFPSゲームをプレイしています。",
        platform: [
            .youtube: "https://youtube.com/@preview",
            .twitch: "https://twitch.tv/preview",
            .x: "https://twitter.com/preview",
            .instagram: "https://instagram.com/preview"
        ],
        createdAt: Date().addingTimeInterval(-86400 * 30),
        updatedAt: Date().addingTimeInterval(-3600),
        isActive: true
    )
    
    /// プレビュー用の類似クリエイターデータ
    static let similarCreators = [
        Creator(
            id: "similar_001",
            name: "類似クリエイター1",
            thumbnailUrl: "https://picsum.photos/200/200?random=101",
            viewCount: 8900,
            socialLinkClickCount: 2100,
            platformClickRatio: [.youtube: 0.8, .twitch: 0.2],
            relatedTag: ["gaming", "fps"],
            description: "FPSゲーマー",
            platform: [
                .youtube: "https://youtube.com/@similar1",
                .twitch: "https://twitch.tv/similar1"
            ],
            createdAt: Date().addingTimeInterval(-86400 * 45),
            updatedAt: Date().addingTimeInterval(-7200),
            isActive: true
        ),
        Creator(
            id: "similar_002",
            name: "類似クリエイター2",
            thumbnailUrl: "https://picsum.photos/200/200?random=102",
            viewCount: 7600,
            socialLinkClickCount: 1800,
            platformClickRatio: [.youtube: 0.7, .x: 0.3],
            relatedTag: ["streaming", "entertainment"],
            description: "エンターテイメント配信者",
            platform: [
                .youtube: "https://youtube.com/@similar2",
                .x: "https://twitter.com/similar2"
            ],
            createdAt: Date().addingTimeInterval(-86400 * 20),
            updatedAt: Date().addingTimeInterval(-1800),
            isActive: true
        ),
        Creator(
            id: "similar_003",
            name: "類似クリエイター3",
            thumbnailUrl: "https://picsum.photos/200/200?random=103",
            viewCount: 6200,
            socialLinkClickCount: 1400,
            platformClickRatio: [.twitch: 0.9, .discord: 0.1],
            relatedTag: ["gaming", "streaming"],
            description: "ゲーム配信メイン",
            platform: [
                .twitch: "https://twitch.tv/similar3",
                .discord: "https://discord.gg/similar3"
            ],
            createdAt: Date().addingTimeInterval(-86400 * 60),
            updatedAt: Date().addingTimeInterval(-3600 * 6),
            isActive: true
        )
    ]
}
