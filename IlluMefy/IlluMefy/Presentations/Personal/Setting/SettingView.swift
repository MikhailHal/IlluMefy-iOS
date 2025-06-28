//
//  SettingView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var viewModel = DependencyContainer.shared.resolve(SettingViewModel.self)!
    @EnvironmentObject private var router: IlluMefyAppRouter
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
            .onChange(of: viewModel.logoutSuccess) { _, success in
                if success {
                    // ログアウト成功時にルートに戻って認証状態をリセット
                    router.navigateToRoot()
                    // ParentViewの再評価を促すためのステップ
                    NotificationCenter.default.post(name: NSNotification.Name("AuthenticationStatusChanged"), object: nil)
                }
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
    
    // MARK: - Operator Message (Netflix-style Minimal)
    private func operatorMessageCard(message: OperatorMessage) -> some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            // ヘッダー - ミニマルで洗練された
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        Text(L10n.operatorMessage)
                            .font(.system(.caption, design: .default, weight: .medium))
                            .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.8))
                            .textCase(.uppercase)
                            .tracking(0.5)
                        
                        // NEWインジケーター - ミニマル
                        if message.isNew {
                            Circle()
                                .fill(Asset.Color.Application.accent.swiftUIColor)
                                .frame(width: 6, height: 6)
                        }
                    }
                    
                    // メッセージタイトル - 主役
                    Text(message.title)
                        .font(.system(.title2, design: .default, weight: .semibold))
                        .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .allowsTightening(true)
                        .minimumScaleFactor(0.8)
                }
                
                Spacer()
                
                // 更新日時 - 右上に控えめに
                Text(message.formattedUpdatedAt)
                    .font(.system(.caption2, design: .default, weight: .regular))
                    .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.6))
            }
            
            // メッセージ内容 - 読みやすく
            Text(message.content)
                .font(.system(.subheadline, design: .default, weight: .regular))
                .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor)
                .lineSpacing(2)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
        }
        .padding(Spacing.screenEdgePadding)
        .background(
            // サブトルな背景
            RoundedRectangle(cornerRadius: 12)
                .fill(Asset.Color.Application.textPrimary.swiftUIColor.opacity(0.02))
                .stroke(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.08), lineWidth: 1)
        )
        // 新しいメッセージのみわずかに強調
        .scaleEffect(message.isNew ? 1.0 : 1.0)
        .opacity(message.isNew ? 1.0 : 0.95)
        .animation(.easeInOut(duration: 0.3), value: message.isNew)
    }
    
    // MARK: - Settings List (Netflix-style)
    private func settingsListView() -> some View {
        VStack(spacing: 0) {
            settingRow(
                icon: "bell",
                title: L10n.notificationSettings,
                subtitle: L10n.notificationSettingsDescription,
                action: { showingComingSoonAlert = true },
                isDisabled: true
            )
            
            settingRowDivider()
            
            settingRow(
                icon: "doc.text",
                title: L10n.termsOfService,
                subtitle: L10n.termsOfServiceDescription,
                action: { viewModel.openTermsOfService() }
            )
            
            settingRowDivider()
            
            settingRow(
                icon: "info.circle",
                title: L10n.appInformation,
                subtitle: L10n.appInformationDescription,
                action: { showingComingSoonAlert = true },
                isDisabled: true
            )
            
            settingRowDivider()
            
            settingRow(
                icon: "questionmark.circle",
                title: L10n.contactSupport,
                subtitle: L10n.contactSupportDescription,
                action: { 
                    router.navigate(to: .contactSupport)
                }
            )
            
            settingRowDivider()
            
            // ログアウトボタン
            Button(action: {
                Task {
                    await viewModel.logout()
                }
            }, label: {
                HStack(spacing: Spacing.componentGrouping) {
                    if viewModel.isLoggingOut {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.red)
                            .frame(width: 24, height: 24)
                    } else {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.red)
                    }
                    
                    Text(viewModel.isLoggingOut ? L10n.Settings.loggingOut : L10n.Settings.logout)
                        .font(.system(.title3, design: .default, weight: .medium))
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .padding(.horizontal, Spacing.screenEdgePadding)
            })
            .buttonStyle(.plain)
            .disabled(viewModel.isLoggingOut)
        }
    }
    
    // MARK: - Setting Row (Netflix-style)
    private func settingRow(icon: String, title: String, subtitle: String, action: @escaping () -> Void, isDisabled: Bool = false) -> some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: Spacing.componentGrouping) {
                // アイコン（Netflix風の適切なサイズ）
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isDisabled ? Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.4) : Asset.Color.Application.textSecondary.swiftUIColor)
                    .frame(width: 32, height: 32)
                    .padding(.top, 2)
                
                // タイトルとサブタイトル
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(.title3, design: .default, weight: .medium))
                        .foregroundColor(isDisabled ? Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.5) : Asset.Color.Application.textPrimary.swiftUIColor)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.system(.subheadline, design: .default, weight: .regular))
                        .foregroundColor(isDisabled ? Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.4) : Asset.Color.Application.textSecondary.swiftUIColor)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                // 矢印（Netflix風 - 適切なサイズ）
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
    }
    
    // MARK: - Setting Row Divider
    private func settingRowDivider() -> some View {
        Divider()
            .background(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.15))
            .padding(.leading, Spacing.screenEdgePadding + 32 + Spacing.componentGrouping)
    }
}

#Preview {
    SettingView()
}
