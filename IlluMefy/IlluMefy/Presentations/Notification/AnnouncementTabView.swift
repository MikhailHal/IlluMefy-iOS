//
//  AnnouncementTabView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/09.
//

import SwiftUI

struct AnnouncementTabView: View {
    @State private var isLoading = false
    @State private var content = """
IlluMefy v1.2.0をリリースしました！

新機能：
・タグ削除機能を追加
・検索フィルター機能を改善
・お気に入り機能の安定性向上
・パフォーマンスの大幅改善

不具合修正：
・iOS17でのスクロール問題を修正
・特定の画像が表示されない問題を解解決
・ログイン時の安定性を向上

今後の予定：
・プッシュ通知機能（v1.3で予定）
・ダークモード対応（検討中）
・iPad対応（検討中）

今後の予定：
・プッシュ通知機能（v1.3で予定）
・ダークモード対応（検討中）
・iPad対応（検討中）

いつもIlluMefyをご利用いただき、ありがとうございます。
今後ともよろしくお願いいたします！

運営チーム一同
"""
    
    var body: some View {
        ScrollView {
            if isLoading {
                loadingView
            } else {
                Text(content)
                    .font(.system(size: Typography.bodyRegular))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Spacing.screenEdgePadding)
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            ForEach(0..<8, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(Opacity.glow))
                    .frame(height: 16)
                    .shimmering()
            }
        }
        .padding(Spacing.screenEdgePadding)
    }
}
