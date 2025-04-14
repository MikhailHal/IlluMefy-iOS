//
//  GroupDetailViewModelProtocol.swift
//  Nimli
//
//  Created by Haruto Islay on 2024/04/14.
//

import Foundation

/// グループ詳細画面のViewModelプロトコル
///
/// グループ情報の表示、編集、メンバー管理などの機能を定義します。
/// このプロトコルに準拠するViewModelは、グループ詳細画面で必要な
/// データと操作を提供します。
///
/// - Note: このプロトコルは`ObservableObject`を継承しており、
///   SwiftUIのビューとデータバインディングが可能です。
///
/// - Author: Haruto Islay
/// - Version: 1.0.0
protocol GroupDetailViewModelProtocol: ObservableObject {
    /// グループの名前
    var groupName: String { get set }
    
    /// グループの作成日時
    var createdAt: String { get set }
    
    /// 現在のユーザーが管理者かどうか
    var isCurrentUserAdmin: Bool { get set }
    
    /// グループ名の編集モードかどうか
    var isEditingGroupName: Bool { get set }
    
    /// 編集中のグループ名
    var editingGroupName: String { get set }
    
    /// グループのメンバー一覧
    var members: [GroupDetailViewModel.Member] { get set }
    
    /// グループ名の編集を開始します
    ///
    /// このメソッドを呼び出すと、現在のグループ名が編集用の変数にコピーされ、
    /// 編集モードが有効になります。
    func startEditingGroupName()
    
    /// グループ名の編集を保存します
    ///
    /// 編集中のグループ名が空でない場合、新しいグループ名として保存します。
    /// 編集モードは無効になります。
    func saveGroupName()
    
    /// グループ名の編集をキャンセルします
    ///
    /// 編集モードを無効にし、編集中のグループ名をクリアします。
    func cancelEditingGroupName()
    
    /// メンバーを招待します
    ///
    /// グループに新しいメンバーを招待するための処理を実行します。
    /// 具体的な招待方法は実装クラスで定義されます。
    func inviteMember()
    
    /// グループから退出します
    ///
    /// 現在のユーザーをグループから退出させる処理を実行します。
    /// 管理者の場合は、別の管理者がいる場合のみ退出可能です。
    func leaveGroup()
} 