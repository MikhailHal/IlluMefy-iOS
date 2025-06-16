//
//  SearchViewModelSpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/15.
//

import XCTest
import Combine
@testable import IlluMefy

@MainActor
final class SearchViewModelSpec: XCTestCase {
    
    private var viewModel: SearchViewModel!
    private var mockSearchByNameUseCase: MockSearchCreatorsByNameUseCase!
    private var mockSearchByTagsUseCase: MockSearchCreatorsByTagsUseCase!
    private var mockSaveSearchHistoryUseCase: MockSaveSearchHistoryUseCase!
    private var mockGetSearchHistoryUseCase: MockGetSearchHistoryUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockSearchByNameUseCase = MockSearchCreatorsByNameUseCase()
        mockSearchByTagsUseCase = MockSearchCreatorsByTagsUseCase()
        mockSaveSearchHistoryUseCase = MockSaveSearchHistoryUseCase()
        mockGetSearchHistoryUseCase = MockGetSearchHistoryUseCase()
        
        viewModel = SearchViewModel(
            searchByNameUseCase: mockSearchByNameUseCase,
            searchByTagsUseCase: mockSearchByTagsUseCase,
            saveSearchHistoryUseCase: mockSaveSearchHistoryUseCase,
            getSearchHistoryUseCase: mockGetSearchHistoryUseCase
        )
        
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockSearchByNameUseCase = nil
        mockSearchByTagsUseCase = nil
        mockSaveSearchHistoryUseCase = nil
        mockGetSearchHistoryUseCase = nil
        super.tearDown()
    }
    
    // MARK: - 初期状態のテスト
    
    func test_初期状態が正しく設定されている() {
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertTrue(viewModel.selectedTags.isEmpty)
        XCTAssertEqual(viewModel.tagSearchMode, .any)
        XCTAssertEqual(viewModel.sortOrder, .popularity)
        
        if case .initial = viewModel.state {
            // OK
        } else {
            XCTFail("初期状態はinitialであるべき")
        }
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.hasMore)
    }
    
    // MARK: - 名前検索のテスト
    
    func test_名前検索_成功() async {
        // Given
        let expectedCreators = [SampleCreator.gamePlayerA]
        mockSearchByNameUseCase.result = .success(
            SearchCreatorsByNameUseCaseResponse(
                creators: expectedCreators,
                totalCount: 1,
                hasMore: false
            )
        )
        
        // When
        viewModel.searchText = "ゲーム"
        await viewModel.search()
        
        // Then
        if case .loaded(let creators) = viewModel.state {
            XCTAssertEqual(creators.count, 1)
            XCTAssertEqual(creators.first?.id, expectedCreators.first?.id)
        } else {
            XCTFail("検索成功時はloaded状態であるべき")
        }
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.hasMore)
    }
    
    func test_名前検索_空の結果() async {
        // Given
        mockSearchByNameUseCase.result = .success(
            SearchCreatorsByNameUseCaseResponse(
                creators: [],
                totalCount: 0,
                hasMore: false
            )
        )
        
        // When
        viewModel.searchText = "存在しないクリエイター"
        await viewModel.search()
        
        // Then
        if case .empty = viewModel.state {
            // OK
        } else {
            XCTFail("検索結果が空の場合はempty状態であるべき")
        }
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.hasMore)
    }
    
    func test_名前検索_エラー() async {
        // Given
        mockSearchByNameUseCase.result = .failure(.emptyQuery)
        
        // When
        viewModel.searchText = "テスト"
        await viewModel.search()
        
        // Then
        if case .error(let title, let message) = viewModel.state {
            XCTAssertEqual(title, "検索エラー")
            XCTAssertEqual(message, "検索キーワードを入力してください")
        } else {
            XCTFail("検索エラー時はerror状態であるべき")
        }
        
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - タグ検索のテスト
    
    func test_タグ検索_AND検索() async {
        // Given
        let expectedCreators = [SampleCreator.gamePlayerA]
        mockSearchByTagsUseCase.result = .success(
            SearchCreatorsByTagsUseCaseResponse(
                creators: expectedCreators,
                searchedTags: ["fps", "apex-legends"],
                totalCount: 1,
                hasMore: false
            )
        )
        
        let tag1 = Tag(id: "fps", name: "FPS")
        let tag2 = Tag(id: "apex-legends", name: "Apex Legends")
        
        // When
        viewModel.tagSearchMode = .all
        viewModel.addTag(tag1)
        viewModel.addTag(tag2)
        await viewModel.search()
        
        // Then
        if case .loaded(let creators) = viewModel.state {
            XCTAssertEqual(creators.count, 1)
            XCTAssertEqual(creators.first?.id, expectedCreators.first?.id)
        } else {
            XCTFail("タグ検索成功時はloaded状態であるべき")
        }
        
        // UseCaseに正しいパラメータが渡されているか確認
        XCTAssertEqual(mockSearchByTagsUseCase.lastRequest?.searchMode, .all)
        XCTAssertEqual(mockSearchByTagsUseCase.lastRequest?.tagIds, ["fps", "apex-legends"])
    }
    
    func test_タグ検索_OR検索() async {
        // Given
        let expectedCreators = [SampleCreator.gamePlayerA, SampleCreator.vtuberB]
        mockSearchByTagsUseCase.result = .success(
            SearchCreatorsByTagsUseCaseResponse(
                creators: expectedCreators,
                searchedTags: ["fps", "singing"],
                totalCount: 2,
                hasMore: false
            )
        )
        
        let tag1 = Tag(id: "fps", name: "FPS")
        let tag2 = Tag(id: "singing", name: "歌")
        
        // When
        viewModel.tagSearchMode = .any
        viewModel.addTag(tag1)
        viewModel.addTag(tag2)
        await viewModel.search()
        
        // Then
        if case .loaded(let creators) = viewModel.state {
            XCTAssertEqual(creators.count, 2)
        } else {
            XCTFail("タグ検索成功時はloaded状態であるべき")
        }
        
        // UseCaseに正しいパラメータが渡されているか確認
        XCTAssertEqual(mockSearchByTagsUseCase.lastRequest?.searchMode, .any)
        XCTAssertEqual(mockSearchByTagsUseCase.lastRequest?.tagIds, ["fps", "singing"])
    }
    
    // MARK: - 複合検索のテスト
    
    func test_名前とタグの複合検索() async {
        // Given
        let nameResults = [SampleCreator.gamePlayerA, SampleCreator.vtuberB]
        let tagResults = [SampleCreator.gamePlayerA]
        
        mockSearchByNameUseCase.result = .success(
            SearchCreatorsByNameUseCaseResponse(
                creators: nameResults,
                totalCount: 2,
                hasMore: false
            )
        )
        
        mockSearchByTagsUseCase.result = .success(
            SearchCreatorsByTagsUseCaseResponse(
                creators: tagResults,
                searchedTags: ["fps"],
                totalCount: 1,
                hasMore: false
            )
        )
        
        let tag = Tag(id: "fps", name: "FPS")
        
        // When
        viewModel.searchText = "ゲーム"
        viewModel.addTag(tag)
        await viewModel.search()
        
        // Then
        if case .loaded(let creators) = viewModel.state {
            // 名前検索とタグ検索の積集合が返される
            XCTAssertEqual(creators.count, 1)
            XCTAssertEqual(creators.first?.id, SampleCreator.gamePlayerA.id)
        } else {
            XCTFail("複合検索成功時はloaded状態であるべき")
        }
    }
    
    // MARK: - 検索履歴のテスト
    
    func test_検索履歴の取得() async {
        // Given
        let expectedHistory = ["ゲーム", "VTuber", "料理"]
        mockGetSearchHistoryUseCase.result = .success(expectedHistory)
        
        // When
        let expectation = XCTestExpectation(description: "検索履歴の更新")
        viewModel.$searchHistory
            .dropFirst() // 初期値をスキップ
            .sink { history in
                XCTAssertEqual(history, expectedHistory)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // ViewModelの初期化で自動的に検索履歴が読み込まれる
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func test_検索履歴の保存() async {
        // Given
        mockSaveSearchHistoryUseCase.result = .success(())
        mockGetSearchHistoryUseCase.result = .success(["テスト"])
        
        mockSearchByNameUseCase.result = .success(
            SearchCreatorsByNameUseCaseResponse(
                creators: [SampleCreator.gamePlayerA],
                totalCount: 1,
                hasMore: false
            )
        )
        
        // When
        viewModel.searchText = "テスト"
        await viewModel.search()
        
        // Then
        XCTAssertEqual(mockSaveSearchHistoryUseCase.lastQuery, "テスト")
    }
    
    func test_履歴からの検索() {
        // When
        viewModel.selectFromHistory("過去の検索")
        
        // Then
        XCTAssertEqual(viewModel.searchText, "過去の検索")
    }
    
    // MARK: - ソート機能のテスト
    
    func test_ソート順の変更() async {
        // Given
        let creators = [SampleCreator.gamePlayerA, SampleCreator.vtuberB]
        mockSearchByNameUseCase.result = .success(
            SearchCreatorsByNameUseCaseResponse(
                creators: creators,
                totalCount: 2,
                hasMore: false
            )
        )
        
        // When
        viewModel.searchText = "テスト"
        viewModel.sortOrder = .newest
        await viewModel.search()
        
        // Then
        XCTAssertEqual(mockSearchByNameUseCase.lastRequest?.sortOrder, .newest)
    }
    
    // MARK: - タグ操作のテスト
    
    func test_タグの追加と削除() {
        // Given
        let tag1 = Tag(id: "1", name: "タグ1")
        let tag2 = Tag(id: "2", name: "タグ2")
        
        // When
        viewModel.addTag(tag1)
        viewModel.addTag(tag2)
        
        // Then
        XCTAssertEqual(viewModel.selectedTags.count, 2)
        XCTAssertTrue(viewModel.selectedTags.contains(tag1))
        XCTAssertTrue(viewModel.selectedTags.contains(tag2))
        
        // When
        viewModel.removeTag(tag1)
        
        // Then
        XCTAssertEqual(viewModel.selectedTags.count, 1)
        XCTAssertFalse(viewModel.selectedTags.contains(tag1))
        XCTAssertTrue(viewModel.selectedTags.contains(tag2))
    }
    
    func test_重複タグの追加() {
        // Given
        let tag = Tag(id: "1", name: "タグ1")
        
        // When
        viewModel.addTag(tag)
        viewModel.addTag(tag) // 同じタグを再度追加
        
        // Then
        XCTAssertEqual(viewModel.selectedTags.count, 1) // 重複しない
    }
    
    // MARK: - 検索クリアのテスト
    
    func test_検索のクリア() {
        // Given
        let tag = Tag(id: "1", name: "タグ1")
        viewModel.searchText = "テスト"
        viewModel.addTag(tag)
        
        // When
        viewModel.clearSearch()
        
        // Then
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertTrue(viewModel.selectedTags.isEmpty)
        
        if case .initial = viewModel.state {
            // OK
        } else {
            XCTFail("クリア後は初期状態であるべき")
        }
        
        XCTAssertFalse(viewModel.hasMore)
    }
    
    // MARK: - ページネーションのテスト
    
    func test_追加読み込み() async {
        // Given - 初回検索
        let initialCreators = [SampleCreator.gamePlayerA]
        mockSearchByNameUseCase.result = .success(
            SearchCreatorsByNameUseCaseResponse(
                creators: initialCreators,
                totalCount: 2,
                hasMore: true
            )
        )
        
        viewModel.searchText = "テスト"
        await viewModel.search()
        
        // Given - 追加読み込み
        let additionalCreators = [SampleCreator.vtuberB]
        mockSearchByNameUseCase.result = .success(
            SearchCreatorsByNameUseCaseResponse(
                creators: additionalCreators,
                totalCount: 2,
                hasMore: false
            )
        )
        
        // When
        await viewModel.loadMore()
        
        // Then
        if case .loaded(let creators) = viewModel.state {
            XCTAssertEqual(creators.count, 2) // 初回 + 追加
        } else {
            XCTFail("追加読み込み後はloaded状態であるべき")
        }
        
        XCTAssertFalse(viewModel.hasMore)
        
        // オフセットが正しく設定されているか確認
        XCTAssertEqual(mockSearchByNameUseCase.lastRequest?.offset, 20)
    }
}