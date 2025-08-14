//
//  GetPopularTagsUseCaseRequest.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/14.
//

import Foundation

struct GetPopularTagsUseCaseRequest {
    let limit: Int
    
    init(limit: Int = 20) {
        self.limit = min(max(limit, 1), 100) // 1-100の範囲に制限
    }
}