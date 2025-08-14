//
//  GetTagListByTagIdListUseCaseRequest.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/14.
//

import Foundation

struct GetTagListByTagIdListUseCaseRequest {
    let tagIdList: [String]
    
    init(tagIdList: [String]) {
        // 重複除去と空文字列フィルタリング
        let uniqueTagIds = Array(Set(tagIdList.filter { !$0.isEmpty }))
        self.tagIdList = Array(uniqueTagIds.prefix(50)) // 最大50件に制限
    }
}