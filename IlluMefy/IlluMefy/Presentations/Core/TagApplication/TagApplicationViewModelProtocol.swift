//
//  TagApplicationViewModelProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// タグ申請ViewModel プロトコル
protocol TagApplicationViewModelProtocol: ObservableObject {
    // MARK: - Properties
    
    /// タグ名
    var tagName: String { get set }
    
    /// 申請理由
    var reason: String { get set }
    
    /// 申請タイプ
    var applicationType: TagApplicationRequest.ApplicationType { get set }
    
    /// 申請中フラグ
    var isSubmitting: Bool { get }
    
    /// 結果表示フラグ
    var showingResult: Bool { get set }
    
    /// 成功フラグ
    var isSuccess: Bool { get }
    
    /// 結果メッセージ
    var resultMessage: String { get }
    
    /// 申請ボタンの有効性
    var isSubmitEnabled: Bool { get }
    
    /// タグ名の文字数
    var tagNameCharacterCount: String { get }
    
    /// 理由の文字数
    var reasonCharacterCount: String { get }
    
    // MARK: - Methods
    
    /// 申請を送信
    func submitApplication() async
    
    /// タグ名のバリデーション
    func validateTagName(_ value: String) -> String
    
    /// 理由のバリデーション
    func validateReason(_ value: String) -> String
}