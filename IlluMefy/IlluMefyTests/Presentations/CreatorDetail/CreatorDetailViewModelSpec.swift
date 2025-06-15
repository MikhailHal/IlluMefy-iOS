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
        
        describe("CreatorDetailViewModel") {
            beforeEach {
                mockGetCreatorDetailUseCase = MockGetCreatorDetailUseCase()
                
                viewModel = CreatorDetailViewModel(
                    creatorId: "test-creator-id",
                    getCreatorDetailUseCase: mockGetCreatorDetailUseCase
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
                        getCreatorDetailUseCase: mockGetCreatorDetailUseCase
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
                        id: "test-creator-id",
                        name: "Test Creator Name",
                        thumbnailUrl: "https://example.com/test.jpg",
                        viewCount: 10000,
                        socialLinkClickCount: 2000,
                        platformClickRatio: [
                            .youtube: 0.7,
                            .x: 0.3
                        ],
                        relatedTag: ["Gaming", "Tech"],
                        description: "This is a test creator",
                        platform: [
                            .youtube: "https://youtube.com/testchannel",
                            .x: "https://x.com/testuser"
                        ],
                        createdAt: Date(),
                        updatedAt: Date(),
                        isActive: true
                    )
                    
                    let similarCreators = [
                        Creator(
                            id: "similar-1",
                            name: "Similar Creator 1",
                            thumbnailUrl: "https://example.com/similar1.jpg",
                            viewCount: 5000,
                            socialLinkClickCount: 1000,
                            platformClickRatio: [:],
                            relatedTag: ["Gaming"],
                            description: "",
                            platform: [:],
                            createdAt: Date(),
                            updatedAt: Date(),
                            isActive: true
                        ),
                        Creator(
                            id: "similar-2",
                            name: "Similar Creator 2",
                            thumbnailUrl: "https://example.com/similar2.jpg",
                            viewCount: 6000,
                            socialLinkClickCount: 1200,
                            platformClickRatio: [:],
                            relatedTag: ["Tech"],
                            description: "",
                            platform: [:],
                            createdAt: Date(),
                            updatedAt: Date(),
                            isActive: true
                        )
                    ]
                    
                    beforeEach {
                        mockGetCreatorDetailUseCase.shouldSucceed = true
                        mockGetCreatorDetailUseCase.mockCreator = testCreator
                        mockGetCreatorDetailUseCase.mockSimilarCreators = similarCreators
                    }
                    
                    it("should update state to loading and then loaded") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                // 初期状態を確認
                                expect(viewModel.state).to(equal(CreatorDetailViewState.idle))
                                
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
                                } else {
                                    fail("Expected state to be loaded")
                                }
                                
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
                it("should toggle favorite state from false to true") {
                    expect(viewModel.isFavorite).to(beFalse())
                    viewModel.toggleFavorite()
                    expect(viewModel.isFavorite).to(beTrue())
                }
                
                it("should toggle favorite state from true to false") {
                    viewModel.isFavorite = true
                    expect(viewModel.isFavorite).to(beTrue())
                    viewModel.toggleFavorite()
                    expect(viewModel.isFavorite).to(beFalse())
                }
                
                it("should toggle multiple times correctly") {
                    expect(viewModel.isFavorite).to(beFalse())
                    
                    viewModel.toggleFavorite()
                    expect(viewModel.isFavorite).to(beTrue())
                    
                    viewModel.toggleFavorite()
                    expect(viewModel.isFavorite).to(beFalse())
                    
                    viewModel.toggleFavorite()
                    expect(viewModel.isFavorite).to(beTrue())
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
                        viewCount: 0,
                        socialLinkClickCount: 0,
                        platformClickRatio: [:],
                        relatedTag: [],
                        description: "",
                        platform: [:],
                        createdAt: Date(),
                        updatedAt: Date(),
                        isActive: true
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