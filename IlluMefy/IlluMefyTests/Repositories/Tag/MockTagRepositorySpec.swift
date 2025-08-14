//
//  MockTagRepositorySpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Quick
import Nimble
import Foundation
@testable import IlluMefy

@MainActor
class MockTagRepositorySpec: QuickSpec {
    override class func spec() {
        describe("MockTagRepository") {
            var repository: MockTagRepository!
            
            beforeEach {
                repository = MockTagRepository()
            }
            
            afterEach {
                repository = nil
            }
            
            context("searchByName") {
                it("AND検索が正しく動作する") {
                    // Given
                    let andQuery = "ゲーム"
                    let orQuery = ""
                    
                    // When
                    var result: TagSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    andQuery: andQuery,
                                    orQuery: orQuery,
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
                    expect(result?.tags.count).to(beGreaterThan(0))
                    
                    // すべてのタグがクエリに含まれることを確認
                    for tag in result?.tags ?? [] {
                        let matches = tag.displayName.localizedCaseInsensitiveContains(andQuery) ||
                                     tag.tagName.localizedCaseInsensitiveContains(andQuery)
                        expect(matches).to(beTrue())
                    }
                }
                
                it("OR検索が正しく動作する") {
                    // Given
                    let andQuery = ""
                    let orQuery = "ゲーム 音楽"
                    
                    // When
                    var result: TagSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    andQuery: andQuery,
                                    orQuery: orQuery,
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
                    expect(result?.tags.count).to(beGreaterThan(0))
                    
                    // すべてのタグがいずれかのキーワードを含むことを確認
                    for tag in result?.tags ?? [] {
                        let gameMatch = tag.displayName.localizedCaseInsensitiveContains("ゲーム") ||
                                       tag.tagName.localizedCaseInsensitiveContains("ゲーム")
                        let musicMatch = tag.displayName.localizedCaseInsensitiveContains("音楽") ||
                                        tag.tagName.localizedCaseInsensitiveContains("音楽")
                        expect(gameMatch || musicMatch).to(beTrue())
                    }
                }
                
                it("AND検索とOR検索の組み合わせが正しく動作する") {
                    // Given
                    let andQuery = "ゲーム"
                    let orQuery = "FPS RPG"
                    
                    // When
                    var result: TagSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    andQuery: andQuery,
                                    orQuery: orQuery,
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
                    
                    // AND条件とOR条件の両方を満たすタグのみが返されることを確認
                    for tag in result?.tags ?? [] {
                        let andMatch = tag.displayName.localizedCaseInsensitiveContains("ゲーム") ||
                                      tag.tagName.localizedCaseInsensitiveContains("ゲーム")
                        let orMatch = tag.displayName.localizedCaseInsensitiveContains("FPS") ||
                                     tag.tagName.localizedCaseInsensitiveContains("FPS") ||
                                     tag.displayName.localizedCaseInsensitiveContains("RPG") ||
                                     tag.tagName.localizedCaseInsensitiveContains("RPG")
                        expect(andMatch && orMatch).to(beTrue())
                    }
                }
                
                it("空のクエリで全タグが人気順で返される") {
                    // Given
                    let andQuery = ""
                    let orQuery = ""
                    
                    // When
                    var result: TagSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    andQuery: andQuery,
                                    orQuery: orQuery,
                                    offset: 0,
                                    limit: 20
                                )
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.tags.count).to(equal(14)) // 全14タグ
                    
                    // クリック数で降順にソートされていることを確認
                    guard let tags = result?.tags, tags.count >= 2 else {
                        fail("十分なタグが取得できませんでした")
                        return
                    }
                    
                    for i in 0..<(tags.count - 1) {
                        expect(tags[i].clickedCount).to(beGreaterThanOrEqualTo(tags[i + 1].clickedCount))
                    }
                }
                
                it("英語のタグ名でも検索できる") {
                    // Given
                    let andQuery = "game"
                    let orQuery = ""
                    
                    // When
                    var result: TagSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    andQuery: andQuery,
                                    orQuery: orQuery,
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
                    expect(result?.tags.count).to(beGreaterThan(0))
                    
                    // "game"タグ名を持つタグが含まれることを確認
                    let hasGameTag = result?.tags.contains { $0.tagName == "game" } ?? false
                    expect(hasGameTag).to(beTrue())
                }
                
                it("存在しないキーワードで検索すると空の結果が返る") {
                    // Given
                    let andQuery = "存在しないキーワード"
                    let orQuery = ""
                    
                    // When
                    var result: TagSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    andQuery: andQuery,
                                    orQuery: orQuery,
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
                    expect(result?.tags).to(beEmpty())
                    expect(result?.totalCount).to(equal(0))
                    expect(result?.hasMore).to(beFalse())
                }
                
                it("ページネーションが正しく動作する") {
                    // Given
                    let andQuery = ""
                    let orQuery = ""
                    let limit = 5
                    let offset = 3
                    
                    // When
                    var result: TagSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    andQuery: andQuery,
                                    orQuery: orQuery,
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
                    expect(result?.tags.count).to(equal(limit))
                    expect(result?.totalCount).to(equal(14))
                    
                    // hasMoreの確認
                    let expectedHasMore = offset + limit < 14
                    expect(result?.hasMore).to(equal(expectedHasMore))
                }
                
                it("範囲外のoffsetを指定すると空の結果が返る") {
                    // Given
                    let andQuery = ""
                    let orQuery = ""
                    let limit = 10
                    let offset = 100 // 範囲外
                    
                    // When
                    var result: TagSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    andQuery: andQuery,
                                    orQuery: orQuery,
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
                    expect(result?.tags).to(beEmpty())
                    expect(result?.totalCount).to(equal(14))
                    expect(result?.hasMore).to(beFalse())
                }
                
                it("複数キーワードのAND検索が正しく動作する") {
                    // Given
                    let andQuery = "ゲーム FPS" // 両方含む必要がある
                    let orQuery = ""
                    
                    // When
                    var result: TagSearchResult?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.searchByName(
                                    andQuery: andQuery,
                                    orQuery: orQuery,
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
                    
                    // 結果のタグがすべてのキーワードを含むことを確認
                    for tag in result?.tags ?? [] {
                        let gameMatch = tag.displayName.localizedCaseInsensitiveContains("ゲーム") ||
                                       tag.tagName.localizedCaseInsensitiveContains("ゲーム")
                        let fpsMatch = tag.displayName.localizedCaseInsensitiveContains("FPS") ||
                                      tag.tagName.localizedCaseInsensitiveContains("FPS")
                        expect(gameMatch && fpsMatch).to(beTrue())
                    }
                }
            }
            
            context("getAllTags") {
                it("全タグが人気順で取得できる") {
                    // When
                    var result: [Tag]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getAllTags()
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.count).to(equal(14))
                    
                    // クリック数で降順にソートされていることを確認
                    guard let tags = result, tags.count >= 2 else {
                        fail("十分なタグが取得できませんでした")
                        return
                    }
                    
                    for i in 0..<(tags.count - 1) {
                        expect(tags[i].clickedCount).to(beGreaterThanOrEqualTo(tags[i + 1].clickedCount))
                    }
                }
                
                it("すべてのタグに必須プロパティが含まれる") {
                    // When
                    var result: [Tag]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getAllTags()
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    guard let tags = result, let firstTag = tags.first else {
                        fail("タグが取得できませんでした")
                        return
                    }
                    
                    expect(firstTag.id).toNot(beEmpty())
                    expect(firstTag.displayName).toNot(beEmpty())
                    expect(firstTag.tagName).toNot(beEmpty())
                    expect(firstTag.clickedCount).to(beGreaterThanOrEqualTo(0))
                    expect(firstTag.createdAt).toNot(beNil())
                    expect(firstTag.updatedAt).toNot(beNil())
                }
                
                it("すべてのタグが適切に設定されている") {
                    // When
                    var result: [Tag]?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getAllTags()
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    guard let tags = result else {
                        fail("タグが取得できませんでした")
                        return
                    }
                    
                    // すべてのタグが適切に設定されていることを確認
                    for tag in tags {
                        expect(tag.id).toNot(beEmpty())
                        expect(tag.displayName).toNot(beEmpty())
                        expect(tag.tagName).toNot(beEmpty())
                        expect(tag.clickedCount).to(beGreaterThanOrEqualTo(0))
                    }
                }
            }
            
