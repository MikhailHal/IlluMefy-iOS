//
//  SearchCreatorsByNameUseCaseSpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/15.
//

import XCTest
@testable import IlluMefy

final class SearchCreatorsByNameUseCaseSpec: XCTestCase {
    
    private var useCase: SearchCreatorsByNameUseCase!
    private var mockRepository: MockCreatorRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCreatorRepository()
        useCase = SearchCreatorsByNameUseCase(creatorRepository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - 正常系テスト
    
    func test_正常な検索クエリで成功() async throws {
        // Given
        let request = SearchCreatorsByNameUseCaseRequest(
            query: "ゲーム",
            sortOrder: .popularity,
            offset: 0,
            limit: 10
        )
        
        let expectedResult = CreatorSearchResult(
            creators: [SampleCreator.gamePlayerA],
            totalCount: 1,
            hasMore: false
        )
        
        mockRepository.searchByNameResult = .success(expectedResult)
        
        // When
        let response = try await useCase.execute(request: request)
        
        // Then
        XCTAssertEqual(response.creators.count, 1)
        XCTAssertEqual(response.creators.first?.id, SampleCreator.gamePlayerA.id)
        XCTAssertEqual(response.totalCount, 1)
        XCTAssertFalse(response.hasMore)
        
        // リポジトリに正しいパラメータが渡されているか確認
        let lastCall = mockRepository.lastSearchByNameCall
        XCTAssertEqual(lastCall?.query, "ゲーム")
        XCTAssertEqual(lastCall?.sortOrder, .popularity)
        XCTAssertEqual(lastCall?.offset, 0)
        XCTAssertEqual(lastCall?.limit, 10)
    }
    
    func test_ページネーション付きの検索() async throws {
        // Given
        let request = SearchCreatorsByNameUseCaseRequest(
            query: "クリエイター",
            sortOrder: .newest,
            offset: 20,
            limit: 5
        )
        
        let expectedResult = CreatorSearchResult(
            creators: [SampleCreator.vtuberB],
            totalCount: 25,
            hasMore: true
        )
        
        mockRepository.searchByNameResult = .success(expectedResult)
        
        // When
        let response = try await useCase.execute(request: request)
        
        // Then
        XCTAssertEqual(response.creators.count, 1)
        XCTAssertEqual(response.totalCount, 25)
        XCTAssertTrue(response.hasMore)
        
        // パラメータの確認
        let lastCall = mockRepository.lastSearchByNameCall
        XCTAssertEqual(lastCall?.offset, 20)
        XCTAssertEqual(lastCall?.limit, 5)
        XCTAssertEqual(lastCall?.sortOrder, .newest)
    }
    
    func test_空の検索結果() async throws {
        // Given
        let request = SearchCreatorsByNameUseCaseRequest(
            query: "存在しないクリエイター",
            sortOrder: .name
        )
        
        let expectedResult = CreatorSearchResult(
            creators: [],
            totalCount: 0,
            hasMore: false
        )
        
        mockRepository.searchByNameResult = .success(expectedResult)
        
        // When
        let response = try await useCase.execute(request: request)
        
        // Then
        XCTAssertTrue(response.creators.isEmpty)
        XCTAssertEqual(response.totalCount, 0)
        XCTAssertFalse(response.hasMore)
    }
    
    // MARK: - バリデーションテスト
    
    func test_空のクエリでエラー() async {
        // Given
        let request = SearchCreatorsByNameUseCaseRequest(query: "")
        
        // When & Then
        do {
            _ = try await useCase.execute(request: request)
            XCTFail("空のクエリではエラーになるべき")
        } catch let error as SearchCreatorsByNameUseCaseError {
            XCTAssertEqual(error, .emptyQuery)
        } catch {
            XCTFail("予期しないエラー: \(error)")
        }
    }
    
    func test_空白のみのクエリでエラー() async {
        // Given
        let request = SearchCreatorsByNameUseCaseRequest(query: "   \n\t  ")
        
        // When & Then
        do {
            _ = try await useCase.execute(request: request)
            XCTFail("空白のみのクエリではエラーになるべき")
        } catch let error as SearchCreatorsByNameUseCaseError {
            XCTAssertEqual(error, .emptyQuery)
        } catch {
            XCTFail("予期しないエラー: \(error)")
        }
    }
    
    func test_長すぎるクエリでエラー() async {
        // Given
        let longQuery = String(repeating: "a", count: 101) // 100文字を超える
        let request = SearchCreatorsByNameUseCaseRequest(query: longQuery)
        
        // When & Then
        do {
            _ = try await useCase.execute(request: request)
            XCTFail("長すぎるクエリではエラーになるべき")
        } catch let error as SearchCreatorsByNameUseCaseError {
            XCTAssertEqual(error, .invalidQuery)
        } catch {
            XCTFail("予期しないエラー: \(error)")
        }
    }
    
    func test_クエリの前後の空白が除去される() async throws {
        // Given
        let request = SearchCreatorsByNameUseCaseRequest(query: "  ゲーム  ")
        
        let expectedResult = CreatorSearchResult(
            creators: [SampleCreator.gamePlayerA],
            totalCount: 1,
            hasMore: false
        )
        
        mockRepository.searchByNameResult = .success(expectedResult)
        
        // When
        _ = try await useCase.execute(request: request)
        
        // Then
        let lastCall = mockRepository.lastSearchByNameCall
        XCTAssertEqual(lastCall?.query, "ゲーム") // 前後の空白が除去されている
    }
    
    // MARK: - エラーハンドリングテスト
    
    func test_リポジトリエラーの変換() async {
        // Given
        let request = SearchCreatorsByNameUseCaseRequest(query: "テスト")
        mockRepository.searchByNameResult = .failure(.networkError)
        
        // When & Then
        do {
            _ = try await useCase.execute(request: request)
            XCTFail("リポジトリエラーではエラーになるべき")
        } catch let error as SearchCreatorsByNameUseCaseError {
            if case .repositoryError(let repositoryError) = error {
                XCTAssertEqual(repositoryError, .networkError)
            } else {
                XCTFail("repositoryErrorでラップされるべき: \(error)")
            }
        } catch {
            XCTFail("予期しないエラー: \(error)")
        }
    }
    
    func test_予期しないエラーの変換() async {
        // Given
        let request = SearchCreatorsByNameUseCaseRequest(query: "テスト")
        
        // リポジトリで予期しないエラーを発生させる
        struct UnexpectedError: Error {}
        mockRepository.searchByNameResult = .failure(.unknown(UnexpectedError()))
        
        // When & Then
        do {
            _ = try await useCase.execute(request: request)
            XCTFail("予期しないエラーでもハンドリングされるべき")
        } catch let error as SearchCreatorsByNameUseCaseError {
            XCTAssertEqual(error, .unknownError)
        } catch {
            XCTFail("SearchCreatorsByNameUseCaseErrorでラップされるべき: \(error)")
        }
    }
}