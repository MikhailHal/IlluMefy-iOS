//
//  MockTagRepository.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// タグリポジトリのモック実装
final class MockTagRepository: TagRepositoryProtocol {
    
    // MARK: - Mock Data
    
    private let mockTags: [Tag] = [
        Tag(id: "tag_001", displayName: "ゲーム", tagName: "game", clickedCount: 1500, createdAt: Date(), updatedAt: Date(), parentTagId: nil, childTagIds: ["tag_007", "tag_008"]),
        Tag(id: "tag_002", displayName: "料理", tagName: "cooking", clickedCount: 800, createdAt: Date(), updatedAt: Date(), parentTagId: nil, childTagIds: []),
        Tag(id: "tag_003", displayName: "音楽", tagName: "music", clickedCount: 900, createdAt: Date(), updatedAt: Date(), parentTagId: nil, childTagIds: []),
        Tag(id: "tag_004", displayName: "アニメ", tagName: "anime", clickedCount: 1200, createdAt: Date(), updatedAt: Date(), parentTagId: nil, childTagIds: []),
        Tag(id: "tag_005", displayName: "技術", tagName: "tech", clickedCount: 700, createdAt: Date(), updatedAt: Date(), parentTagId: nil, childTagIds: []),
        Tag(id: "tag_006", displayName: "教育", tagName: "education", clickedCount: 600, createdAt: Date(), updatedAt: Date(), parentTagId: nil, childTagIds: []),
        Tag(id: "tag_007", displayName: "FPS", tagName: "fps", clickedCount: 500, createdAt: Date(), updatedAt: Date(), parentTagId: "tag_001", childTagIds: []),
        Tag(id: "tag_008", displayName: "RPG", tagName: "rpg", clickedCount: 400, createdAt: Date(), updatedAt: Date(), parentTagId: "tag_001", childTagIds: []),
        Tag(id: "tag_009", displayName: "VTuber", tagName: "vtuber", clickedCount: 1100, createdAt: Date(), updatedAt: Date(), parentTagId: nil, childTagIds: []),
        Tag(id: "tag_010", displayName: "配信", tagName: "streaming", clickedCount: 950, createdAt: Date(), updatedAt: Date(), parentTagId: nil, childTagIds: []),
        Tag(id: "tag_011", displayName: "実況", tagName: "gameplay", clickedCount: 850, createdAt: Date(), updatedAt: Date(), parentTagId: nil, childTagIds: []),
        Tag(id: "tag_012", displayName: "レビュー", tagName: "review", clickedCount: 650, createdAt: Date(), updatedAt: Date(), parentTagId: nil, childTagIds: []),
        Tag(id: "tag_013", displayName: "マインクラフト", tagName: "minecraft", clickedCount: 750, createdAt: Date(), updatedAt: Date(), parentTagId: "tag_001", childTagIds: []),
        Tag(id: "tag_014", displayName: "プロゲーマー", tagName: "professional", clickedCount: 300, createdAt: Date(), updatedAt: Date(), parentTagId: nil, childTagIds: []),
    ]
    
    // MARK: - TagRepositoryProtocol
    
    func searchByName(
        andQuery: String,
        orQuery: String,
        offset: Int,
        limit: Int
    ) async throws -> TagSearchResult {
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3秒
        
        var filteredTags: [Tag] = []
        
        if !andQuery.isEmpty && !orQuery.isEmpty {
            // AND条件とOR条件の両方がある場合
            let andKeywords = andQuery.components(separatedBy: " ").filter { !$0.isEmpty }
            let orKeywords = orQuery.components(separatedBy: " ").filter { !$0.isEmpty }
            
            filteredTags = mockTags.filter { tag in
                let andMatches = andKeywords.allSatisfy { keyword in
                    tag.displayName.localizedCaseInsensitiveContains(keyword) ||
                    tag.tagName.localizedCaseInsensitiveContains(keyword)
                }
                let orMatches = orKeywords.contains { keyword in
                    tag.displayName.localizedCaseInsensitiveContains(keyword) ||
                    tag.tagName.localizedCaseInsensitiveContains(keyword)
                }
                return andMatches && orMatches
            }
        } else if !andQuery.isEmpty {
            // AND条件のみ
            let keywords = andQuery.components(separatedBy: " ").filter { !$0.isEmpty }
            filteredTags = mockTags.filter { tag in
                keywords.allSatisfy { keyword in
                    tag.displayName.localizedCaseInsensitiveContains(keyword) ||
                    tag.tagName.localizedCaseInsensitiveContains(keyword)
                }
            }
        } else if !orQuery.isEmpty {
            // OR条件のみ
            let keywords = orQuery.components(separatedBy: " ").filter { !$0.isEmpty }
            filteredTags = mockTags.filter { tag in
                keywords.contains { keyword in
                    tag.displayName.localizedCaseInsensitiveContains(keyword) ||
                    tag.tagName.localizedCaseInsensitiveContains(keyword)
                }
            }
        } else {
            // 条件なしの場合は全タグ（人気順）
            filteredTags = mockTags.sorted { $0.clickedCount > $1.clickedCount }
        }
        
        // クリック数でソート
        let sortedTags = filteredTags.sorted { $0.clickedCount > $1.clickedCount }
        
        // ページネーション
        let totalCount = sortedTags.count
        let startIndex = offset
        let endIndex = min(startIndex + limit, totalCount)
        
        guard startIndex < totalCount else {
            return TagSearchResult(
                tags: [],
                totalCount: totalCount,
                hasMore: false
            )
        }
        
        let pageTags = Array(sortedTags[startIndex..<endIndex])
        let hasMore = endIndex < totalCount
        
        return TagSearchResult(
            tags: pageTags,
            totalCount: totalCount,
            hasMore: hasMore
        )
    }
    
    func getAllTags() async throws -> [Tag] {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2秒
        return mockTags.sorted { $0.clickedCount > $1.clickedCount }
    }
    
    func getPopularTags(limit: Int) async throws -> [Tag] {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2秒
        return Array(mockTags
            .sorted { $0.clickedCount > $1.clickedCount }
            .prefix(limit))
    }
}