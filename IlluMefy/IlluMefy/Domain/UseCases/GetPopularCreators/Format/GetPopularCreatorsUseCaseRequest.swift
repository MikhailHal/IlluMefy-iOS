//
//  GetPopularCreatorsUseCaseRequest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

struct GetPopularCreatorsUseCaseRequest {
    let limit: Int
    
    init(limit: Int = 20) {
        self.limit = min(max(limit, 1), 100) // 1-100の範囲に制限
    }
}
