//
//  Tag.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

/**
 タグエンティティ
 
 IlluMefyアプリにおけるタグ管理のコアエンティティです。
 階層構造をサポートし、クリエイターの分類や検索に使用されます。
 
 ## 階層構造
 
 タグは単一の親と複数の子を持つ階層構造を形成できます：
 
 ```
 ゲーム (ルートタグ)
 ├─ FPS
 │  ├─ Apex Legends
 │  └─ Valorant
 └─ RPG
    ├─ FF14
    └─ 原神
 ```
 
 ## 使用例
 
 ```swift
 let gameTag = Tag(
     id: "game",
     displayName: "ゲーム",
     tagName: "game",
     clickedCount: 1500,
     createdAt: Date(),
     updatedAt: Date(),
     parentTagId: nil,  // ルートタグ
     childTagIds: ["fps", "rpg"]
 )
 ```
 */
struct Tag: Equatable, Codable, Identifiable, Hashable {
    
    /// タグの一意識別子
    let id: String
    
    /// ユーザーに表示される名前
    /// 
    /// UI上で表示される、人間が読みやすい形式の名前です。
    /// 例: "Apex Legends", "イエローベース"
    let displayName: String
    
    /// システム内部で使用される名前
    /// 
    /// API通信や内部処理で使用される、正規化された名前です。
    /// 通常は英数字とハイフンで構成されます。
    /// 例: "apex-legends", "yellow-base"
    let tagName: String
    
    /// タグがクリック（選択）された回数
    /// 
    /// ユーザーによる使用頻度を表す指標です。
    /// 人気タグの特定やランキング表示に使用されます。
    let clickedCount: Int
    
    /// タグが作成された日時
    let createdAt: Date
    
    /// タグが最後に更新された日時
    let updatedAt: Date
    
    /// 親タグのID
    /// 
    /// 階層構造における親タグの識別子です。
    /// ルートタグの場合は`nil`となります。
    /// 
    /// - Note: 単一の親のみサポートします（多重継承なし）
    let parentTagId: String?
    
    /// 子タグのIDリスト
    /// 
    /// 階層構造における直接の子タグの識別子リストです。
    /// 末端タグの場合は空配列となります。
    /// 
    /// - Important: IDのみを保持することで循環参照を防いでいます
    let childTagIds: [String]
}
