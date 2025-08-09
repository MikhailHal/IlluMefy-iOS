//
//  DevelopmentTabView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/09.
//

import SwiftUI
struct DevelopmentTabView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.unrelatedComponentDivider) {
                developing
                planning
            }.padding(Spacing.screenEdgePadding)
        }
    }
    
    private var developing: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            Text("🚀開発中")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("・プッシュ通知機能（v1.3.0で実装予定）\n・検索結果の並び替え機能\n・お気に入りフォルダ機能\n・クリエイター比較機能\n・APIレスポンス速度改善")
                .multilineTextAlignment(.leading)
                .font(.body)
        }.frame(maxWidth: .infinity)
    }
    
    private var planning: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            Text("🗓️予定")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("・ダークモード完全対応（v1.4.0）\n・iPad対応の最適化\n・Android版の開発検討\n・Web版ダッシュボード\n・多言語対応（英語、中国語等）")
                .multilineTextAlignment(.leading)
                .font(.body)
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    DevelopmentTabView()
}
