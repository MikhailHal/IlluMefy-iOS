//
//  GetTagListByTagIdListUseCaseResponse.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/14.
//

import Foundation

struct GetTagListByTagIdListUseCaseResponse {
    let tags: [Tag]
    
    init(tags: [Tag]) {
        // clickedCountでソート（降順）
        self.tags = tags.sorted { $0.clickedCount > $1.clickedCount }
    }
}