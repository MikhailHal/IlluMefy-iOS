//
//  OperatorMessageRepository.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation

/// 運営メッセージリポジトリ
final class OperatorMessageRepository: OperatorMessageRepositoryProtocol {
    
    // MARK: - In-Memory Cache
    private var cachedMessage: OperatorMessage?
    
    // MARK: - Initialization
    init() {
        // メモリキャッシュのみ、初期値はnil
    }
    
    // MARK: - OperatorMessageRepositoryProtocol
    
    func fetchOperatorMessage() async throws -> OperatorMessage? {
        // 現在はモックデータを返す（将来的にはAPI呼び出し）
        // 1秒の遅延をシミュレート
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let mockMessage = OperatorMessage(
            title: "🚀 新機能開発のお知らせ",
            content: "いつもIlluMefyをご利用いただき、ありがとうございます！現在、検索機能やお気に入り機能などの新機能を鋭意開発中です。皆様にとってより便利なアプリになるよう、チーム一丸となって取り組んでおります。今しばらくお待ちください！",
            updatedAt: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            isNew: true
        )
        
        // 取得したメッセージをキャッシュに保存
        cacheOperatorMessage(mockMessage)
        
        return mockMessage
    }
    
    func getCachedOperatorMessage() -> OperatorMessage? {
        return cachedMessage
    }
    
    func cacheOperatorMessage(_ message: OperatorMessage?) {
        cachedMessage = message
    }
    
    func clearCache() {
        cachedMessage = nil
    }
}