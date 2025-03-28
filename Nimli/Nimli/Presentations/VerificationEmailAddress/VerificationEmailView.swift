//
//  VerificationEmailView.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/25.
//

import SwiftUI

struct VerificationEmailView: View {
    @StateObject private var viewModel = DependencyContainer.shared.resolve(VerificationEmailAddressViewModel.self)!
    @EnvironmentObject var router: NimliAppRouter
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.screenBackground
        appearance.titleTextAttributes = [
            .font: UIFont.preferredFont(forTextStyle: .title3),
            .foregroundColor: UIColor.textForeground
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        ZStack {
            VStack {
                Text("STEP：2 / 3")
                    .foregroundColor(Color.textForeground)
                    .bold()
                    .font(.title)
                Text("受信メールを確認しましょう！")
                    .foregroundColor(Color.textForeground)
                    .font(.title3)
                    .bold()
                    .padding(
                        EdgeInsets(
                            top: Spacing.unrelatedComponentDivider,
                            leading: Spacing.none,
                            bottom: Spacing.none,
                            trailing: Spacing.none
                        )
                    )
                NimliPlainTextField(
                    text: $viewModel.authenticationCode,
                    title: "認証コード",
                    placeHolder: "認証コードを入力"
                )
                .padding(
                    EdgeInsets(
                        top: Spacing.unrelatedComponentDivider,
                        leading: Spacing.none,
                        bottom: Spacing.none,
                        trailing: Spacing.none
                    )
                )
                NimliButton(
                    text: "認証",
                    isEnabled: viewModel.isEnableAuthenticationButton,
                    onClick: {
                        Task {
                            router.showLoading()
                            await viewModel.verificationEmailAddress()
                            router.hideLoading()
                        }
                    }
                ).padding(EdgeInsets(
                    top: Spacing.unrelatedComponentDivider,
                    leading: Spacing.none,
                    bottom: Spacing.none,
                    trailing: Spacing.none))
                Spacer()
            }
            .padding(Spacing.screenEdgePadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.screenBackground)
            .navigationTitle("会員登録")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.keyboard, edges: .all)
            .alert("アカウント登録失敗", isPresented: $viewModel.isShowErrorDialog) {
                Button("OK") { viewModel.isShowErrorDialog = false }
            } message: {
                Text(viewModel.errorMessage)
            }
            .alert("アカウント登録成功", isPresented: $viewModel.isShowNotificationDialog) {
                Button("OK") { viewModel.isShowNotificationDialog = false }
            } message: {
                Text("新規アカウントの仮登録に成功しました。\n次画面にてメールアドレスの認証をしてください。")
            }
        }
    }
}

#Preview {
    VerificationEmailView().environmentObject(NimliAppRouter())
}
