//
//  SearchHistoryRepositorySpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/15.
//

import XCTest
@testable import IlluMefy

final class SearchHistoryRepositorySpec: XCTestCase {
    
    private var repository: SearchHistoryRepository!
    private var mockUserDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        // テスト用のUserDefaultsを作成
        mockUserDefaults = UserDefaults(suiteName: "test")!
        repository = SearchHistoryRepository(userDefaults: mockUserDefaults)
    }
    
    override func tearDown() {
        // テストデータをクリア
        mockUserDefaults.removeObject(forKey: "search_history")
        repository = nil
        mockUserDefaults = nil
        super.tearDown()
    }
    
    // MARK: - 検索履歴保存のテスト
    
    func test_検索履歴の保存() async throws {
        // When
        try await repository.saveSearchHistory(query: "ゲーム")
        
        // Then
        let history = try await repository.getSearchHistory(limit: 10)
        XCTAssertEqual(history, ["ゲーム"])
    }
    
    func test_複数の検索履歴保存() async throws {
        // When
        try await repository.saveSearchHistory(query: "ゲーム")
        try await repository.saveSearchHistory(query: "VTuber")
        try await repository.saveSearchHistory(query: "料理")
        
        // Then
        let history = try await repository.getSearchHistory(limit: 10)
        XCTAssertEqual(history, ["料理", "VTuber", "ゲーム"]) // 新しい順
    }
    
    func test_同じクエリの重複保存時は最新に移動() async throws {
        // Given
        try await repository.saveSearchHistory(query: "ゲーム")
        try await repository.saveSearchHistory(query: "VTuber")
        try await repository.saveSearchHistory(query: "料理")
        
        // When - 既存のクエリを再保存
        try await repository.saveSearchHistory(query: "ゲーム")
        
        // Then
        let history = try await repository.getSearchHistory(limit: 10)
        XCTAssertEqual(history, ["ゲーム", "料理", "VTuber"]) // ゲームが最新に移動
    }
    
    func test_上限を超えた場合古いものが削除される() async throws {
        // Given - 10個（上限）の履歴を保存
        for i in 1...10 {
            try await repository.saveSearchHistory(query: "クエリ\(i)")
        }
        
        // When - 11個目を保存
        try await repository.saveSearchHistory(query: "新しいクエリ")
        
        // Then - 最古のものが削除される
        let history = try await repository.getSearchHistory(limit: 15)
        XCTAssertEqual(history.count, 10)
        XCTAssertEqual(history.first, "新しいクエリ")
        XCTAssertFalse(history.contains("クエリ1")) // 最古のものが削除
    }
    
    func test_空白のクエリは保存されない() async throws {
        // When
        try await repository.saveSearchHistory(query: "")
        try await repository.saveSearchHistory(query: "   ")
        try await repository.saveSearchHistory(query: "\t\n")
        
        // Then
        let history = try await repository.getSearchHistory(limit: 10)
        XCTAssertTrue(history.isEmpty)
    }
    
    func test_前後の空白が除去されて保存される() async throws {
        // When
        try await repository.saveSearchHistory(query: "  ゲーム  ")
        
        // Then
        let history = try await repository.getSearchHistory(limit: 10)
        XCTAssertEqual(history, ["ゲーム"])
    }
    
    // MARK: - 検索履歴取得のテスト
    
    func test_空の履歴取得() async throws {
        // When
        let history = try await repository.getSearchHistory(limit: 10)
        
        // Then
        XCTAssertTrue(history.isEmpty)
    }
    
    func test_制限数での履歴取得() async throws {
        // Given
        for i in 1...10 {
            try await repository.saveSearchHistory(query: "クエリ\(i)")
        }
        
        // When
        let history = try await repository.getSearchHistory(limit: 5)
        
        // Then
        XCTAssertEqual(history.count, 5)
        XCTAssertEqual(history, ["クエリ10", "クエリ9", "クエリ8", "クエリ7", "クエリ6"])
    }
    
    func test_制限数が履歴数より多い場合() async throws {
        // Given
        try await repository.saveSearchHistory(query: "クエリ1")
        try await repository.saveSearchHistory(query: "クエリ2")
        
        // When
        let history = try await repository.getSearchHistory(limit: 10)
        
        // Then
        XCTAssertEqual(history.count, 2)
        XCTAssertEqual(history, ["クエリ2", "クエリ1"])
    }
    
    // MARK: - 検索履歴削除のテスト
    
    func test_特定の履歴削除() async throws {
        // Given
        try await repository.saveSearchHistory(query: "ゲーム")
        try await repository.saveSearchHistory(query: "VTuber")
        try await repository.saveSearchHistory(query: "料理")
        
        // When
        try await repository.deleteSearchHistory(query: "VTuber")
        
        // Then
        let history = try await repository.getSearchHistory(limit: 10)
        XCTAssertEqual(history, ["料理", "ゲーム"])
        XCTAssertFalse(history.contains("VTuber"))
    }
    
    func test_存在しない履歴の削除は何もしない() async throws {
        // Given
        try await repository.saveSearchHistory(query: "ゲーム")
        
        // When
        try await repository.deleteSearchHistory(query: "存在しないクエリ")
        
        // Then
        let history = try await repository.getSearchHistory(limit: 10)
        XCTAssertEqual(history, ["ゲーム"])
    }
    
    func test_全履歴削除() async throws {
        // Given
        try await repository.saveSearchHistory(query: "ゲーム")
        try await repository.saveSearchHistory(query: "VTuber")
        try await repository.saveSearchHistory(query: "料理")
        
        // When
        try await repository.clearAllSearchHistory()
        
        // Then
        let history = try await repository.getSearchHistory(limit: 10)
        XCTAssertTrue(history.isEmpty)
    }
    
    // MARK: - UserDefaultsとの統合テスト
    
    func test_UserDefaultsに正しく保存される() async throws {
        // When
        try await repository.saveSearchHistory(query: "テスト")
        
        // Then
        let savedArray = mockUserDefaults.stringArray(forKey: "search_history")
        XCTAssertEqual(savedArray, ["テスト"])
    }
    
    func test_UserDefaultsから正しく読み込める() async throws {
        // Given
        mockUserDefaults.set(["既存1", "既存2"], forKey: "search_history")
        
        // When
        let history = try await repository.getSearchHistory(limit: 10)
        
        // Then
        XCTAssertEqual(history, ["既存1", "既存2"])
    }
    
    func test_破損したUserDefaultsデータでもエラーにならない() async throws {
        // Given - 不正なデータを設定
        mockUserDefaults.set("不正なデータ", forKey: "search_history")
        
        // When
        let history = try await repository.getSearchHistory(limit: 10)
        
        // Then - 空配列が返される
        XCTAssertTrue(history.isEmpty)
    }
}