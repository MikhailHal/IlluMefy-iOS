//
//  PlatformsResponse.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/12.
//

/// プラットフォーム情報のレスポンス
struct PlatformsResponse: Codable {
    /// YouTube チャンネル情報
    let youtube: YouTubeChannelDataModel?
    
    /// Twitch 情報
    let twitch: SocialLinkPlatformResponse?
    
    /// TikTok 情報
    let tiktok: SocialLinkPlatformResponse?
    
    /// Instagram 情報
    let instagram: SocialLinkPlatformResponse?
    
    /// ニコニコ動画 情報
    let niconico: SocialLinkPlatformResponse?
}
