//
//  SettingView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import SwiftUI

struct SettingTabView: View {
    @State private var viewModel = DependencyContainer.shared.resolve(SettingTabViewModel.self)!
    @EnvironmentObject private var router: IlluMefyAppRouter
    
    var body: some View {
        contentView()
            .onChange(of: viewModel.logoutSuccess) { _, newValue in
                if newValue {
                    viewModel.logoutSuccess = false
                    router.navigateToRoot()
                }
            }
            .onChange(of: viewModel.deleteSuccess) { _, newValue in
                if newValue {
                    viewModel.deleteSuccess = false
                    router.navigateToRoot()
                }
            }
    }
    
    // MARK: - Content View
    private func contentView() -> some View {
        ScrollView {
            VStack(spacing: Spacing.relatedComponentDivider) {
                // 問い合わせ
                inquiry
                
                Spacer().frame(height: 20)
                
                // プライバシーポリシー
                useOfTerms
                
                Spacer().frame(height: 20)
                
                // アカウント
                account
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
            .padding(.top, Spacing.componentGrouping)
        }
    }
    
    private func listItem(name: String, onClick: @escaping () -> Void, icon: IconType) -> some View {
        Button(action: onClick) {
            HStack {
                Text(name)
                    .font(.headline)
                    .foregroundColor(Asset.Color.Button.buttonForeground.swiftUIColor)
                Spacer()
                Image(systemName: icon.rawValue)
                    .foregroundColor(Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor)
            }
        }
    }
    
    private var inquiry: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            Text(L10n.Settings.sectionInquiry)
                .font(.subheadline)
                .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor.opacity(0.8))
            Spacer().frame(height: 1)
            listItem(name: L10n.Settings.bugReport,
                     onClick: {
                if let url = URL(string: "https://forms.gle/QE7jDyVwGKsP6J9x8") {
                    UIApplication.shared.open(url)
                }
            },
                     icon: .externalLink)
            Divider()
            listItem(name: L10n.Settings.featureRequest,
                     onClick: {
                if let url = URL(string: "https://forms.gle/d1HTqbukaUGju4AP8") {
                    UIApplication.shared.open(url)
                }
            },
                     icon: .externalLink)
            Divider()
            listItem(name: L10n.Settings.creatorSubmission,
                     onClick: {
                if let url = URL(string: "https://forms.gle/Gn8Q79VCL8kTNAe36") {
                    UIApplication.shared.open(url)
                }
            },
                     icon: .externalLink)
            Divider()
        }
    }
    
    private var useOfTerms: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            Text(L10n.Settings.sectionTerms)
                .font(.subheadline)
                .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor.opacity(0.8))
            Spacer().frame(height: 1)
            listItem(name: L10n.Settings.termsOfService,
                     onClick: {
                if let url = URL(string: "https://lying-rate-213.notion.site/IlluMefy-1fee5e0485cb80208497c1f1cca7e10b") {
                    UIApplication.shared.open(url)
                }
            },
                     icon: .externalLink)
            Divider()
                .frame(height: 2)
                .background(.gray.opacity(0.2))
        }
    }
    
    private var account: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            Text(L10n.Settings.sectionAccount)
                .font(.subheadline)
                .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor.opacity(0.8))
            listItem(name: L10n.Settings.logout,
                     onClick: {
                router.showConfirmationDialog(
                    title: L10n.ConfirmationDialog.Logout.title,
                    message: L10n.ConfirmationDialog.Logout.message, onClickOk: {
                        Task {
                            await viewModel.logout()
                        }
                    },
                    onClickCancel: {}
                )
            },
                     icon: .chepron)
            Divider()
                .frame(height: 2)
                .background(.gray.opacity(0.2))
            listItem(name: L10n.Settings.deleteAccount,
                     onClick: {
                router.showConfirmationDialog(
                    title: L10n.ConfirmationDialog.DeleteAccount.title,
                    message: L10n.ConfirmationDialog.DeleteAccount.message, onClickOk: {
                        Task {
                            await viewModel.deleteAccount()
                        }
                    },
                    onClickCancel: {}
                )
            },
                     icon: .chepron)
        }
    }
    
    /// リストアイテムのトレイルアイコンで使用する種類
    private enum IconType: String {
        case chepron = "chevron.right"
        case externalLink = "arrow.up.right.square"
    }
}

#Preview {
    SettingTabView()
}
