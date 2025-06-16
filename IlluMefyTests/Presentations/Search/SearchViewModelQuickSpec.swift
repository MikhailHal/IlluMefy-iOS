//
//  SearchViewModelQuickSpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Quick
import Nimble
import Combine
@testable import IlluMefy

@MainActor
class SearchViewModelQuickSpec: QuickSpec {
    override class func spec() {
        describe("SearchViewModel") {
            var viewModel: SearchViewModel!
            var mockSearchTagsByNameUseCase: MockSearchTagsByNameUseCase!
            var mockSearchCreatorsByTagsUseCase: MockSearchCreatorsByTagsUseCase!
            var mockSaveSearchHistoryUseCase: MockSaveSearchHistoryUseCase!
            var mockGetSearchHistoryUseCase: MockGetSearchHistoryUseCase!
            var cancellables: Set<AnyCancellable>!
            
            beforeEach {
                mockSearchTagsByNameUseCase = MockSearchTagsByNameUseCase()
                mockSearchCreatorsByTagsUseCase = MockSearchCreatorsByTagsUseCase()
                mockSaveSearchHistoryUseCase = MockSaveSearchHistoryUseCase()
                mockGetSearchHistoryUseCase = MockGetSearchHistoryUseCase()
                
                // デフォルトの成功レスポンスを設定
                mockSearchTagsByNameUseCase.result = .success(
                    SearchTagsByNameUseCaseResponse(
                        tags: [
                            Tag(id: "game", tagName: "game", displayName: "ゲーム", clickedCount: 100),
                            Tag(id: "fps", tagName: "fps", displayName: "FPS", clickedCount: 80)
                        ],
                        totalCount: 2,
                        hasMore: false
                    )
                )
                
                mockGetSearchHistoryUseCase.result = .success([])
                
                viewModel = SearchViewModel(
                    searchTagsByNameUseCase: mockSearchTagsByNameUseCase,
                    searchCreatorsByTagsUseCase: mockSearchCreatorsByTagsUseCase,
                    saveSearchHistoryUseCase: mockSaveSearchHistoryUseCase,
                    getSearchHistoryUseCase: mockGetSearchHistoryUseCase
                )
                
                cancellables = Set<AnyCancellable>()
            }
            
            afterEach {
                cancellables = nil
                viewModel = nil
                mockSearchTagsByNameUseCase = nil
                mockSearchCreatorsByTagsUseCase = nil
                mockSaveSearchHistoryUseCase = nil
                mockGetSearchHistoryUseCase = nil
            }
            
            context("初期状態") {
                it("正しく初期化される") {
                    expect(viewModel.searchText).to(equal(""))
                    expect(viewModel.suggestions).to(beEmpty())
                    expect(viewModel.selectedTags).to(beEmpty())
                    expect(viewModel.searchHistory).to(beEmpty())
                    expect(viewModel.isLoading).to(beFalse())
                    expect(viewModel.hasMore).to(beFalse())
                    
                    switch viewModel.state {
                    case .initial:
                        break // OK
                    default:
                        fail("初期状態はinitialであるべき")
                    }
                }
            }
            
            context("検索テキストの入力") {
                it("入力に応じて候補が更新される") {
                    // Given
                    let expectation = expectation(description: "候補の更新")
                    
                    viewModel.$suggestions
                        .dropFirst() // 初期値をスキップ
                        .sink { suggestions in
                            expect(suggestions).toNot(beEmpty())
                            expectation.fulfill()
                        }
                        .store(in: &cancellables)
                    
                    // When
                    viewModel.searchText = "ゲー"
                    
                    // Then
                    waitForExpectations(timeout: 1.0)
                }
                
                it("空文字の場合は候補をクリア") {
                    // Given
                    viewModel.searchText = "ゲーム"
                    
                    // When
                    viewModel.searchText = ""
                    
                    // Then
                    expect(viewModel.suggestions).toEventually(beEmpty(), timeout: .seconds(1))
                }
            }
            
            context("タグ選択") {
                let testTag = Tag(id: "test", tagName: "test", displayName: "テスト", clickedCount: 10)
                
                it("予測変換からタグを直接追加") {
                    // When
                    viewModel.addSelectedTagFromSuggestion(testTag)
                    
                    // Then
                    expect(viewModel.selectedTags).to(contain(testTag))
                    expect(viewModel.searchText).to(equal(""))
                    expect(viewModel.suggestions).to(beEmpty())
                }
                
                it("重複するタグは追加されない") {
                    // Given
                    viewModel.addSelectedTagFromSuggestion(testTag)
                    
                    // When
                    viewModel.addSelectedTagFromSuggestion(testTag)
                    
                    // Then
                    expect(viewModel.selectedTags.count).to(equal(1))
                }
                
                it("タグの削除") {
                    // Given
                    viewModel.addSelectedTagFromSuggestion(testTag)
                    
                    // When
                    viewModel.removeTag(testTag)
                    
                    // Then
                    expect(viewModel.selectedTags).toNot(contain(testTag))
                }
            }
            
            context("クリエイター検索") {
                let testTag = Tag(id: "game", tagName: "game", displayName: "ゲーム", clickedCount: 100)
                let testCreators = [
                    Creator(
                        id: "creator1",
                        name: "テストクリエイター",
                        description: "説明",
                        thumbnailUrl: "https://example.com/thumb.jpg",
                        viewCount: 1000,
                        platform: [.youtube: "https://youtube.com/test"],
                        relatedTag: ["game"]
                    )
                ]
                
                beforeEach {
                    mockSearchCreatorsByTagsUseCase.result = .success(
                        SearchCreatorsByTagsUseCaseResponse(
                            creators: testCreators,
                            hasMore: false
                        )
                    )
                }
                
                it("タグ選択時に自動で検索が実行される") {
                    // Given
                    let expectation = expectation(description: "検索の実行")
                    
                    viewModel.$state
                        .sink { state in
                            if case .loadedCreators(let creators) = state {
                                expect(creators).to(equal(testCreators))
                                expectation.fulfill()
                            }
                        }
                        .store(in: &cancellables)
                    
                    // When
                    viewModel.addSelectedTagFromSuggestion(testTag)
                    
                    // Then
                    waitForExpectations(timeout: 2.0)
                }
                
                it("検索結果が空の場合はempty状態") {
                    // Given
                    mockSearchCreatorsByTagsUseCase.result = .success(
                        SearchCreatorsByTagsUseCaseResponse(
                            creators: [],
                            hasMore: false
                        )
                    )
                    
                    let expectation = expectation(description: "空状態の確認")
                    
                    viewModel.$state
                        .sink { state in
                            if case .empty = state {
                                expectation.fulfill()
                            }
                        }
                        .store(in: &cancellables)
                    
                    // When
                    viewModel.addSelectedTagFromSuggestion(testTag)
                    
                    // Then
                    waitForExpectations(timeout: 2.0)
                }
                
                it("検索エラー時はerror状態") {
                    // Given
                    mockSearchCreatorsByTagsUseCase.result = .failure(.networkError)
                    
                    let expectation = expectation(description: "エラー状態の確認")
                    
                    viewModel.$state
                        .sink { state in
                            if case .error(let title, let message) = state {
                                expect(title).toNot(beEmpty())
                                expect(message).toNot(beEmpty())
                                expectation.fulfill()
                            }
                        }
                        .store(in: &cancellables)
                    
                    // When
                    viewModel.addSelectedTagFromSuggestion(testTag)
                    
                    // Then
                    waitForExpectations(timeout: 2.0)
                }
            }
            
            context("ページネーション") {
                let testTag = Tag(id: "game", tagName: "game", displayName: "ゲーム", clickedCount: 100)
                let initialCreators = [
                    Creator(
                        id: "creator1",
                        name: "クリエイター1",
                        description: "説明1",
                        thumbnailUrl: "https://example.com/thumb1.jpg",
                        viewCount: 1000,
                        platform: [.youtube: "https://youtube.com/test1"],
                        relatedTag: ["game"]
                    )
                ]
                let additionalCreators = [
                    Creator(
                        id: "creator2",
                        name: "クリエイター2",
                        description: "説明2",
                        thumbnailUrl: "https://example.com/thumb2.jpg",
                        viewCount: 2000,
                        platform: [.youtube: "https://youtube.com/test2"],
                        relatedTag: ["game"]
                    )
                ]
                
                it("追加読み込みが正しく動作する") {
                    // Given - 初回検索
                    mockSearchCreatorsByTagsUseCase.result = .success(
                        SearchCreatorsByTagsUseCaseResponse(
                            creators: initialCreators,
                            hasMore: true
                        )
                    )
                    
                    // 初回検索
                    viewModel.addSelectedTagFromSuggestion(testTag)
                    
                    // hasMoreがtrueになるまで待機
                    expect(viewModel.hasMore).toEventually(beTrue(), timeout: .seconds(2))
                    
                    // Given - 追加読み込み
                    mockSearchCreatorsByTagsUseCase.result = .success(
                        SearchCreatorsByTagsUseCaseResponse(
                            creators: additionalCreators,
                            hasMore: false
                        )
                    )
                    
                    // When
                    await viewModel.loadMore()
                    
                    // Then
                    switch viewModel.state {
                    case .loadedCreators(let creators):
                        expect(creators.count).to(equal(2))
                        expect(viewModel.hasMore).to(beFalse())
                    default:
                        fail("追加読み込み後はloadedCreators状態であるべき")
                    }
                }
            }
            
            context("検索履歴") {
                it("履歴からタグを追加") {
                    // Given
                    let historyQuery = "ゲーム,FPS"
                    
                    // When
                    viewModel.addTagsFromHistory(historyQuery)
                    
                    // Then
                    expect(viewModel.selectedTags.count).to(equal(2))
                    let tagNames = viewModel.selectedTags.map { $0.displayName }
                    expect(tagNames).to(contain("ゲーム"))
                    expect(tagNames).to(contain("FPS"))
                    expect(viewModel.searchText).to(equal(""))
                    expect(viewModel.suggestions).to(beEmpty())
                }
                
                it("存在しないタグは無視される") {
                    // Given
                    let historyQuery = "存在しないタグ,ゲーム"
                    
                    // When
                    viewModel.addTagsFromHistory(historyQuery)
                    
                    // Then
                    expect(viewModel.selectedTags.count).to(equal(1))
                    expect(viewModel.selectedTags.first?.displayName).to(equal("ゲーム"))
                }
            }
            
            context("検索のクリア") {
                it("全ての状態がリセットされる") {
                    // Given
                    let testTag = Tag(id: "test", tagName: "test", displayName: "テスト", clickedCount: 10)
                    viewModel.searchText = "テストクエリ"
                    viewModel.addSelectedTagFromSuggestion(testTag)
                    
                    // When
                    viewModel.clearSearch()
                    
                    // Then
                    expect(viewModel.searchText).to(equal(""))
                    expect(viewModel.selectedTags).to(beEmpty())
                    expect(viewModel.suggestions).to(beEmpty())
                    expect(viewModel.hasMore).to(beFalse())
                    
                    switch viewModel.state {
                    case .initial:
                        break // OK
                    default:
                        fail("クリア後は初期状態であるべき")
                    }
                }
            }
        }
    }
}

