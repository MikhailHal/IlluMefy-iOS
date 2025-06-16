//
//  GetSearchHistoryUseCaseSpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Quick
import Nimble
import Foundation
@testable import IlluMefy

@MainActor
class GetSearchHistoryUseCaseSpec: QuickSpec {
    override class func spec() {
        describe("GetSearchHistoryUseCase") {
            var useCase: GetSearchHistoryUseCase!
            var mockRepository: MockGetSearchHistoryRepository!
            
            beforeEach {
                mockRepository = MockGetSearchHistoryRepository()
                useCase = GetSearchHistoryUseCase(repository: mockRepository)
            }
            
            afterEach {
                useCase = nil
                mockRepository = nil
            }
            
            context("正常ケース") {
                it("検索履歴の取得が成功する") {
                    // Given
                    let expectedHistory = ["ゲーム実況", "VTuber", "歌ってみた"]
                    mockRepository.getSearchHistoryResult = .success(expectedHistory)
                    
                    // When
                    var result: [String]?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute()
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).to(equal(expectedHistory))
                    expect(mockRepository.lastGetSearchHistoryLimit).to(equal(10)) // デフォルト値
                    expect(mockRepository.getSearchHistoryCallCount).to(equal(1))
                }
                
                it("カスタムlimitでの検索履歴取得が成功する") {
                    // Given
                    let limit = 5
                    let expectedHistory = ["最新の検索1", "最新の検索2", "最新の検索3", "最新の検索4", "最新の検索5"]
                    mockRepository.getSearchHistoryResult = .success(expectedHistory)
                    
                    // When
                    var result: [String]?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(limit: limit)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).to(equal(expectedHistory))
                    expect(mockRepository.lastGetSearchHistoryLimit).to(equal(limit))
                }
                
                it("空の検索履歴でも正常に処理される") {
                    // Given
                    mockRepository.getSearchHistoryResult = .success([])
                    
                    // When
                    var result: [String]?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute()
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).to(beEmpty())
                    expect(mockRepository.getSearchHistoryCallCount).to(equal(1))
                }
                
