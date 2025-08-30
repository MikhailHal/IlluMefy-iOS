//
//  AlgoliaRepository.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/30.
//

import Foundation
import FirebaseRemoteConfig
import AlgoliaSearchClient

/// Algolia検索リポジトリ実装
final class AlgoliaRepository: AlgoliaRepositoryProtocol {
    private var client: SearchClient?
    private let firebaseRemoteConfig: FirebaseRemoteConfigProtocol
    
    init(firebaseRemoteConfig: FirebaseRemoteConfigProtocol) {
        self.firebaseRemoteConfig = firebaseRemoteConfig
    }
    
    /// Remote ConfigからAlgoliaクライアントを初期化
    func initialize() async {
        guard client == nil else { return }
        
        guard let appId: String = firebaseRemoteConfig.fetchValue(key: "algolia_app_id"),
              let searchKey: String = firebaseRemoteConfig.fetchValue(key: "algolia_search_api_key"),
              !appId.isEmpty && !searchKey.isEmpty else {
            print("Algolia configuration not found in Remote Config")
            return
        }
        
        client = SearchClient(appID: ApplicationID(rawValue: appId), apiKey: APIKey(rawValue: searchKey))
    }
    
    /// タグ検索
    func searchTags(query: String, limit: Int = 20) async throws -> SearchTagsResponse {
        guard let client = client else {
            throw AlgoliaError.notInitialized
        }
        
        // 空クエリの場合は空結果を返す（Algoliaは空クエリで全件返すため）
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return SearchTagsResponse(tags: [], totalCount: 0)
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let indexName = IndexName(rawValue: "tags")
            let index = client.index(withName: indexName)
            
            let searchQuery = Query(query)
                .set(\.hitsPerPage, to: limit)
            
            index.search(query: searchQuery) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: AlgoliaError.searchFailed(error.localizedDescription))
                case .success(let response):
                    do {
                        let algoliaHits: [SearchTagItem] = try response.extractHits()
                        
                        // 検索結果が空の場合は空リストを返す
                        guard !algoliaHits.isEmpty else {
                            let emptyResponse = SearchTagsResponse(tags: [], totalCount: 0)
                            continuation.resume(returning: emptyResponse)
                            return
                        }
                        
                        let searchResponse = SearchTagsResponse(
                            tags: algoliaHits,
                            totalCount: algoliaHits.count
                        )
                        continuation.resume(returning: searchResponse)
                    } catch {
                        continuation.resume(throwing: AlgoliaError.searchFailed(error.localizedDescription))
                    }
                }
            }
        }
    }
}

