//
//  SearchHistoryRepositorySpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Quick
import Nimble
import Foundation
@testable import IlluMefy

@MainActor
class SearchHistoryRepositorySpec: QuickSpec {
    override class func spec() {
        describe("SearchHistoryRepository") {
            var repository: SearchHistoryRepository!
            var mockUserDefaults: UserDefaults!
            let testSuiteName = "SearchHistoryRepositoryTest"
            
            beforeEach {
                // テスト用のUserDefaultsを作成
                mockUserDefaults = UserDefaults(suiteName: testSuiteName)
                mockUserDefaults?.removePersistentDomain(forName: testSuiteName)
                repository = SearchHistoryRepository(userDefaults: mockUserDefaults)
            }
            
            afterEach {
                // テスト後にクリーンアップ
                mockUserDefaults?.removePersistentDomain(forName: testSuiteName)
                mockUserDefaults = nil
                repository = nil
            }
            
            context("saveSearchHistory") {
                it("検索履歴の保存が成功する") {
                    // Given
                    let query = "ゲーム実況"
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await repository.saveSearchHistory(query: query)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    
                    // 保存された履歴を確認
                    var savedHistory: [String]?
                    waitUntil { done in
                        Task {
                            do {
                                savedHistory = try await repository.getSearchHistory(limit: 10)
                            } catch {
                                // エラーは無視
                            }
                            done()
                        }
                    }
                    
                    expect(savedHistory).to(contain(query))
                    expect(savedHistory?.first).to(equal(query))
                }
                
                it("同じクエリを複数回保存すると最新のものが先頭に来る") {
                    // Given
                    let query = "VTuber"
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await repository.saveSearchHistory(query: "他の検索")
                                try await repository.saveSearchHistory(query: query)
                                try await repository.saveSearchHistory(query: "さらに他の検索")
                                try await repository.saveSearchHistory(query: query) // 再度保存
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    
                    var savedHistory: [String]?
                    waitUntil { done in
                        Task {
                            do {
                                savedHistory = try await repository.getSearchHistory(limit: 10)
                            } catch {
                                // エラーは無視
                            }
                            done()
                        }
                    }
                    
                    expect(savedHistory?.first).to(equal(query))
                    expect(savedHistory?.filter { $0 == query }.count).to(equal(1)) // 重複なし
                }
                
                it("空文字列や空白のみのクエリは保存されない") {
                    // Given
                    let emptyQuery = ""
                    let whitespaceQuery = "   "
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await repository.saveSearchHistory(query: emptyQuery)
                                try await repository.saveSearchHistory(query: whitespaceQuery)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    
                    var savedHistory: [String]?
                    waitUntil { done in
                        Task {
                            do {
                                savedHistory = try await repository.getSearchHistory(limit: 10)
                            } catch {
                                // エラーは無視
                            }
                            done()
                        }
                    }
                    
                    expect(savedHistory).to(beEmpty())
                }
                
                it("前後の空白が除去されて保存される") {
                    // Given
                    let queryWithSpaces = "  ゲーム配信  "
                    let expectedQuery = "ゲーム配信"
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await repository.saveSearchHistory(query: queryWithSpaces)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    
                    var savedHistory: [String]?
                    waitUntil { done in
                        Task {
                            do {
                                savedHistory = try await repository.getSearchHistory(limit: 10)
                            } catch {
                                // エラーは無視
                            }
                            done()
                        }
                    }
                    
                    expect(savedHistory?.first).to(equal(expectedQuery))
                }
                
                it("上限を超えた場合は古い履歴が削除される") {
                    // Given (maxHistoryCount = 10)
                    let queries = (1...12).map { "クエリ\($0)" }
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                for query in queries {
                                    try await repository.saveSearchHistory(query: query)
                                }
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    
                    var savedHistory: [String]?
                    waitUntil { done in
                        Task {
                            do {
                                savedHistory = try await repository.getSearchHistory(limit: 15)
                            } catch {
                                // エラーは無視
                            }
                            done()
                        }
                    }
                    
                    expect(savedHistory?.count).to(equal(10)) // 上限
                    expect(savedHistory?.first).to(equal("クエリ12")) // 最新
                    expect(savedHistory?.last).to(equal("クエリ3")) // 古いものは削除
                    expect(savedHistory).toNot(contain("クエリ1")) // 最古は削除
                    expect(savedHistory).toNot(contain("クエリ2")) // 2番目に古いのも削除
                }
                
                it("日本語のクエリが正しく保存される") {
                    // Given
                    let japaneseQueries = [
                        "ゲーム実況",
                        "VTuber歌ってみた",
                        "料理配信",
                        "ASMR癒し"
                    ]
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                for query in japaneseQueries {
                                    try await repository.saveSearchHistory(query: query)
                                }
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    
                    var savedHistory: [String]?
                    waitUntil { done in
                        Task {
                            do {
                                savedHistory = try await repository.getSearchHistory(limit: 10)
                            } catch {
                                // エラーは無視
                            }
                            done()
                        }
                    }
                    
                    for query in japaneseQueries {
                        expect(savedHistory).to(contain(query))
                    }
                }
            }
            
            context("getSearchHistory") {
                it("空の履歴では空の配列が返される") {
                    // When
                    var result: [String]?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await repository.getSearchHistory(limit: 10)
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
                
                it("指定した件数まで履歴が取得される") {
                    // Given
                    let queries = ["クエリ1", "クエリ2", "クエリ3", "クエリ4", "クエリ5"]
                    let limit = 3
                    
                    waitUntil { done in
                        Task {
                            do {
                                for query in queries {
                                    try await repository.saveSearchHistory(query: query)
                                }
                            } catch {
                                // セットアップエラーは無視
                            }
                            done()
                        }
                    }
                    
                    // When
                    var result: [String]?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await repository.getSearchHistory(limit: limit)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.count).to(equal(limit))
                    expect(result?.first).to(equal("クエリ5")) // 最新
                }
                
                it("limit 0を指定すると空の配列が返される") {
                    // Given
                    waitUntil { done in
                        Task {
                            do {
                                try await repository.saveSearchHistory(query: "テストクエリ")
                            } catch {
                                // セットアップエラーは無視
                            }
                            done()
                        }
                    }
                    
                    // When
                    var result: [String]?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await repository.getSearchHistory(limit: 0)
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
                
                it("履歴数より大きなlimitを指定しても全履歴が返される") {
                    // Given
                    let queries = ["クエリ1", "クエリ2"]
                    
                    waitUntil { done in
                        Task {
                            do {
                                for query in queries {
                                    try await repository.saveSearchHistory(query: query)
                                }
                            } catch {
                                // セットアップエラーは無視
                            }
                            done()
                        }
                    }
                    
                    // When
                    var result: [String]?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await repository.getSearchHistory(limit: 100)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.count).to(equal(2))
                }
            }
            
            context("deleteSearchHistory") {
                it("指定したクエリが削除される") {
                    // Given
                    let queries = ["削除対象", "残す1", "残す2"]
                    let targetQuery = "削除対象"
                    
                    waitUntil { done in
                        Task {
                            do {
                                for query in queries {
                                    try await repository.saveSearchHistory(query: query)
                                }
                            } catch {
                                // セットアップエラーは無視
                            }
                            done()
                        }
                    }
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await repository.deleteSearchHistory(query: targetQuery)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    
                    var remainingHistory: [String]?
                    waitUntil { done in
                        Task {
                            do {
                                remainingHistory = try await repository.getSearchHistory(limit: 10)
                            } catch {
                                // エラーは無視
                            }
                            done()
                        }
                    }
                    
                    expect(remainingHistory).toNot(contain(targetQuery))
                    expect(remainingHistory).to(contain("残す1"))
                    expect(remainingHistory).to(contain("残す2"))
                }
                
                it("存在しないクエリを削除してもエラーにならない") {
                    // Given
                    waitUntil { done in
                        Task {
                            do {
                                try await repository.saveSearchHistory(query: "存在するクエリ")
                            } catch {
                                // セットアップエラーは無視
                            }
                            done()
                        }
                    }
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await repository.deleteSearchHistory(query: "存在しないクエリ")
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    
                    var remainingHistory: [String]?
                    waitUntil { done in
                        Task {
                            do {
                                remainingHistory = try await repository.getSearchHistory(limit: 10)
                            } catch {
                                // エラーは無視
                            }
                            done()
                        }
                    }
                    
                    expect(remainingHistory).to(contain("存在するクエリ"))
                }
                
                it("空の履歴から削除してもエラーにならない") {
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await repository.deleteSearchHistory(query: "何かのクエリ")
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                }
            }
            
            context("clearAllSearchHistory") {
                it("全ての検索履歴が削除される") {
                    // Given
                    let queries = ["クエリ1", "クエリ2", "クエリ3"]
                    
                    waitUntil { done in
                        Task {
                            do {
                                for query in queries {
                                    try await repository.saveSearchHistory(query: query)
                                }
                            } catch {
                                // セットアップエラーは無視
                            }
                            done()
                        }
                    }
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await repository.clearAllSearchHistory()
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    
                    var remainingHistory: [String]?
                    waitUntil { done in
                        Task {
                            do {
                                remainingHistory = try await repository.getSearchHistory(limit: 10)
                            } catch {
                                // エラーは無視
                            }
                            done()
                        }
                    }
                    
                    expect(remainingHistory).to(beEmpty())
                }
                
                it("空の履歴をクリアしてもエラーにならない") {
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await repository.clearAllSearchHistory()
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                }
            }
            
            context("データの永続化") {
                it("リポジトリを再作成しても履歴が保持される") {
                    // Given
                    let query = "永続化テスト"
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await repository.saveSearchHistory(query: query)
                            } catch {
                                // セットアップエラーは無視
                            }
                            done()
                        }
                    }
                    
                    // When: 新しいリポジトリインスタンスを作成
                    let newRepository = SearchHistoryRepository(userDefaults: mockUserDefaults)
                    
                    var result: [String]?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await newRepository.getSearchHistory(limit: 10)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).to(contain(query))
                }
            }
        }
    }
}