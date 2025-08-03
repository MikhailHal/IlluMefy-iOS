//
//  SearchCreatorsByTagsUseCaseSpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Quick
import Nimble
import Foundation
@testable import IlluMefy

@MainActor
class SearchCreatorsByTagsUseCaseSpec: QuickSpec {
    override class func spec() {
        describe("SearchCreatorsByTagsUseCase") {
            var useCase: SearchCreatorsByTagsUseCase!
            var mockCreatorRepository: MockSearchCreatorsByTagsRepository!
            
            beforeEach {
                mockCreatorRepository = MockSearchCreatorsByTagsRepository()
                useCase = SearchCreatorsByTagsUseCase(creatorRepository: mockCreatorRepository)
            }
            
            afterEach {
                useCase = nil
                mockCreatorRepository = nil
            }
            
            context("正常ケース") {
                let testCreators = [
                    Creator(
                        id: "creator1",
                        name: "ゲームプレイヤー",
                        thumbnailUrl: "https://example.com/thumb1.jpg",
                        viewCount: 10000,
                        socialLinkClickCount: 500,
                        platformClickRatio: [.youtube: 1.0],
                        relatedTag: ["fps", "game"],
                        description: "FPSゲームの実況",
                        platform: [.youtube: "https://youtube.com/creator1"],
                        createdAt: Date().addingTimeInterval(-86400),
                        updatedAt: Date().addingTimeInterval(-3600),
                        isActive: true,
                        favoriteCount: 0
                    ),
                    Creator(
                        id: "creator2",
                        name: "Apexプレイヤー",
                        thumbnailUrl: "https://example.com/thumb2.jpg",
                        viewCount: 8000,
                        socialLinkClickCount: 300,
                        platformClickRatio: [.twitch: 1.0],
                        relatedTag: ["apex", "fps"],
                        description: "Apex Legendsの配信",
                        platform: [.twitch: "https://twitch.tv/creator2"],
                        createdAt: Date().addingTimeInterval(-86400 * 2),
                        updatedAt: Date().addingTimeInterval(-7200),
                        isActive: true,
                        favoriteCount: 0
                    )
                ]
                
                it("単一タグでの検索が成功する") {
                    // Given
                    let request = SearchCreatorsByTagsUseCaseRequest(
                        tagIds: ["fps"],
                        searchMode: .any,
                        sortOrder: .popularity
                    )
                    
                    mockCreatorRepository.searchByTagsResult = .success(
                        CreatorSearchResult(
                            creators: testCreators,
                            totalCount: 2,
                            hasMore: false
                        )
                    )
                    
                    // When
                    var result: SearchCreatorsByTagsUseCaseResponse?
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
                    expect(result?.creators.count).to(equal(2))
                    expect(result?.searchedTags).to(equal(["fps"]))
                    expect(result?.totalCount).to(equal(2))
                    expect(result?.hasMore).to(beFalse())
                    
                    // リポジトリが正しいパラメータで呼ばれたか確認
                    expect(mockCreatorRepository.lastSearchByTagsParams?.tagIds).to(equal(["fps"]))
                    expect(mockCreatorRepository.lastSearchByTagsParams?.searchMode).to(equal(.any))
                    expect(mockCreatorRepository.lastSearchByTagsParams?.sortOrder).to(equal(.popularity))
                }
                
                it("複数タグでのAND検索が成功する") {
                    // Given
                    let request = SearchCreatorsByTagsUseCaseRequest(
                        tagIds: ["fps", "game"],
                        searchMode: .all,
                        sortOrder: .newest
                    )
                    
                    mockCreatorRepository.searchByTagsResult = .success(
                        CreatorSearchResult(
                            creators: [testCreators[0]], // AND検索で1件のみ
                            totalCount: 1,
                            hasMore: false
                        )
                    )
                    
                    // When
                    var result: SearchCreatorsByTagsUseCaseResponse?
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
                    expect(result?.creators.count).to(equal(1))
                    expect(result?.searchedTags).to(equal(["fps", "game"]))
                    expect(mockCreatorRepository.lastSearchByTagsParams?.searchMode).to(equal(.all))
                }
                
                it("ページネーション付きの検索が成功する") {
                    // Given
                    let request = SearchCreatorsByTagsUseCaseRequest(
                        tagIds: ["game"],
                        offset: 20,
                        limit: 10
                    )
                    
                    mockCreatorRepository.searchByTagsResult = .success(
                        CreatorSearchResult(
                            creators: testCreators,
                            totalCount: 50,
                            hasMore: true
                        )
                    )
                    
                    // When
                    var result: SearchCreatorsByTagsUseCaseResponse?
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
                    expect(result?.totalCount).to(equal(50))
                    expect(mockCreatorRepository.lastSearchByTagsParams?.offset).to(equal(20))
                    expect(mockCreatorRepository.lastSearchByTagsParams?.limit).to(equal(10))
                }
                
                it("空の結果でも正常に処理される") {
                    // Given
                    let request = SearchCreatorsByTagsUseCaseRequest(tagIds: ["rare-tag"])
                    
                    mockCreatorRepository.searchByTagsResult = .success(
                        CreatorSearchResult(
                            creators: [],
                            totalCount: 0,
                            hasMore: false
                        )
                    )
                    
                    // When
                    var result: SearchCreatorsByTagsUseCaseResponse?
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
                    expect(result?.creators).to(beEmpty())
                    expect(result?.totalCount).to(equal(0))
                    expect(result?.hasMore).to(beFalse())
                }
            }
            
            context("バリデーションエラー") {
                it("空のタグIDでエラーが発生する") {
                    // Given
                    let request = SearchCreatorsByTagsUseCaseRequest(tagIds: [])
                    
                    // When
                    var result: SearchCreatorsByTagsUseCaseResponse?
                    var error: SearchCreatorsByTagsUseCaseError?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(request: request)
                            } catch let err as SearchCreatorsByTagsUseCaseError {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(result).to(beNil())
                    expect(error).toNot(beNil())
                    
                    guard case .emptyTags = error else {
                        fail("emptyTagsエラーであるべき")
                        return
                    }
                    
                    expect(error?.title).to(equal("タグが未選択"))
                    expect(error?.message).to(equal("検索するタグを選択してください"))
                    expect(error?.code).to(equal(3001))
                    expect(error?.isRetryable).to(beFalse())
                }
                
                it("タグ数が上限を超えるとエラーが発生する") {
                    // Given
                    let tooManyTags = Array(1...11).map { "tag\($0)" }
                    let request = SearchCreatorsByTagsUseCaseRequest(tagIds: tooManyTags)
                    
                    // When
                    var result: SearchCreatorsByTagsUseCaseResponse?
                    var error: SearchCreatorsByTagsUseCaseError?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(request: request)
                            } catch let err as SearchCreatorsByTagsUseCaseError {
                                error = err
                            }
                            done()
                        }
                    }
                    
                    // Then
                    expect(result).to(beNil())
                    expect(error).toNot(beNil())
                    
                    guard case .tooManyTags = error else {
                        fail("tooManyTagsエラーであるべき")
                        return
                    }
                    
                    expect(error?.title).to(equal("タグが多すぎます"))
                    expect(error?.message).to(equal("タグは10個まで選択可能です"))
                    expect(error?.code).to(equal(3002))
                    expect(error?.isRetryable).to(beFalse())
                }
            }
            
            context("リポジトリエラー") {
                it("ネットワークエラーがUseCaseエラーに変換される") {
                    // Given
                    let request = SearchCreatorsByTagsUseCaseRequest(tagIds: ["game"])
                    mockCreatorRepository.searchByTagsResult = .failure(.networkError)
                    
                    // When
                    var result: SearchCreatorsByTagsUseCaseResponse?
                    var error: SearchCreatorsByTagsUseCaseError?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(request: request)
                            } catch let err as SearchCreatorsByTagsUseCaseError {
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
                    expect(error?.code).to(equal(3003))
                }
                
                it("サーバエラーがUseCaseエラーに変換される") {
                    // Given
                    let request = SearchCreatorsByTagsUseCaseRequest(tagIds: ["game"])
                    mockCreatorRepository.searchByTagsResult = .failure(.serverError)
                    
                    // When
                    var result: SearchCreatorsByTagsUseCaseResponse?
                    var error: SearchCreatorsByTagsUseCaseError?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(request: request)
                            } catch let err as SearchCreatorsByTagsUseCaseError {
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
                    let request = SearchCreatorsByTagsUseCaseRequest(tagIds: ["game"])
                    struct TestError: Error, LocalizedError {
                        let message: String
                        var errorDescription: String? { return message }
                    }
                    let unknownError = TestError(message: "テストエラー")
                    mockCreatorRepository.searchByTagsResult = .failure(.unknown(unknownError))
                    
                    // When
                    var result: SearchCreatorsByTagsUseCaseResponse?
                    var error: SearchCreatorsByTagsUseCaseError?
                    
                    waitUntil { done in
                        Task {
                            do {
                                result = try await useCase.execute(request: request)
                            } catch let err as SearchCreatorsByTagsUseCaseError {
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
                    
                    guard case .unknown(let underlyingError) = repoError else {
                        fail("unknown repositoryErrorであるべき")
                        return
                    }
                    
                    expect(underlyingError.localizedDescription).to(equal("テストエラー"))
                }
            }
            
            context("デフォルト値の確認") {
                it("リクエストのデフォルト値が正しく設定される") {
                    // When
                    let request = SearchCreatorsByTagsUseCaseRequest(tagIds: ["game"])
                    
                    // Then
                    expect(request.searchMode).to(equal(.any))
                    expect(request.sortOrder).to(equal(.popularity))
                    expect(request.offset).to(equal(0))
                    expect(request.limit).to(equal(20))
                }
            }
        }
    }
}