// MARK: - Mock Extensions

extension MockSearchTagsByNameUseCase {
    var result: Result<SearchTagsByNameUseCaseResponse, SearchTagsByNameUseCaseError>? {
        get { _result }
        set { _result = newValue }
    }
    
    private var _result: Result<SearchTagsByNameUseCaseResponse, SearchTagsByNameUseCaseError>?
    
    func execute(request: SearchTagsByNameUseCaseRequest) async throws -> SearchTagsByNameUseCaseResponse {
        guard let result = _result else {
            throw SearchTagsByNameUseCaseError.networkError
        }
        
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}

extension MockSearchCreatorsByTagsUseCase {
    var result: Result<SearchCreatorsByTagsUseCaseResponse, SearchCreatorsByTagsUseCaseError>? {
        get { _result }
        set { _result = newValue }
    }
    
    private var _result: Result<SearchCreatorsByTagsUseCaseResponse, SearchCreatorsByTagsUseCaseError>?
    
    func execute(request: SearchCreatorsByTagsUseCaseRequest) async throws -> SearchCreatorsByTagsUseCaseResponse {
        guard let result = _result else {
            throw SearchCreatorsByTagsUseCaseError.networkError
        }
        
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}

extension MockSaveSearchHistoryUseCase {
    var result: Result<Void, Error>? {
        get { _result }
        set { _result = newValue }
    }
    
    private var _result: Result<Void, Error>?
    
    func execute(query: String) async throws {
        guard let result = _result else {
            throw NSError(domain: "Test", code: 0)
        }
        
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}

extension MockGetSearchHistoryUseCase {
    var result: Result<[String], Error>? {
        get { _result }
        set { _result = newValue }
    }
    
    private var _result: Result<[String], Error>?
    
    func execute() async throws -> [String] {
        guard let result = _result else {
            throw NSError(domain: "Test", code: 0)
        }
        
        switch result {
        case .success(let history):
            return history
        case .failure(let error):
            throw error
        }
    }
}