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
    
    // MARK: - Content View
    private func contentView(userInfo: UserInfo) -> some View {
        List {
            // ユーザー情報セクション
            Section {
                userInfoSection(userInfo: userInfo)
            } header: {
                sectionHeader(L10n.userInformation, icon: "person.circle")
            }
            
            // アクティビティセクション
            Section {
                activitySection()
            } header: {
                sectionHeader(L10n.activity, icon: "list.clipboard")
            }
            
        }
        .listStyle(.insetGrouped)
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
                    await viewModel.loadUserInfo()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(Asset.Color.Application.accent.swiftUIColor)
        }
        .padding(Spacing.screenEdgePadding)
    }
    
    // MARK: - Section Header
    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: Spacing.componentGrouping) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Asset.Color.Application.accent.swiftUIColor)
            
            Text(title)
                .font(.headline)
                .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - User Info Section
    private func userInfoSection(userInfo: UserInfo) -> some View {
        VStack(spacing: Spacing.componentGrouping) {
            userInfoRow(
                icon: "phone",
                label: L10n.phoneNumber,
                value: userInfo.maskedPhoneNumber
            )
            
            userInfoRow(
                icon: "calendar",
                label: L10n.registrationDate,
                value: userInfo.formattedRegistrationDate
            )
            
            userInfoRow(
                icon: "person.text.rectangle",
                label: L10n.userID,
                value: String(userInfo.userId.prefix(12)) + "..."
            )
        }
        .padding(.vertical, Spacing.componentGrouping)
    }
    
    private func userInfoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: Spacing.componentGrouping) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Asset.Color.Application.accent.swiftUIColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor)
                
                Text(value)
                    .font(.body)
                    .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Activity Section
    private func activitySection() -> some View {
        VStack(spacing: 0) {
            menuRow(
                icon: "tag",
                title: L10n.tagApplicationHistory,
                action: { showingComingSoonAlert = true },
                isDisabled: true
            )
            
            Divider()
                .background(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.3))
            
            menuRow(
                icon: "pencil",
                title: L10n.profileCorrectionHistory,
                action: { showingComingSoonAlert = true },
                isDisabled: true
            )
        }
    }
    
    
    // MARK: - Menu Row
    private func menuRow(icon: String, title: String, action: @escaping () -> Void, isDisabled: Bool = false) -> some View {
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
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1.0)
    }
}

#Preview {
    AccountView()
}
