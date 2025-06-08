//
//  Creator.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//
import Foundation

/**
 クリエイターエンティティ
 
 IlluMefyアプリにおけるゲーミングクリエイター情報を管理するコアエンティティです。
 複数のプラットフォームでの活動状況とユーザーによる人気度を追跡します。
 
 ## 主な機能
 
 - 複数プラットフォームでの活動管理
 - プラットフォーム別クリック率による人気度測定
 - ユーザー生成タグとの関連付け
 - 人気度に基づく自動ソート機能
 
 ## 使用例
 
 ```swift
 let creator = Creator(
     id: "creator_001",
     name: "ゲーム実況者A",
     thumbnailUrl: "https://example.com/thumbnail.jpg",
     viewCount: 1500,
     socialLinkClickCount: 300,
     platformClickRatio: [
         .youtube: 0.6,
         .twitch: 0.4
     ],
     relatedTag: ["fps", "apex-legends"],
     description: "FPSゲームをメインに実況しています",
     platform: [
         .youtube: "https://youtube.com/@creator",
         .twitch: "https://twitch.tv/creator"
     ],
     createdAt: Date(),
     updatedAt: Date(),
     isActive: true
 )
 
 // プラットフォームを人気順に取得
 let sortedPlatforms = creator.sortedPlatformListByPriority()
 ```
 */
struct Creator: Equatable, Codable, Identifiable {
    
    /// クリエイターの一意識別子
    let id: String
    
    /// クリエイター名
    /// 
    /// ユーザーに表示される名前です。プラットフォーム名と異なる場合があります。
    /// 例: "ゲーム実況者A", "VTuber_B"
    let name: String
    
    /// サムネイル画像のURL
    /// 
    /// プロフィール画像として使用されます。
    /// 正方形または円形での表示を想定しています。
    let thumbnailUrl: String
    
    /// プロフィールページの閲覧回数
    /// 
    /// IlluMefyアプリ内でクリエイターページが開かれた総回数です。
    /// 人気度の指標として使用されます。
    let viewCount: Int
    
    /// ソーシャルリンクの総クリック回数
    /// 
    /// 全プラットフォームのリンクがクリックされた合計回数です。
    /// 外部サイトへの遷移数を表します。
    let socialLinkClickCount: Int
    
    /// プラットフォーム別クリック率
    /// 
    /// 各プラットフォームへのクリック率（0.0〜1.0）を保持します。
    /// 全プラットフォームの合計は1.0になります。
    /// 人気プラットフォームの自動判定に使用されます。
    /// 
    /// - Note: データが不十分な場合は全て同じ値になることがあります
    let platformClickRatio: [Platform: Double]
    
    /// 関連タグのIDリスト
    /// 
    /// このクリエイターに関連付けられたタグのIDを保持します。
    /// フォークソノミーによってユーザーが追加可能です。
    /// 
    /// - Important: TagエンティティのIDを参照しています
    let relatedTag: [String]
    
    /// クリエイターの説明文
    /// 
    /// 自己紹介や活動内容の説明です。
    /// プロフィールページで表示されます。
    let description: String?
    
    /// プラットフォーム別のURLマップ
    /// 
    /// 各プラットフォームでのプロフィールURLを保持します。
    /// キーがプラットフォーム、値がそのプラットフォームでのURLです。
    /// 
    /// ```swift
    /// [
    ///     .youtube: "https://youtube.com/@creator",
    ///     .twitch: "https://twitch.tv/creator"
    /// ]
    /// ```
    let platform: [Platform: String]
    
    /// クリエイターがアプリに登録された日時
    let createdAt: Date
    
    /// クリエイター情報が最後に更新された日時
    let updatedAt: Date
    
    /// 活動状況フラグ
    /// 
    /// `true`: 現在も活動中
    /// `false`: 活動停止中（非表示対象）
    let isActive: Bool
    
    /// クリエイターが活動しているプラットフォーム一覧を取得
    /// 
    /// - Returns: プラットフォームの配列（順序は保証されません）
    func getPlatformList() -> [Platform] {
        return Array(platform.keys)
    }
    
    /// プラットフォームを人気度順にソートして取得
    /// 
    /// プラットフォーム別クリック率に基づいて人気順にソートします。
    /// 全プラットフォームのクリック率が同一の場合は、
    /// デフォルトの優先順位（YouTube > Twitch > TikTok...）で返します。
    /// 
    /// - Returns: (プラットフォーム, URL)のタプル配列（人気順）
    func sortedPlatformListByPriority() -> [(Platform, String)] {
        // 全プラットフォームの比率が同一であればデフォルト順を返却
        let isAllPratformRatioEqual = Set(self.platformClickRatio.values).count <= 1
        if isAllPratformRatioEqual {
            return sortedPlatformListByDefaultPriority()
        }
        // 比率が異なればソートして返却
        return self.platformClickRatio
            .sorted { $0.value > $1.value }
            .compactMap { platform, _ in
                guard let url = self.platform[platform] else { return nil }
                return (platform, url)
            }
    }
    
    // MARK: private functions
    
    /// デフォルトの優先順位でプラットフォームをソート
    /// 
    /// 一般的な人気度に基づく固定の優先順位でソートします。
    /// YouTube > Twitch > TikTok > Instagram > Twitter > Discord > ニコニコ動画 > Mildom
    /// 
    /// - Returns: (プラットフォーム, URL)のタプル配列（デフォルト優先順）
    private func sortedPlatformListByDefaultPriority() -> [(Platform, String)] {
        let defaultOrder: [Platform] = [
            .youtube,
            .twitch,
            .tiktok,
            .instagram,
            .twitter,
            .discord,
            .niconico,
            .mildom
        ]
        
        var tuple: [(Platform, String)] = []
        for platform in defaultOrder {
            if let url = self.platform[platform] {
                tuple.append((platform, url))
            }
        }
        
        // デフォルト順序にない新しいプラットフォームも追加
        for (platform, url) in self.platform where !tuple.contains(where: { t in t.0 == platform}) {
            tuple.append((platform, url))
        }
        
        return tuple
    }
}
