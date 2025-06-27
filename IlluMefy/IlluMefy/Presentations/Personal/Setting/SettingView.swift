//
//  SettingView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var viewModel = DependencyContainer.shared.resolve(SettingViewModel.self)!
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
                    case .loaded(let operatorMessage):
                        contentView(operatorMessage: operatorMessage)
                    case .error(let title, let message):
                        errorView(title: title, message: message)
                    }
                }
            }
            .navigationTitle(L10n.settings)
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadOperatorMessage()
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
    
    // MARK: - Content View
    private func contentView(operatorMessage: OperatorMessage?) -> some View {
        ScrollView {
            VStack(spacing: Spacing.unrelatedComponentDivider) {
                // 運営メッセージセクション（目立つデザイン）
                if let message = operatorMessage {
                    operatorMessageCard(message: message)
                }
                
                // 設定項目リスト
                settingsListView()
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
            .padding(.top, Spacing.componentGrouping)
        }
        .scrollContentBackground(.hidden)
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
                    await viewModel.loadOperatorMessage()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(Asset.Color.Application.accent.swiftUIColor)
        }
        .padding(Spacing.screenEdgePadding)
    }
    
    // MARK: - Operator Message Card (Prominent Design)
    private func operatorMessageCard(message: OperatorMessage) -> some View {
        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
            // ヘッダー部分
            HStack {
                HStack(spacing: Spacing.componentGrouping) {
                    Image(systemName: "megaphone.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(L10n.operatorMessage)
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // NEWバッジ
                if message.isNew {
                    Text("NEW")
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundColor(Asset.Color.Application.accent.swiftUIColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
            }
            
            // メッセージタイトル
            Text(message.title)
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(2)
            
            // メッセージ内容
            Text(message.content)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            // 更新日時
            HStack {
                Image(systemName: "clock")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                Text("\(L10n.lastUpdated): \(message.formattedUpdatedAt)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
            }
        }
        .padding(Spacing.relatedComponentDivider)
        .background(
            // グラデーション背景
            LinearGradient(
                colors: [
                    Asset.Color.Application.accent.swiftUIColor,
                    Asset.Color.Application.accent.swiftUIColor.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
        .shadow(
            color: Asset.Color.Application.accent.swiftUIColor.opacity(0.3),
            radius: Shadow.radiusLarge,
            y: Shadow.offsetYMedium
        )
        // 軽いパルスアニメーション
        .scaleEffect(message.isNew ? 1.02 : 1.0)
        .animation(
            message.isNew ? 
                .easeInOut(duration: 2.0).repeatForever(autoreverses: true) : 
                .none,
            value: message.isNew
        )
    }
    
    // MARK: - Settings List
    private func settingsListView() -> some View {
        VStack(spacing: 0) {
            IlluMefyCardNormal {
                VStack(spacing: 0) {
                    settingRow(
                        icon: "bell",
                        title: L10n.notificationSettings,
                        action: { showingComingSoonAlert = true },
                        isDisabled: true
                    )
                    
                    Divider()
                        .background(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.3))
                    
                    settingRow(
                        icon: "doc.text",
                        title: L10n.termsOfService,
                        action: { viewModel.openTermsOfService() }
                    )
                    
                    Divider()
                        .background(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.3))
                    
                    settingRow(
                        icon: "info.circle",
                        title: L10n.appInformation,
                        action: { showingComingSoonAlert = true },
                        isDisabled: true
                    )
                    
                    Divider()
                        .background(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.3))
                    
                    settingRow(
                        icon: "questionmark.circle",
                        title: L10n.contactSupport,
                        action: { showingComingSoonAlert = true },
                        isDisabled: true
                    )
                }
                .padding(.vertical, Spacing.componentGrouping)
            }
        }
    }
    
    // MARK: - Setting Row
    private func settingRow(icon: String, title: String, action: @escaping () -> Void, isDisabled: Bool = false) -> some View {
        Button(action: action) {
            HStack(spacing: Spacing.componentGrouping) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(isDisabled ? Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.5) : Asset.Color.Application.accent.swiftUIColor)
                    .frame(width: 24)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(isDisabled ? Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.5) : Asset.Color.Application.textPrimary.swiftUIColor)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isDisabled ? Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.3) : Asset.Color.Application.textSecondary.swiftUIColor)
            }
            .padding(.vertical, Spacing.componentGrouping)
            .padding(.horizontal, Spacing.relatedComponentDivider)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1.0)
    }
}

#Preview {
    SettingView()
}
