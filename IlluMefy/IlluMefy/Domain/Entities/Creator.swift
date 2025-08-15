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
 */
struct Creator: Equatable, Codable, Identifiable, Hashable {
    
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
    
    /// ソーシャルリンクの総クリック回数
    /// 
    /// 全プラットフォームのリンクがクリックされた合計回数です。
    /// 外部サイトへの遷移数を表します。
    let socialLinkClickCount: Int
    
    /// 関連タグのIDリスト
    /// 
    /// このクリエイターに関連付けられたタグのIDを保持します。
    /// フォークソノミーによってユーザーが追加可能です。
    /// 
    /// - Important: TagエンティティのIDを参照しています
    let tag: [String]
    
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
    let platform: [PlatformDomainModel: String]
    
    /// YouTubeチャンネル情報
    let youtube: YouTubeChannelDomainModel?
    
    /// クリエイターがアプリに登録された日時
    let createdAt: Date
    
    /// クリエイター情報が最後に更新された日時
    let updatedAt: Date
    
    /// お気に入り数
    let favoriteCount: Int
}
