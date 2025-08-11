//
//  CreatorDetailViewModelSpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/15.
//

import Foundation
import Quick
import Nimble
@testable import IlluMefy

@MainActor
final class CreatorDetailViewModelSpec: QuickSpec, @unchecked Sendable {
    override class func spec() {
        var viewModel: CreatorDetailViewModel!
        var mockGetCreatorDetailUseCase: MockGetCreatorDetailUseCase!
        var mockFavoriteRepository: MockFavoriteRepository!
        
        describe("CreatorDetailViewModel") {
            beforeEach {
                mockGetCreatorDetailUseCase = MockGetCreatorDetailUseCase()
                mockFavoriteRepository = MockFavoriteRepository()
                
                viewModel = CreatorDetailViewModel(
                    creatorId: "test-creator-id",
                    getCreatorDetailUseCase: mockGetCreatorDetailUseCase,
                    favoriteRepository: mockFavoriteRepository
                )
            }
            
            afterEach {
                mockGetCreatorDetailUseCase.reset()
            }
            
            context("initialization") {
                it("should initialize with default values") {
                    expect(viewModel.state).to(equal(CreatorDetailViewState.idle))
                    expect(viewModel.isFavorite).to(beFalse())
                }
                
                it("should store the creator ID") {
                    let customViewModel = CreatorDetailViewModel(
                        creatorId: "custom-id-123",
                        getCreatorDetailUseCase: mockGetCreatorDetailUseCase,
                        favoriteRepository: mockFavoriteRepository
                    )
                    // ViewModelがcreatorIdをprivateで保持しているため、
                    // loadCreatorDetailが呼ばれた時に正しいIDが使われることで確認
                    mockGetCreatorDetailUseCase.shouldSucceed = true
                    
                    waitUntil(timeout: .seconds(3)) { done in
                        Task {
                            await customViewModel.loadCreatorDetail()
                            expect(mockGetCreatorDetailUseCase.lastExecutedRequest?.creatorId).to(equal("custom-id-123"))
                            done()
                        }
                    }
                }
            }
            
            context("loadCreatorDetail") {
                context("when loading succeeds") {
                    let testCreator = Creator(
                        id: "creator_001",
                        name: "ゲーム実況者A",
                        thumbnailUrl: "https://picsum.photos/200/200?random=1",
                        socialLinkClickCount: 1500,
                        tag: ["tag_007", "tag_011"],
                        description: "FPSゲームをメインに実況しています。毎日20時から配信！",
                        platform: [
                            .youtube: "https://youtube.com/@gameplayerA",
                            .twitch: "https://twitch.tv/gameplayerA",
                            .x: "https://twitter.com/gameplayerA"
                        ],
                        createdAt: Date().addingTimeInterval(-86400 * 30),
                        updatedAt: Date().addingTimeInterval(-3600),
                        favoriteCount: 100
                    )
                    
                    let similarCreators = [
                        Creator(
                            id: "creator_001",
                            name: "ゲーム実況者A",
                            thumbnailUrl: "https://picsum.photos/200/200?random=1",
                            socialLinkClickCount: 1500,
                            tag: ["tag_007", "tag_011"],
                            description: "FPSゲームをメインに実況しています。毎日20時から配信！",
                            platform: [
                                .youtube: "https://youtube.com/@gameplayerA",
                                .twitch: "https://twitch.tv/gameplayerA",
                                .x: "https://twitter.com/gameplayerA"
                            ],
                            createdAt: Date().addingTimeInterval(-86400 * 30),
                            updatedAt: Date().addingTimeInterval(-3600),
                            favoriteCount: 100
                        ),
                        Creator(
                            id: "creator_001",
                            name: "ゲーム実況者A",
                            thumbnailUrl: "https://picsum.photos/200/200?random=1",
                            socialLinkClickCount: 1500,
                            tag: ["tag_007", "tag_011"],
                            description: "FPSゲームをメインに実況しています。毎日20時から配信！",
                            platform: [
                                .youtube: "https://youtube.com/@gameplayerA",
                                .twitch: "https://twitch.tv/gameplayerA",
                                .x: "https://twitter.com/gameplayerA"
                            ],
                            createdAt: Date().addingTimeInterval(-86400 * 30),
                            updatedAt: Date().addingTimeInterval(-3600),
                            favoriteCount: 100
                        )
                    ]
                    
                    beforeEach {
                        mockGetCreatorDetailUseCase.shouldSucceed = true
                        mockGetCreatorDetailUseCase.mockCreator = testCreator
                        mockGetCreatorDetailUseCase.mockSimilarCreators = similarCreators
                    }
                    
                    it("should update state to loading and then loaded with favorite status") {
                        // お気に入り状態を設定
                        mockFavoriteRepository.mockFavoriteIds = ["test-creator-id"]
                        
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                // 初期状態を確認
                                expect(viewModel.state).to(equal(CreatorDetailViewState.idle))
                                expect(viewModel.isFavorite).to(beFalse())
                                
                                // loadCreatorDetailを実行
                                let loadTask = Task {
                                    await viewModel.loadCreatorDetail()
                                }
                                
                                // loading状態になることを確認（非同期なので少し待つ）
                                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1秒
                                
                                // 完了を待つ
                                await loadTask.value
                                
                                // loaded状態になることを確認
                                if case let .loaded(creator, similar) = viewModel.state {
                                    expect(creator).to(equal(testCreator))
                                    expect(similar).to(equal(similarCreators))
                                    expect(viewModel.isFavorite).to(beTrue()) // お気に入り状態も確認
                                } else {
                                    fail("Expected state to be loaded")
                                }
                                
                                done()
                            }
                        }
                    }
                    
                    it("should load with non-favorite status") {
                        // お気に入りに含まれていない
                        mockFavoriteRepository.mockFavoriteIds = []
                        
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.loadCreatorDetail()
                                
                                expect(viewModel.isFavorite).to(beFalse())
                                done()
                            }
                        }
                    }
                    
