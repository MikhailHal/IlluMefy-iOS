//
//  AccountView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import SwiftUI

struct AccountView: View {
    @StateObject private var viewModel = DependencyContainer.shared.resolve(AccountViewModel.self)!
    @State private var showingComingSoonAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景
                Asset.Color.Application.Background.backgroundPrimary.swiftUIColor
                    .ignoresSafeArea()
                
                // メインコンテンツ
                Group {
                    switch viewModel.state {
                    case .idle, .loading:
                        loadingView
                    case .loaded(let userInfo):
                        contentView(userInfo: userInfo)
                    case .error(let title, let message):
                        errorView(title: title, message: message)
                    }
                }
            }
            .navigationTitle(L10n.account)
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadUserInfo()
            }
            .alert(L10n.comingSoon, isPresented: $showingComingSoonAlert) {
                Button(L10n.ok) { }
            } message: {
                Text(L10n.comingSoonMessage)
            }
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: Spacing.componentGrouping) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(Asset.Color.Application.accent.swiftUIColor)
            
            Text(L10n.loading)
                .font(.subheadline)
                .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor)
        }
    }
    
    // MARK: - Content View (Netflix-style Dashboard)
    private func contentView(userInfo: UserInfo) -> some View {
        ScrollView {
            VStack(spacing: Spacing.unrelatedComponentDivider) {
                // アクティビティカードセクション
                activityCardsSection()
                
                // アカウント情報カード
                accountInfoSection(userInfo: userInfo)
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
            .padding(.top, Spacing.componentGrouping)
        }
        .background(Asset.Color.Application.Background.backgroundPrimary.swiftUIColor)
    }
    
    // MARK: - Error View
    private func errorView(title: String, message: String) -> some View {
        VStack(spacing: Spacing.componentGrouping) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(Asset.Color.Application.accent.swiftUIColor)
            
            Text(title)
                .font(.headline)
                .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor)
                .multilineTextAlignment(.center)
            
            Button(L10n.retry) {
                Task {
                    await viewModel.loadUserInfo()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(Asset.Color.Application.accent.swiftUIColor)
        }
        .padding(Spacing.screenEdgePadding)
    }
    
    
    // MARK: - Activity Cards Section
    private func activityCardsSection() -> some View {
        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
            Text("アクティビティ")
                .font(.system(.title2, design: .rounded, weight: .semibold))
                .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
            
            VStack(spacing: 0) {
                activityCard(
                    icon: "tag",
                    title: L10n.tagApplicationHistory,
                    subtitle: "申請したタグの審査状況を確認",
                    action: { showingComingSoonAlert = true },
                    isDisabled: true,
                    badgeCount: 3
                )
                
                Divider()
                    .background(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.15))
                    .padding(.leading, Spacing.screenEdgePadding + 32 + Spacing.componentGrouping)
                
                activityCard(
                    icon: "pencil",
                    title: L10n.profileCorrectionHistory,
                    subtitle: "送信した修正依頼の進捗状況",
                    action: { showingComingSoonAlert = true },
                    isDisabled: true,
                    badgeCount: 1
                )
                
                Divider()
                    .background(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.15))
                    .padding(.leading, Spacing.screenEdgePadding + 32 + Spacing.componentGrouping)
                
                activityCard(
                    icon: "heart",
                    title: L10n.favoriteHistory,
                    subtitle: "お気に入りしたクリエイターの履歴",
                    action: { showingComingSoonAlert = true },
                    isDisabled: true
                )
            }
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(Asset.Color.Application.textPrimary.swiftUIColor.opacity(0.02))
                    .stroke(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.08), lineWidth: 1)
            )
        }
    }
    
    private func activityCard(icon: String, title: String, subtitle: String, action: @escaping () -> Void, isDisabled: Bool = false, badgeCount: Int? = nil) -> some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: Spacing.componentGrouping) {
                // アイコン背景（設定画面と同じサイズ）
                ZStack {
                    Circle()
                        .fill(Asset.Color.Application.accent.swiftUIColor.opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isDisabled ? Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.5) : Asset.Color.Application.accent.swiftUIColor)
                }
                .padding(.top, 2)
                
                // タイトルとサブタイトル
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.system(.title3, design: .default, weight: .medium))
                            .foregroundColor(isDisabled ? Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.5) : Asset.Color.Application.textPrimary.swiftUIColor)
                            .multilineTextAlignment(.leading)
                        
                        if let badgeCount = badgeCount, badgeCount > 0 {
                            ZStack {
                                Circle()
                                    .fill(Asset.Color.Application.accent.swiftUIColor)
                                    .frame(width: 20, height: 20)
                                
                                Text("\(badgeCount)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Text(subtitle)
                        .font(.system(.subheadline, design: .default, weight: .regular))
                        .foregroundColor(isDisabled ? Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.4) : Asset.Color.Application.textSecondary.swiftUIColor)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                // 矢印（設定画面と同じスタイル）
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.6))
                    .padding(.top, 12)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, Spacing.screenEdgePadding)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.7 : 1.0)
    }
    
    // MARK: - Account Info Section
    private func accountInfoSection(userInfo: UserInfo) -> some View {
        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
            Text("アカウント情報")
                .font(.system(.title2, design: .rounded, weight: .semibold))
                .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
            
            VStack(spacing: 0) {
                accountInfoRow(
                    icon: "phone",
                    label: L10n.phoneNumber,
                    value: userInfo.maskedPhoneNumber
                )
                
                Divider()
                    .background(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.15))
                    .padding(.leading, Spacing.screenEdgePadding + 32 + Spacing.componentGrouping)
                
                accountInfoRow(
                    icon: "calendar",
                    label: L10n.registrationDate,
                    value: userInfo.formattedRegistrationDate
                )
                
                Divider()
                    .background(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.15))
                    .padding(.leading, Spacing.screenEdgePadding + 32 + Spacing.componentGrouping)
                
                accountInfoRow(
                    icon: "person.text.rectangle",
                    label: L10n.userID,
                    value: String(userInfo.userId.prefix(12)) + "..."
                )
            }
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(Asset.Color.Application.textPrimary.swiftUIColor.opacity(0.02))
                    .stroke(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.08), lineWidth: 1)
            )
        }
    }
    
    private func accountInfoRow(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: Spacing.componentGrouping) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor)
                .frame(width: 32, height: 32)
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(.title3, design: .default, weight: .medium))
                    .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
                
                Text(value)
                    .font(.system(.subheadline, design: .default, weight: .regular))
                    .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor)
            }
            
            Spacer()
        }
        .padding(.vertical, 20)
        .padding(.horizontal, Spacing.screenEdgePadding)
    }
    
}

#Preview {
    AccountView()
}
