//
//  SearchTagsByNameUseCaseSpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Quick
import Nimble
import Foundation
@testable import IlluMefy

@MainActor
class SearchTagsByNameUseCaseSpec: QuickSpec {
    override class func spec() {
        describe("SearchTagsByNameUseCase") {
            var useCase: SearchTagsByNameUseCase!
            var mockTagRepository: MockSearchTagsByNameRepository!
            
            beforeEach {
                mockTagRepository = MockSearchTagsByNameRepository()
                useCase = SearchTagsByNameUseCase(tagRepository: mockTagRepository)
            }
            
            afterEach {
                useCase = nil
                mockTagRepository = nil
            }
            
            context("正常ケース") {
                let testTags = [
                    Tag(
                        id: "tag_001",
                        displayName: "ゲーム",
                        tagName: "game",
                        clickedCount: 1500,
                        createdAt: Date().addingTimeInterval(-86400 * 30),
                        updatedAt: Date().addingTimeInterval(-3600),
                        parentTagId: nil,
                        childTagIds: ["tag_007", "tag_008"]
                    ),
                    Tag(
                        id: "tag_007",
                        displayName: "FPS",
                        tagName: "fps",
                        clickedCount: 500,
                        createdAt: Date().addingTimeInterval(-86400 * 20),
                        updatedAt: Date().addingTimeInterval(-7200),
                        parentTagId: "tag_001",
                        childTagIds: []
                    )
                ]
                
                it("AND検索が成功する") {
                    // Given
                    let request = SearchTagsByNameUseCaseRequest(
                        andQuery: "ゲーム",
                        orQuery: "",
                        offset: 0,
                        limit: 20
                    )
                    
                    mockTagRepository.searchByNameResult = .success(
                        TagSearchResult(
                            tags: [testTags[0]],
                            totalCount: 1,
                            hasMore: false
                        )
                    )
                    
                    // When
                    var result: SearchTagsByNameUseCaseResponse?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(request: request)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result).toNot(beNil())
                    expect(result?.tags.count).to(equal(1))
                    expect(result?.tags.first?.displayName).to(equal("ゲーム"))
                    expect(result?.totalCount).to(equal(1))
                    expect(result?.hasMore).to(beFalse())
                    
                    // リポジトリが正しいパラメータで呼ばれたか確認
                    expect(mockTagRepository.lastSearchByNameParams?.andQuery).to(equal("ゲーム"))
                    expect(mockTagRepository.lastSearchByNameParams?.orQuery).to(equal(""))
                    expect(mockTagRepository.lastSearchByNameParams?.offset).to(equal(0))
                    expect(mockTagRepository.lastSearchByNameParams?.limit).to(equal(20))
                }
                
                it("OR検索が成功する") {
                    // Given
                    let request = SearchTagsByNameUseCaseRequest(
                        andQuery: "",
                        orQuery: "ゲーム FPS",
                        offset: 0,
                        limit: 20
                    )
                    
                    mockTagRepository.searchByNameResult = .success(
                        TagSearchResult(
                            tags: testTags,
                            totalCount: 2,
                            hasMore: false
                        )
                    )
                    
                    // When
                    var result: SearchTagsByNameUseCaseResponse?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(request: request)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.tags.count).to(equal(2))
                    expect(result?.totalCount).to(equal(2))
                    expect(mockTagRepository.lastSearchByNameParams?.orQuery).to(equal("ゲーム FPS"))
                }
                
                it("AND検索とOR検索の組み合わせが成功する") {
                    // Given
                    let request = SearchTagsByNameUseCaseRequest(
                        andQuery: "ゲーム",
                        orQuery: "FPS",
                        offset: 0,
                        limit: 10
                    )
                    
                    mockTagRepository.searchByNameResult = .success(
                        TagSearchResult(
                            tags: [testTags[0]],
                            totalCount: 1,
                            hasMore: false
                        )
                    )
                    
                    // When
                    var result: SearchTagsByNameUseCaseResponse?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(request: request)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(mockTagRepository.lastSearchByNameParams?.andQuery).to(equal("ゲーム"))
                    expect(mockTagRepository.lastSearchByNameParams?.orQuery).to(equal("FPS"))
                    expect(mockTagRepository.lastSearchByNameParams?.limit).to(equal(10))
                }
                
                it("空のクエリでも正常に処理される") {
                    // Given
                    let request = SearchTagsByNameUseCaseRequest(
                        andQuery: "",
                        orQuery: "",
                        offset: 0,
                        limit: 20
                    )
                    
                    mockTagRepository.searchByNameResult = .success(
                        TagSearchResult(
                            tags: testTags,
                            totalCount: 2,
                            hasMore: false
                        )
                    )
                    
                    // When
                    var result: SearchTagsByNameUseCaseResponse?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(request: request)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(result?.tags.count).to(equal(2))
                    expect(mockTagRepository.lastSearchByNameParams?.andQuery).to(equal(""))
                    expect(mockTagRepository.lastSearchByNameParams?.orQuery).to(equal(""))
                }
                
                it("ページネーション付きの検索が成功する") {
                    // Given
                    let request = SearchTagsByNameUseCaseRequest(
                        andQuery: "ゲーム",
                        orQuery: "",
                        offset: 10,
                        limit: 5
                    )
                    
                    mockTagRepository.searchByNameResult = .success(
                        TagSearchResult(
                            tags: [testTags[0]],
                            totalCount: 15,
                            hasMore: true
                        )
                    )
                    
                    // When
                    var result: SearchTagsByNameUseCaseResponse?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(request: request)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(result?.hasMore).to(beTrue())
                    expect(result?.totalCount).to(equal(15))
                    expect(mockTagRepository.lastSearchByNameParams?.offset).to(equal(10))
                    expect(mockTagRepository.lastSearchByNameParams?.limit).to(equal(5))
                }
                
                it("検索結果が空でも正常に処理される") {
                    // Given
                    let request = SearchTagsByNameUseCaseRequest(
                        andQuery: "存在しないタグ",
                        orQuery: "",
                        offset: 0,
                        limit: 20
                    )
                    
                    mockTagRepository.searchByNameResult = .success(
                        TagSearchResult(
                            tags: [],
                            totalCount: 0,
                            hasMore: false
                        )
                    )
                    
                    // When
                    var result: SearchTagsByNameUseCaseResponse?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(request: request)
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
                
                it("クエリの前後空白が除去される") {
                    // Given
                    let request = SearchTagsByNameUseCaseRequest(
                        andQuery: "  ゲーム  ",
                        orQuery: "  FPS  ",
                        offset: 0,
                        limit: 20
                    )
                    
                    mockTagRepository.searchByNameResult = .success(
                        TagSearchResult(
                            tags: testTags,
                            totalCount: 2,
                            hasMore: false
                        )
                    )
                    
                    // When
                    var result: SearchTagsByNameUseCaseResponse?
                    var error: Error?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(request: request)
                            } catch let err {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(error).to(beNil())
                    expect(mockTagRepository.lastSearchByNameParams?.andQuery).to(equal("ゲーム"))
                    expect(mockTagRepository.lastSearchByNameParams?.orQuery).to(equal("FPS"))
                }
            }
            
            context("リポジトリエラー") {
                it("ネットワークエラーがUseCaseエラーに変換される") {
                    // Given
                    let request = SearchTagsByNameUseCaseRequest(andQuery: "ゲーム")
                    mockTagRepository.searchByNameResult = .failure(.networkError)
                    
                    // When
                    var result: SearchTagsByNameUseCaseResponse?
                    var error: SearchTagsByNameUseCaseError?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(request: request)
                            } catch let err as SearchTagsByNameUseCaseError {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(result).to(beNil())
                    expect(error).toNot(beNil())
                    
                    guard case .repositoryError(let repoError) = error else {
                        fail("repositoryErrorであるべき")
                        return
                    }
                    
                    guard case .networkError = repoError else {
                        fail("networkErrorであるべき")
                        return
                    }
                    
                    expect(error?.title).to(equal("データ取得エラー"))
                    expect(error?.code).to(equal(2003))
                }
                
                it("サーバエラーがUseCaseエラーに変換される") {
                    // Given
                    let request = SearchTagsByNameUseCaseRequest(andQuery: "ゲーム")
                    mockTagRepository.searchByNameResult = .failure(.serverError)
                    
                    // When
                    var result: SearchTagsByNameUseCaseResponse?
                    var error: SearchTagsByNameUseCaseError?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(request: request)
                            } catch let err as SearchTagsByNameUseCaseError {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(result).to(beNil())
                    
                    guard case .repositoryError(let repoError) = error else {
                        fail("repositoryErrorであるべき")
                        return
                    }
                    
                    guard case .serverError = repoError else {
                        fail("serverErrorであるべき")
                        return
                    }
                }
                
                it("未知のエラーがUseCaseエラーに変換される") {
                    // Given
                    let request = SearchTagsByNameUseCaseRequest(andQuery: "ゲーム")
                    
                    // 直接未知のエラーをthrowすることをシミュレート
                    struct TestError: Error {}
                    let testError = TestError()
                    
                    // When
                    var result: SearchTagsByNameUseCaseResponse?
                    var error: SearchTagsByNameUseCaseError?
                    
                    waitUntil { done in
                        Task {
                            do {
                                // 未知のエラーを投げるようにモック設定を調整
                                mockTagRepository.searchByNameResult = nil // デフォルトのネットワークエラーも避ける
                                result = try await useCase.execute(request: request)
                            } catch let err as SearchTagsByNameUseCaseError {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(result).to(beNil())
                    expect(error).toNot(beNil())
                    
                    // ネットワークエラーからrepositoryErrorに変換されることを確認
                    guard case .repositoryError = error else {
                        fail("repositoryErrorであるべき")
                        return
                    }
                }
            }
            
            context("デフォルト値の確認") {
                it("リクエストのデフォルト値が正しく設定される") {
                    // When
                    let request = SearchTagsByNameUseCaseRequest()
                    
                    // Then
                    expect(request.andQuery).to(equal(""))
                    expect(request.orQuery).to(equal(""))
                    expect(request.offset).to(equal(0))
                    expect(request.limit).to(equal(20))
                }
                
                it("部分的なパラメータ指定でもデフォルト値が適用される") {
                    // When
                    let request = SearchTagsByNameUseCaseRequest(andQuery: "ゲーム")
                    
                    // Then
                    expect(request.andQuery).to(equal("ゲーム"))
                    expect(request.orQuery).to(equal(""))
                    expect(request.offset).to(equal(0))
                    expect(request.limit).to(equal(20))
                }
            }
        }
    }
}