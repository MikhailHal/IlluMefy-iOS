//
//  GetNewestCreatorsUseCaseRequest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/12.
//

import Foundation

struct GetNewestCreatorsUseCaseRequest {
    let limit: Int
    
    init(limit: Int = 20) {
        self.limit = min(max(limit, 1), 100) // 1-100の範囲に制限
    }
}