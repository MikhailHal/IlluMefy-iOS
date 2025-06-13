//
//  GetCreatorDetailUseCaseRequest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// クリエイター詳細取得ユースケースのリクエスト
struct GetCreatorDetailUseCaseRequest {
    /// 取得するクリエイターのID
    let creatorId: String
    
    /// 類似クリエイターの取得件数（デフォルト: 3件）
    let similarCreatorsLimit: Int
    
    init(creatorId: String, similarCreatorsLimit: Int = 3) {
        self.creatorId = creatorId
        self.similarCreatorsLimit = similarCreatorsLimit
    }
}
