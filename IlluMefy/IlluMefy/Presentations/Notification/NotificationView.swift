//
//  NotificationView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/06.
//

import SwiftUI
import Shimmer

enum NotificationTab: CaseIterable {
    case announcements
    case development
    case bugs
    case settings
    
    var title: String {
        switch self {
        case .announcements: return "お知らせ"
        case .development: return "開発状況"
        case .bugs: return "不具合"
        case .settings: return "その他"
        }
    }
    
    var icon: String {
        switch self {
        case .announcements: return "megaphone"
        case .development: return "hammer"
        case .bugs: return "ladybug"
        case .settings: return "gearshape"
        }
    }
}

struct NotificationView: View {
    @State private var selectedTab: NotificationTab = .announcements
    
    var body: some View {
        ZStack {
            background
            
            VStack(spacing: Spacing.unrelatedComponentDivider) {
                summary
                tabBar
                
                TabView(selection: $selectedTab) {
                    AnnouncementTabView()
                        .tag(NotificationTab.announcements)
                    
                    DevelopmentTabView()
                        .tag(NotificationTab.development)
                    
                    BugTabView()
                        .tag(NotificationTab.bugs)
                    
                    SettingsTabView()
                        .tag(NotificationTab.settings)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
    }
    
    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(NotificationTab.allCases, id: \.self) { tab in
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    selectedTab = tab
                }, label: {
                    VStack(spacing: 8) {
                        Text(tab.title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(selectedTab == tab ? .primary : .secondary.opacity(0.6))
                        
                        // アンダーライン
                        Rectangle()
                            .frame(width: 30, height: 2)
                            .foregroundColor(selectedTab == tab ? .primary : .clear)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }).animation(.easeInOut(duration: 0.2), value: selectedTab)
            }
        }
        .background(Color.clear)
    }
    
    private var background: some View {
        ZStack {
            AnimatedGradientBackground()
            FloatingParticlesView()
        }
    }
    
    private var summary: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            VStack(spacing: Spacing.relatedComponentDivider) {
                Text(L10n.Notification.title)
                    .font(.system(size: Typography.titleMedium, weight: .bold))
                    .foregroundColor(Asset.Color.HomeSection.homeSectionTitle.swiftUIColor)
                Text(L10n.Notification.summary)
                    .font(.system(size: Typography.bodyRegular, weight: .bold))
                    .foregroundColor(Asset.Color.HomeSection.homeSectionTitle.swiftUIColor)
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
            .padding(.bottom, Spacing.componentGrouping)
        }
    }
}

// MARK: - Tab Content Views

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

struct DevelopmentTabView: View {
    var body: some View {
        Text("開発状況タブ - Hello World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct BugTabView: View {
    var body: some View {
        Text("不具合タブ - Hello World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SettingsTabView: View {
    var body: some View {
        Text("その他タブ - Hello World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NotificationView()
}