            context("getPopularTags") {
                it("指定した件数の人気タグが取得できる") {
                    // Given
                    let limit = 5
                    
                    // When
                    var result: GetPopularTagsResponse?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getPopularTags(limit: limit)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.data.count).to(equal(limit))
                    
                    // クリック数で降順にソートされていることを確認
                    guard let tags = result?.data, tags.count >= 2 else {
                        fail("十分なタグが取得できませんでした")
                        return
                    }
                    
                    for i in 0..<(tags.count - 1) {
                        expect(tags[i].viewCount).to(beGreaterThanOrEqualTo(tags[i + 1].viewCount))
                    }
                }
                
                it("limit 0を指定すると空の配列が返る") {
                    // Given
                    let limit = 0
                    
                    // When
                    var result: GetPopularTagsResponse?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getPopularTags(limit: limit)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.data).to(beEmpty())
                }
                
                it("総タグ数より大きなlimitを指定しても全タグが返る") {
                    // Given
                    let limit = 1000
                    
                    // When
                    var result: GetPopularTagsResponse?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getPopularTags(limit: limit)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.data.count).to(equal(14)) // 総タグ数
                }
                
                it("最も人気のあるタグが最初に返される") {
                    // Given
                    let limit = 3
                    
                    // When
                    var result: GetPopularTagsResponse?
                    var error: Error?
                    
                    waitUntil(timeout: .seconds(5)) { done in
                        Task {
                            do {
                                result = try await repository.getPopularTags(limit: limit)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    guard let tags = result?.data, tags.count >= 1 else {
                        fail("タグが取得できませんでした")
                        return
                    }
                    
                    // 最初のタグが最もクリック数が多いことを確認
                    expect(tags[0].name).to(equal("ゲーム")) // クリック数1500で最多
                    expect(tags[0].viewCount).to(equal(1500))
                }
            }
        }
    }
}