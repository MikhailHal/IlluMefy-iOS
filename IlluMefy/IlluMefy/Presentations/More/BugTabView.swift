//
//  BugTabView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/09.
//

import SwiftUI

struct BugTabView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.unrelatedComponentDivider) {
                fixed
                fixing
                planning
            }.padding(Spacing.screenEdgePadding)
        }
    }
    
    private var fixed: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            Text(L10n.BugTab.fixed)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("・iOS17でのスクロール問題を修正（v1.2.0）\n・特定の画像が表示されない問題を解決\n・ログイン時の安定性を向上\n・タグ削除時の表示不具合を修正\n・お気に入り機能のクラッシュ問題を解決")
                .multilineTextAlignment(.leading)
                .font(.body)
        }.frame(maxWidth: .infinity)
    }
    
    private var fixing: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            Text(L10n.BugTab.fixing)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("・検索結果の読み込みが遅い問題\n・一部の機種でキーボードが正常に閉じない問題\n・タブ切り替え時のメモリリーク調査中\n・プロフィール画像のキャッシュ問題")
                .multilineTextAlignment(.leading)
                .font(.body)
        }.frame(maxWidth: .infinity)
    }
    
    private var planning: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            Text(L10n.BugTab.planned)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("・ダークモード時の一部文字が見にくい問題\n・横画面時のレイアウト崩れ\n・大量データ表示時のパフォーマンス改善\n・オフライン時のエラーハンドリング改善\n・バックグラウンド復帰時の状態復元")
                .multilineTextAlignment(.leading)
                .font(.body)
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    BugTabView()
}