                    it("should call use case with correct request") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.loadCreatorDetail()
                                
                                expect(mockGetCreatorDetailUseCase.executeCallCount).to(equal(1))
                                expect(mockGetCreatorDetailUseCase.lastExecutedRequest?.creatorId).to(equal("test-creator-id"))
                                done()
                            }
                        }
                    }
                }
                
                context("when creator is not found") {
                    beforeEach {
                        mockGetCreatorDetailUseCase.shouldSucceed = false
                        mockGetCreatorDetailUseCase.mockError = .creatorNotFound
                    }
                    
                    it("should update state to error with specific message") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.loadCreatorDetail()
                                
                                if case let .error(title, message) = viewModel.state {
                                    expect(title).to(equal("クリエイターが見つかりません"))
                                    expect(message).to(equal("指定されたクリエイターは存在しないか、削除された可能性があります。"))
                                } else {
                                    fail("Expected state to be error")
                                }
                                
                                done()
                            }
                        }
                    }
                }
                
                context("when other errors occur") {
                    beforeEach {
                        mockGetCreatorDetailUseCase.shouldSucceed = false
                        struct TestError: Error {}
                        mockGetCreatorDetailUseCase.mockError = .repositoryError(TestError())
                    }
                    
                    it("should update state to error with generic message") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.loadCreatorDetail()
                                
                                if case let .error(title, message) = viewModel.state {
                                    expect(title).to(equal("読み込みエラー"))
                                    expect(message).to(equal("クリエイター情報の読み込みに失敗しました。もう一度お試しください。"))
                                } else {
                                    fail("Expected state to be error")
                                }
                                
                                done()
                            }
                        }
                    }
                }
                
                context("when unexpected error is thrown") {
                    beforeEach {
                        mockGetCreatorDetailUseCase.shouldThrowUnexpectedError = true
                    }
                    
                    it("should update state to error with generic message") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.loadCreatorDetail()
                                
                                if case let .error(title, message) = viewModel.state {
                                    expect(title).to(equal("読み込みエラー"))
                                    expect(message).to(equal("クリエイター情報の読み込みに失敗しました。もう一度お試しください。"))
                                } else {
                                    fail("Expected state to be error")
                                }
                                
                                done()
                            }
                        }
                    }
                }
            }
            
            context("toggleFavorite") {
                it("should add to favorites when not favorite") {
                    // お気に入りでない状態から開始
                    viewModel.isFavorite = false
                    mockFavoriteRepository.mockFavoriteIds = []
                    
                    viewModel.toggleFavorite()
                    
                    // 非同期処理を待つ
                    waitUntil(timeout: .seconds(3)) { done in
                        Task {
                            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5秒待つ
                            expect(mockFavoriteRepository.mockFavoriteIds).to(contain("test-creator-id"))
                            expect(viewModel.isFavorite).to(beTrue())
                            done()
                        }
                    }
                }
                
                it("should remove from favorites when already favorite") {
                    // お気に入り状態から開始
                    viewModel.isFavorite = true
                    mockFavoriteRepository.mockFavoriteIds = ["test-creator-id"]
                    
                    viewModel.toggleFavorite()
                    
                    // 非同期処理を待つ
                    waitUntil(timeout: .seconds(3)) { done in
                        Task {
                            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5秒待つ
                            expect(mockFavoriteRepository.mockFavoriteIds).toNot(contain("test-creator-id"))
                            expect(viewModel.isFavorite).to(beFalse())
                            done()
                        }
                    }
                }
                
                it("should handle error gracefully") {
                    // エラーが発生する設定
                    viewModel.isFavorite = false
                    mockFavoriteRepository.shouldThrowError = true
                    
                    viewModel.toggleFavorite()
                    
                    // エラーが発生してもUIが変更されないことを確認
                    waitUntil(timeout: .seconds(3)) { done in
                        Task {
                            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5秒待つ
                            expect(viewModel.isFavorite).to(beFalse()) // 変更されていない
                            done()
                        }
                    }
                }
            }
            
            context("state equality") {
                it("should correctly compare idle states") {
                    let state1 = CreatorDetailViewState.idle
                    let state2 = CreatorDetailViewState.idle
                    expect(state1).to(equal(state2))
                }
                
                it("should correctly compare loading states") {
                    let state1 = CreatorDetailViewState.loading
                    let state2 = CreatorDetailViewState.loading
                    expect(state1).to(equal(state2))
                }
                
                it("should correctly compare loaded states") {
                    let creator = Creator(
                        id: "1",
                        name: "Test",
                        thumbnailUrl: "url",
                        socialLinkClickCount: 0,
                        tag: [],
                        description: "",
                        platform: [:],
                        createdAt: Date(),
                        updatedAt: Date(),
                        favoriteCount: 0
                    )
                    
                    let state1 = CreatorDetailViewState.loaded(creator: creator, similarCreators: [])
                    let state2 = CreatorDetailViewState.loaded(creator: creator, similarCreators: [])
                    expect(state1).to(equal(state2))
                }
                
                it("should correctly compare error states") {
                    let state1 = CreatorDetailViewState.error(title: "Error", message: "Message")
                    let state2 = CreatorDetailViewState.error(title: "Error", message: "Message")
                    expect(state1).to(equal(state2))
                }
                
                it("should not equal different states") {
                    let state1 = CreatorDetailViewState.idle
                    let state2 = CreatorDetailViewState.loading
                    expect(state1).toNot(equal(state2))
                }
            }
        }
    }
}
