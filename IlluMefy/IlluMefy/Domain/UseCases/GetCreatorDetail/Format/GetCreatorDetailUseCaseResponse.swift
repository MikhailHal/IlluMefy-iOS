//
//  GetCreatorDetailUseCaseResponse.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// クリエイター詳細取得ユースケースのレスポンス
struct GetCreatorDetailUseCaseResponse {
    /// 取得されたクリエイター
    let creator: Creator
    
    /// 類似クリエイター一覧
    let similarCreators: [Creator]
}