                it("日本語の検索履歴が正常に取得される") {
                    // Given
                    let japaneseHistory = [
                        "FPSゲーム配信者",
                        "料理系YouTuber",
                        "ASMR",
                        "歌い手グループ",
                        "実況プレイヤー"
                    ]
                    mockRepository.getSearchHistoryResult = .success(japaneseHistory)
                    
                    // When
                    var result: [String]?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(limit: 5)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).to(equal(japaneseHistory))
                    expect(result?.count).to(equal(5))
                }
                
                it("特殊文字を含む検索履歴が正常に取得される") {
                    // Given
                    let specialCharHistory = [
                        "VTuber💫歌ってみた🎵",
                        "ゲーム実況@最新",
                        "配信者_ランキング",
                        "料理系#人気",
                        "ASMR&リラックス"
                    ]
                    mockRepository.getSearchHistoryResult = .success(specialCharHistory)
                    
                    // When
                    var result: [String]?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute()
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).to(equal(specialCharHistory))
                }
                
                it("英語の検索履歴が正常に取得される") {
                    // Given
                    let englishHistory = [
                        "apex legends streamer",
                        "minecraft creator",
                        "music cover artist",
                        "gaming influencer",
                        "tech reviewer"
                    ]
                    mockRepository.getSearchHistoryResult = .success(englishHistory)
                    
                    // When
                    var result: [String]?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute()
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).to(equal(englishHistory))
                }
                
                it("limit 0でも正常に処理される") {
                    // Given
                    mockRepository.getSearchHistoryResult = .success([])
                    
                    // When
                    var result: [String]?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(limit: 0)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).to(beEmpty())
                    expect(mockRepository.lastGetSearchHistoryLimit).to(equal(0))
                }
                
                it("大きなlimit値でも正常に処理される") {
                    // Given
                    let limit = 1000
                    let largeHistory = (1...100).map { "検索履歴\($0)" }
                    mockRepository.getSearchHistoryResult = .success(largeHistory)
                    
                    // When
                    var result: [String]?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(limit: limit)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.count).to(equal(100))
                    expect(mockRepository.lastGetSearchHistoryLimit).to(equal(limit))
                }
            }
            
            context("エラーケース") {
                it("リポジトリでエラーが発生した場合はエラーがそのまま投げられる") {
                    // Given
                    let testError = TestError.testError
                    mockRepository.getSearchHistoryResult = .failure(testError)
                    
                    // When
                    var result: [String]?
                    var thrownError: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute()
                            } catch let err {
                                thrownError = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(result).to(beNil())
                    expect(thrownError).toNot(beNil())
                    expect(thrownError as? TestError).to(equal(.testError))
                    expect(mockRepository.getSearchHistoryCallCount).to(equal(1))
                }
                
                it("ネットワークエラーが発生した場合") {
                    // Given
                    struct NetworkError: Error, LocalizedError {
                        var errorDescription: String? { "ネットワークエラー" }
                    }
                    let networkError = NetworkError()
                    mockRepository.getSearchHistoryResult = .failure(networkError)
                    
                    // When
                    var result: [String]?
                    var thrownError: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(limit: 5)
                            } catch let err {
                                thrownError = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(result).to(beNil())
                    expect(thrownError).toNot(beNil())
                    expect(thrownError?.localizedDescription).to(equal("ネットワークエラー"))
                    expect(mockRepository.lastGetSearchHistoryLimit).to(equal(5))
                }
                
                it("データベースエラーが発生した場合") {
                    // Given
                    struct DatabaseError: Error, LocalizedError {
                        var errorDescription: String? { "データベースアクセスエラー" }
                    }
                    let dbError = DatabaseError()
                    mockRepository.getSearchHistoryResult = .failure(dbError)
                    
                    // When
                    var result: [String]?
                    var thrownError: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute()
                            } catch let err {
                                thrownError = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(result).to(beNil())
                    expect(thrownError?.localizedDescription).to(equal("データベースアクセスエラー"))
                }
            }
            
            context("複数回の実行") {
                it("同じlimitで複数回実行できる") {
                    // Given
                    let history = ["ゲーム", "VTuber", "料理"]
                    mockRepository.getSearchHistoryResult = .success(history)
                    
                    // When
                    var result1: [String]?
                    var result2: [String]?
                    var errors: [Error?] = []
                    
                    waitUntil { done in
                        Task {
                            do {
                                result1 = try await useCase.execute(limit: 3)
                                errors.append(nil)
                            } catch let err {
                                errors.append(err)
                            }
                            
                            do {
                                result2 = try await useCase.execute(limit: 3)
                                errors.append(nil)
                            } catch let err {
                                errors.append(err)
                            }
                            
                            done()
                        }
                    }
                    
                    // Then
                    expect(errors.compactMap { $0 }).to(beEmpty())
                    expect(result1).to(equal(history))
                    expect(result2).to(equal(history))
                    expect(mockRepository.getSearchHistoryCallCount).to(equal(2))
                }
                
                it("異なるlimitで複数回実行できる") {
                    // Given
                    let fullHistory = ["検索1", "検索2", "検索3", "検索4", "検索5"]
                    let limitedHistory = ["検索1", "検索2", "検索3"]
                    
                    // When
                    var result1: [String]?
                    var result2: [String]?
                    var errors: [Error?] = []
                    
                    waitUntil { done in
                        Task {
                            // 最初はlimit 5で実行
                            mockRepository.getSearchHistoryResult = .success(fullHistory)
                            do {
                                result1 = try await useCase.execute(limit: 5)
                                errors.append(nil)
                            } catch let err {
                                errors.append(err)
                            }
                            
                            // 次はlimit 3で実行
                            mockRepository.getSearchHistoryResult = .success(limitedHistory)
                            do {
                                result2 = try await useCase.execute(limit: 3)
                                errors.append(nil)
                            } catch let err {
                                errors.append(err)
                            }
                            
                            done()
                        }
                    }
                    
                    // Then
                    expect(errors.compactMap { $0 }).to(beEmpty())
                    expect(result1?.count).to(equal(5))
                    expect(result2?.count).to(equal(3))
                    expect(mockRepository.getSearchHistoryCallCount).to(equal(2))
                }
            }
            
            context("デフォルト値の確認") {
                it("execute()をパラメータなしで呼び出すとデフォルトlimit 10が使用される") {
                    // Given
                    mockRepository.getSearchHistoryResult = .success([])
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                _ = try await useCase.execute()
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(mockRepository.lastGetSearchHistoryLimit).to(equal(10))
                }
            }
        }
    }
}