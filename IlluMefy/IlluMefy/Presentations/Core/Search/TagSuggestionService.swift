//
//  TagSuggestionService.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/16.
//

import Foundation

/// タグ候補生成サービス
@MainActor
final class TagSuggestionService {
    
    // MARK: - Public Methods
    
    /// 検索クエリに基づいてタグ候補を生成
    func generateSuggestions(
        query: String,
        allTags: [Tag],
        selectedTags: [Tag],
        maxSuggestions: Int = 5
    ) -> [Tag] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedQuery.isEmpty {
            return []
        }
        
        // ひらがな・カタカナ正規化した検索文字列
        let normalizedQuery = normalizeJapaneseText(trimmedQuery)
        
        // 完全一致するタグを確認
        let exactMatchTag = allTags.first { tag in
            let normalizedDisplayName = normalizeJapaneseText(tag.displayName)
            return normalizedDisplayName.lowercased() == normalizedQuery.lowercased()
        }
        
        // 完全一致するタグが既に選択済みの場合は候補を表示しない
        if let exactTag = exactMatchTag, selectedTags.contains(where: { $0.id == exactTag.id }) {
            return []
        }
        
        // 入力文字の言語を判定（より寛容に）
        let containsJapanese = trimmedQuery.contains { char in
            let scalar = char.unicodeScalars.first!
            return CharacterSet.init(charactersIn: "\u{3040}"..."\u{309F}")
                .union(CharacterSet.init(charactersIn: "\u{30A0}"..."\u{30FF}"))
                .union(CharacterSet.init(charactersIn: "\u{4E00}"..."\u{9FAF}"))
                .contains(scalar)
        }
        
        // 完全一致するタグが存在し、まだ選択されていない場合は、それを最優先で表示
        var filteredTags: [Tag] = []
        
        if let exactTag = exactMatchTag {
            filteredTags.append(exactTag)
        }
        
        // その他のマッチするタグを追加
        let otherMatchingTags = allTags.filter { tag in
            guard !selectedTags.contains(where: { $0.id == tag.id }) else { return false }
            
            // 完全一致タグは既に追加済みなのでスキップ
            if let exactTag = exactMatchTag, tag.id == exactTag.id {
                return false
            }
            
            if containsJapanese {
                // 日本語を含む入力の場合：正規化した文字列で部分一致検索
                let normalizedDisplayName = normalizeJapaneseText(tag.displayName)
                return normalizedDisplayName.localizedCaseInsensitiveContains(normalizedQuery)
            } else {
                // 英語のみの入力の場合：英語tagNameを対象に前方一致 + 正規化した日本語displayNameも部分一致で検索
                let englishMatch = tag.tagName.lowercased().hasPrefix(trimmedQuery.lowercased())
                let normalizedDisplayName = normalizeJapaneseText(tag.displayName)
                let japaneseMatch = normalizedDisplayName.localizedCaseInsensitiveContains(normalizedQuery)
                return englishMatch || japaneseMatch
            }
        }
        
        filteredTags.append(contentsOf: otherMatchingTags)
        
        // 完全一致タグが最初にある場合はソートしない（完全一致を最優先で保持）
        let sortedTags: [Tag]
        if let exactTag = exactMatchTag, !filteredTags.isEmpty && filteredTags[0].id == exactTag.id {
            // 完全一致タグ以外をソート
            let otherTags = Array(filteredTags.dropFirst())
            let sortedOtherTags = otherTags.sorted { tag1, tag2 in
                let tag1StartsWithQuery: Bool
                let tag2StartsWithQuery: Bool
                
                if containsJapanese {
                    // 日本語入力時は正規化したdisplayNameで前方一致を判定
                    let normalizedTag1 = normalizeJapaneseText(tag1.displayName)
                    let normalizedTag2 = normalizeJapaneseText(tag2.displayName)
                    tag1StartsWithQuery = normalizedTag1.lowercased().hasPrefix(normalizedQuery.lowercased())
                    tag2StartsWithQuery = normalizedTag2.lowercased().hasPrefix(normalizedQuery.lowercased())
                } else {
                    // 英語入力時はtagNameまたは正規化したdisplayNameのいずれかで前方一致を判定
                    let tag1EnglishPrefix = tag1.tagName.lowercased().hasPrefix(trimmedQuery.lowercased())
                    let normalizedTag1 = normalizeJapaneseText(tag1.displayName)
                    let tag1JapanesePrefix = normalizedTag1.lowercased().hasPrefix(normalizedQuery.lowercased())
                    tag1StartsWithQuery = tag1EnglishPrefix || tag1JapanesePrefix
                    
                    let tag2EnglishPrefix = tag2.tagName.lowercased().hasPrefix(trimmedQuery.lowercased())
                    let normalizedTag2 = normalizeJapaneseText(tag2.displayName)
                    let tag2JapanesePrefix = normalizedTag2.lowercased().hasPrefix(normalizedQuery.lowercased())
                    tag2StartsWithQuery = tag2EnglishPrefix || tag2JapanesePrefix
                }
                
                if tag1StartsWithQuery && !tag2StartsWithQuery {
                    return true
                } else if !tag1StartsWithQuery && tag2StartsWithQuery {
                    return false
                } else {
                    return tag1.clickedCount > tag2.clickedCount
                }
            }
            sortedTags = [exactTag] + sortedOtherTags
        } else {
            // 完全一致タグがない場合は通常のソート
            sortedTags = filteredTags.sorted { tag1, tag2 in
                return tag1.clickedCount > tag2.clickedCount
            }
        }
        
        // 上位指定件数
        return Array(sortedTags.prefix(maxSuggestions))
    }
    
    /// ひらがな・カタカナを正規化する（すべてひらがなに統一）
    func normalizeJapaneseText(_ text: String) -> String {
        return text.applyingTransform(.hiraganaToKatakana, reverse: true) ?? text
    }
    
    // MARK: - Private Methods
}