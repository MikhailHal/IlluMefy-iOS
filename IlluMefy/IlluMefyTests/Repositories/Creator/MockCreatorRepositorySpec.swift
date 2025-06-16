//
//  MockCreatorRepositorySpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Quick
import Nimble
import Foundation
@testable import IlluMefy

@MainActor
class MockCreatorRepositorySpec: QuickSpec {
    override class func spec() {
        describe("MockCreatorRepository") {
            var repository: MockCreatorRepository!
            
            beforeEach {
                repository = MockCreatorRepository()
            }
            
            afterEach {
                repository = nil
            }
            
            context("getAllCreators") {
                it("全クリエイターが取得できる") {
                    // When
                    var result: [Creator]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getAllCreators()
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).toNot(beNil())
                    expect(result?.count).to(equal(7))
                    expect(result?.first?.name).to(equal("ゲーム実況者A"))
                }
                
                it("クリエイターにはすべての必須プロパティが含まれる") {
                    // When
                    var result: [Creator]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getAllCreators()
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    guard let creators = result, let firstCreator = creators.first else {
                        fail("クリエイターが取得できませんでした")
                        return
                    }
                    
                    expect(firstCreator.id).toNot(beEmpty())
                    expect(firstCreator.name).toNot(beEmpty())
                    expect(firstCreator.thumbnailUrl).toNot(beEmpty())
                    expect(firstCreator.viewCount).to(beGreaterThan(0))
                    expect(firstCreator.socialLinkClickCount).to(beGreaterThanOrEqualTo(0))
                    expect(firstCreator.platformClickRatio).toNot(beEmpty())
                    expect(firstCreator.relatedTag).toNot(beEmpty())
                    expect(firstCreator.description).toNot(beEmpty())
                    expect(firstCreator.platform).toNot(beEmpty())
                    expect(firstCreator.isActive).to(beTrue())
                }
            }
            
            context("getCreatorsUpdatedAfter") {
                it("指定日時以降に更新されたクリエイターが取得できる") {
                    // Given
                    let cutoffDate = Date().addingTimeInterval(-86400) // 1日前
                    
                    // When
                    var result: [Creator]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getCreatorsUpdatedAfter(date: cutoffDate)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).toNot(beNil())
                    
                    // すべてのクリエイターの更新日時が指定日時以降であることを確認
                    for creator in result ?? [] {
                        expect(creator.updatedAt).to(beGreaterThan(cutoffDate))
                    }
                }
                
                it("現在時刻より後の日時を指定すると空の配列が返る") {
                    // Given
                    let futureDate = Date().addingTimeInterval(86400) // 1日後
                    
                    // When
                    var result: [Creator]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getCreatorsUpdatedAfter(date: futureDate)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).to(beEmpty())
                }
            }
            
            context("searchCreatorsByTags") {
                it("指定タグを持つクリエイターが取得できる") {
                    // Given
                    let tagIds = ["tag_007"] // ゲーム関連のタグ
                    
                    // When
                    var result: [Creator]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchCreatorsByTags(tagIds: tagIds)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).toNot(beNil())
                    expect(result?.count).to(beGreaterThan(0))
                    
                    // すべてのクリエイターが指定されたタグを含んでいることを確認
                    for creator in result ?? [] {
                        expect(creator.relatedTag).to(contain("tag_007"))
                    }
                }
                
                it("存在しないタグを指定すると空の配列が返る") {
                    // Given
                    let tagIds = ["tag_999"] // 存在しないタグ
                    
                    // When
                    var result: [Creator]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchCreatorsByTags(tagIds: tagIds)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).to(beEmpty())
                }
                
                it("複数タグを指定するといずれかを持つクリエイターが返る") {
                    // Given
                    let tagIds = ["tag_007", "tag_003"] // 複数タグ
                    
                    // When
                    var result: [Creator]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchCreatorsByTags(tagIds: tagIds)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).toNot(beNil())
                    expect(result?.count).to(beGreaterThan(0))
                    
                    // すべてのクリエイターがいずれかのタグを含んでいることを確認
                    for creator in result ?? [] {
                        let hasTag = creator.relatedTag.contains { tagIds.contains($0) }
                        expect(hasTag).to(beTrue())
                    }
                }
            }
            
            context("getPopularCreators") {
                it("人気順でクリエイターが取得できる") {
                    // Given
                    let limit = 3
                    
                    // When
                    var result: [Creator]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getPopularCreators(limit: limit)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).toNot(beNil())
                    expect(result?.count).to(equal(limit))
                    
                    // viewCountで降順にソートされていることを確認
                    guard let creators = result, creators.count >= 2 else {
                        fail("十分なクリエイターが取得できませんでした")
                        return
                    }
                    
                    for i in 0..<(creators.count - 1) {
                        expect(creators[i].viewCount).to(beGreaterThanOrEqualTo(creators[i + 1].viewCount))
                    }
                }
                
                it("limit 0を指定すると空の配列が返る") {
                    // Given
                    let limit = 0
                    
                    // When
                    var result: [Creator]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getPopularCreators(limit: limit)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).to(beEmpty())
                }
                
                it("総クリエイター数より大きなlimitを指定しても全クリエイターが返る") {
                    // Given
                    let limit = 1000
                    
                    // When
                    var result: [Creator]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getPopularCreators(limit: limit)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.count).to(equal(7)) // 総クリエイター数
                }
            }
            
            context("getCreatorById") {
                it("存在するIDで特定のクリエイターが取得できる") {
                    // Given
                    let creatorId = "creator_001"
                    
                    // When
                    var result: Creator?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getCreatorById(id: creatorId)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).toNot(beNil())
                    expect(result?.id).to(equal(creatorId))
                    expect(result?.name).to(equal("ゲーム実況者A"))
                }
                
                it("存在しないIDでcreatorNotFoundエラーが発生する") {
                    // Given
                    let creatorId = "creator_999"
                    
                    // When
                    var result: Creator?
                    var error: CreatorRepositoryError?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getCreatorById(id: creatorId)
                            } catch let err as CreatorRepositoryError {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(result).to(beNil())
                    expect(error).toNot(beNil())
                    
                    guard case .creatorNotFound = error else {
                        fail("creatorNotFoundエラーであるべき")
                        return
                    }
                    
                    expect(error?.errorDescription).to(equal("指定されたクリエイターが見つかりませんでした"))
                }
            }
            
            context("getSimilarCreators") {
                it("類似クリエイターが取得できる") {
                    // Given
                    let creatorId = "creator_001"
                    let limit = 2
                    
                    // When
                    var result: [Creator]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getSimilarCreators(creatorId: creatorId, limit: limit)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).toNot(beNil())
                    expect(result?.count).to(beLessThanOrEqualTo(limit))
                    
                    // 自分自身は含まれていないことを確認
                    let resultIds = result?.map { $0.id } ?? []
                    expect(resultIds).toNot(contain(creatorId))
                }
                
                it("存在しないクリエイターIDでcreatorNotFoundエラーが発生する") {
                    // Given
                    let creatorId = "creator_999"
                    let limit = 2
                    
                    // When
                    var result: [Creator]?
                    var error: CreatorRepositoryError?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getSimilarCreators(creatorId: creatorId, limit: limit)
                            } catch let err as CreatorRepositoryError {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(result).to(beNil())
                    expect(error).toNot(beNil())
                    
                    guard case .creatorNotFound = error else {
                        fail("creatorNotFoundエラーであるべき")
                        return
                    }
                }
                
                it("limit 0を指定すると空の配列が返る") {
                    // Given
                    let creatorId = "creator_001"
                    let limit = 0
                    
                    // When
                    var result: [Creator]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getSimilarCreators(creatorId: creatorId, limit: limit)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).to(beEmpty())
                }
            }
            
            context("searchByName") {
                it("名前による検索が成功する") {
                    // Given
                    let query = "ゲーム"
                    
                    // When
                    var result: CreatorSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    query: query,
                                    sortOrder: .popularity,
                                    offset: 0,
                                    limit: 10
                                )
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).toNot(beNil())
                    expect(result?.creators.count).to(beGreaterThan(0))
                    expect(result?.totalCount).to(beGreaterThan(0))
                    
                    // 検索結果にクエリが含まれることを確認
                    for creator in result?.creators ?? [] {
                        expect(creator.name.localizedCaseInsensitiveContains(query)).to(beTrue())
                    }
                }
                
                it("存在しない名前で検索すると空の結果が返る") {
                    // Given
                    let query = "存在しないクリエイター"
                    
                    // When
                    var result: CreatorSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    query: query,
                                    sortOrder: .popularity,
                                    offset: 0,
                                    limit: 10
                                )
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.creators).to(beEmpty())
                    expect(result?.totalCount).to(equal(0))
                    expect(result?.hasMore).to(beFalse())
                }
                
                it("人気順ソートが正しく動作する") {
                    // Given
                    let query = "ゲーム" // 検索してヒットするクエリ
                    
                    // When
                    var result: CreatorSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    query: query,
                                    sortOrder: .popularity,
                                    offset: 0,
                                    limit: 10
                                )
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    guard let creators = result?.creators, creators.count >= 2 else {
                        // 1件でもソートのテストはスキップ
                        return
                    }
                    
                    // viewCountで降順にソートされていることを確認
                    for i in 0..<(creators.count - 1) {
                        expect(creators[i].viewCount).to(beGreaterThanOrEqualTo(creators[i + 1].viewCount))
                    }
                }
                
                it("新着順ソートが正しく動作する") {
                    // Given
                    let query = "ー" // より多くのクリエイターにヒットするクエリ
                    
                    // When
                    var result: CreatorSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    query: query,
                                    sortOrder: .newest,
                                    offset: 0,
                                    limit: 10
                                )
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    guard let creators = result?.creators, creators.count >= 2 else {
                        // 2件未満の場合はソートテストをスキップ
                        return
                    }
                    
                    // createdAtで降順にソートされていることを確認
                    for i in 0..<(creators.count - 1) {
                        expect(creators[i].createdAt).to(beGreaterThanOrEqualTo(creators[i + 1].createdAt))
                    }
                }
                
                it("ページネーションが正しく動作する") {
                    // Given
                    let query = "ー" // 複数のクリエイターにヒットするクエリ
                    let limit = 2
                    let offset = 1
                    
                    // When
                    var result: CreatorSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    query: query,
                                    sortOrder: .popularity,
                                    offset: offset,
                                    limit: limit
                                )
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.creators.count).to(beLessThanOrEqualTo(limit))
                    expect(result?.totalCount).to(beGreaterThan(0))
                    
                    // hasMoreの確認
                    let totalCount = result?.totalCount ?? 0
                    let expectedHasMore = offset + limit < totalCount
                    expect(result?.hasMore).to(equal(expectedHasMore))
                }
                
                it("範囲外のoffsetを指定すると空の結果が返る") {
                    // Given
                    let query = "ゲーム" // 検索でヒットするクエリ
                    let limit = 10
                    let offset = 100 // 範囲外
                    
                    // When
                    var result: CreatorSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    query: query,
                                    sortOrder: .popularity,
                                    offset: offset,
                                    limit: limit
                                )
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.creators).to(beEmpty())
                    expect(result?.totalCount).to(beGreaterThan(0))
                    expect(result?.hasMore).to(beFalse())
                }
            }
            
            context("searchByTags") {
                it("AND検索が正しく動作する") {
                    // Given
                    let tagIds = ["tag_007", "tag_001"]
                    
                    // When
                    var result: CreatorSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByTags(
                                    tagIds: tagIds,
                                    searchMode: .all,
                                    sortOrder: .popularity,
                                    offset: 0,
                                    limit: 10
                                )
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).toNot(beNil())
                    
                    // すべてのクリエイターが指定されたすべてのタグを含んでいることを確認
                    for creator in result?.creators ?? [] {
                        for tagId in tagIds {
                            expect(creator.relatedTag).to(contain(tagId))
                        }
                    }
                }
                
                it("OR検索が正しく動作する") {
                    // Given
                    let tagIds = ["tag_007", "tag_003"]
                    
                    // When
                    var result: CreatorSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByTags(
                                    tagIds: tagIds,
                                    searchMode: .any,
                                    sortOrder: .popularity,
                                    offset: 0,
                                    limit: 10
                                )
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).toNot(beNil())
                    expect(result?.creators.count).to(beGreaterThan(0))
                    
                    // すべてのクリエイターがいずれかのタグを含んでいることを確認
                    for creator in result?.creators ?? [] {
                        let hasAnyTag = creator.relatedTag.contains { tagIds.contains($0) }
                        expect(hasAnyTag).to(beTrue())
                    }
                }
                
                it("タグ検索のページネーションが正しく動作する") {
                    // Given
                    let tagIds = ["tag_007"]
                    let limit = 1
                    let offset = 0
                    
                    // When
                    var result: CreatorSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByTags(
                                    tagIds: tagIds,
                                    searchMode: .any,
                                    sortOrder: .popularity,
                                    offset: offset,
                                    limit: limit
                                )
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.creators.count).to(equal(1))
                    expect(result?.totalCount).to(beGreaterThan(1))
                    expect(result?.hasMore).to(beTrue())
                }
            }
        }
    }
}