//
//  MoreView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/06.
//

import SwiftUI
import Shimmer

enum MoreTab: CaseIterable {
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

struct MoreView: View {
    @State private var selectedTab: MoreTab = .announcements
    
    var body: some View {
        ZStack {
            background
            
            VStack(spacing: Spacing.unrelatedComponentDivider) {
                summary
                tabBar
                
                TabView(selection: $selectedTab) {
                    NotificationTabView()
                        .tag(MoreTab.announcements)
                    
                    DevelopmentTabView()
                        .tag(MoreTab.development)
                    
                    BugTabView()
                        .tag(MoreTab.bugs)
                    
                    SettingTabView()
                        .tag(MoreTab.settings)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
    }
    
    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(MoreTab.allCases, id: \.self) { tab in
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
                Text(L10n.More.title)
                    .font(.system(size: Typography.titleMedium, weight: .bold))
                    .foregroundColor(Asset.Color.HomeSection.homeSectionTitle.swiftUIColor)
                Text(L10n.More.summary)
                    .font(.system(size: Typography.bodyRegular, weight: .bold))
                    .foregroundColor(Asset.Color.HomeSection.homeSectionTitle.swiftUIColor)
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
            .padding(.bottom, Spacing.componentGrouping)
        }
    }
}

#Preview {
    MoreView()
}
