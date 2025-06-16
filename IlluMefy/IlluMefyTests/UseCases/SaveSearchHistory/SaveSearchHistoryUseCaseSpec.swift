//
//  SaveSearchHistoryUseCaseSpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Quick
import Nimble
import Foundation
@testable import IlluMefy

@MainActor
class SaveSearchHistoryUseCaseSpec: QuickSpec {
    override class func spec() {
        describe("SaveSearchHistoryUseCase") {
            var useCase: SaveSearchHistoryUseCase!
            var mockRepository: MockSaveSearchHistoryRepository!
            
            beforeEach {
                mockRepository = MockSaveSearchHistoryRepository()
                useCase = SaveSearchHistoryUseCase(repository: mockRepository)
            }
            
            afterEach {
                useCase = nil
                mockRepository = nil
            }
            
            context("正常ケース") {
                it("検索履歴の保存が成功する") {
                    // Given
                    let query = "ゲーム実況"
                    mockRepository.saveSearchHistoryResult = .success(())
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await useCase.execute(query: query)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(mockRepository.lastSaveSearchHistoryQuery).to(equal(query))
                    expect(mockRepository.saveSearchHistoryCallCount).to(equal(1))
                }
                
                it("空文字の検索履歴も保存される") {
                    // Given
                    let query = ""
                    mockRepository.saveSearchHistoryResult = .success(())
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await useCase.execute(query: query)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(mockRepository.lastSaveSearchHistoryQuery).to(equal(""))
                    expect(mockRepository.saveSearchHistoryCallCount).to(equal(1))
                }
                
                it("日本語の検索履歴が保存される") {
                    // Given
                    let query = "FPSゲーム配信者"
                    mockRepository.saveSearchHistoryResult = .success(())
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await useCase.execute(query: query)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(mockRepository.lastSaveSearchHistoryQuery).to(equal(query))
                }
                
                it("英語の検索履歴が保存される") {
                    // Given
                    let query = "apex legends streamer"
                    mockRepository.saveSearchHistoryResult = .success(())
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await useCase.execute(query: query)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(mockRepository.lastSaveSearchHistoryQuery).to(equal(query))
                }
                
                it("特殊文字を含む検索履歴が保存される") {
                    // Given
                    let query = "VTuber💫歌ってみた🎵"
                    mockRepository.saveSearchHistoryResult = .success(())
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await useCase.execute(query: query)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(mockRepository.lastSaveSearchHistoryQuery).to(equal(query))
                }
                
                it("長い検索クエリも保存される") {
                    // Given
                    let query = "これは非常に長い検索クエリの例でありプログラムのテストのために作成された文字列であり実際のユーザーが入力する可能性は低いですが動作確認として使用します"
                    mockRepository.saveSearchHistoryResult = .success(())
                    
                    // When
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await useCase.execute(query: query)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(mockRepository.lastSaveSearchHistoryQuery).to(equal(query))
                }
            }
            
            context("エラーケース") {
                it("リポジトリでエラーが発生した場合はエラーがそのまま投げられる") {
                    // Given
                    let query = "ゲーム"
                    let testError = TestError.testError
                    mockRepository.saveSearchHistoryResult = .failure(testError)
                    
                    // When
                    var thrownError: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await useCase.execute(query: query)
                            } catch let err {
                                thrownError = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(thrownError).toNot(beNil())
                    expect(thrownError as? TestError).to(equal(.testError))
                    expect(mockRepository.lastSaveSearchHistoryQuery).to(equal(query))
                    expect(mockRepository.saveSearchHistoryCallCount).to(equal(1))
                }
                
                it("ネットワークエラーが発生した場合") {
                    // Given
                    let query = "VTuber"
                    struct NetworkError: Error, LocalizedError {
                        var errorDescription: String? { "ネットワークエラー" }
                    }
                    let networkError = NetworkError()
                    mockRepository.saveSearchHistoryResult = .failure(networkError)
                    
                    // When
                    var thrownError: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await useCase.execute(query: query)
                            } catch let err {
                                thrownError = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(thrownError).toNot(beNil())
                    expect(thrownError?.localizedDescription).to(equal("ネットワークエラー"))
                    expect(mockRepository.lastSaveSearchHistoryQuery).to(equal(query))
                }
            }
            
            context("複数回の実行") {
                it("同じクエリを複数回保存できる") {
                    // Given
                    let query = "人気ゲーム"
                    mockRepository.saveSearchHistoryResult = .success(())
                    
                    // When
                    var error1: Error?
                    var error2: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await useCase.execute(query: query)
                            } catch let err {
                                error1 = err
                            }
                            
                            do {
                                try await useCase.execute(query: query)
                            } catch let err {
                                error2 = err
                            }
                            
                            done()
                        }
                    }
                    
                    // Then
                    expect(error1).to(beNil())
                    expect(error2).to(beNil())
                    expect(mockRepository.saveSearchHistoryCallCount).to(equal(2))
                    expect(mockRepository.lastSaveSearchHistoryQuery).to(equal(query))
                }
                
                it("異なるクエリを複数回保存できる") {
                    // Given
                    let query1 = "ゲーム"
                    let query2 = "VTuber"
                    let query3 = "料理"
                    mockRepository.saveSearchHistoryResult = .success(())
                    
                    // When
                    var errors: [Error?] = []
                    
                    waitUntil { done in
                        Task {
                            do {
                                try await useCase.execute(query: query1)
                                errors.append(nil)
                            } catch let err {
                                errors.append(err)
                            }
                            
                            do {
                                try await useCase.execute(query: query2)
                                errors.append(nil)
                            } catch let err {
                                errors.append(err)
                            }
                            
                            do {
                                try await useCase.execute(query: query3)
                                errors.append(nil)
                            } catch let err {
                                errors.append(err)
                            }
                            
                            done()
                        }
                    }
                    
                    // Then
                    expect(errors.compactMap { $0 }).to(beEmpty())
                    expect(mockRepository.saveSearchHistoryCallCount).to(equal(3))
                    expect(mockRepository.lastSaveSearchHistoryQuery).to(equal(query3))
                }
            }
        }
    }
}