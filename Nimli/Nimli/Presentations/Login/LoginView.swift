//
//  LoginView.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/02.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = DependencyContainer.shared.resolve(LoginViewModel.self)!
    @EnvironmentObject var router: NimliAppRouter
    init() {
        configureNavigationBarAppearance()
    }
    
    private func configureNavigationBarAppearance() {
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
            LoginFormView(viewModel: viewModel, router: router)
                .padding(Spacing.screenEdgePadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.screenBackground)
                .navigationTitle("ログイン")
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea(.keyboard, edges: .all)
                .onAppear {
                    Task {
                        await viewModel.initializeStoedLoginAccountData()
                    }
                }
        }
        .alert("ログイン失敗", isPresented: $viewModel.isShowErrorDialog) {
            Button("OK") { viewModel.isShowErrorDialog = false }
        } message: {
            Text(viewModel.errorDialogMessage)
        }
        .alert("ログイン成功", isPresented: $viewModel.isShowNotificationDialog) {
            Button("OK") {
                viewModel.isShowNotificationDialog = false
                router.navigate(to: .emailVerification)
            }
        } message: {
            Text(viewModel.notificationDialogMessage)
        }
    }
}

private struct LoginFormView: View {
    @ObservedObject var viewModel: LoginViewModel
    var router: NimliAppRouter
    
    var body: some View {
        ScrollView {
            VStack {
                LogoHeaderView().padding(.bottom, Spacing.unrelatedComponentDivider)
                LoginInformationField(viewModel: viewModel)
                OptionView(viewModel: viewModel)
            }
            .padding(Spacing.cardEdgePadding)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardFillColorNormal)
            )
            
            NimliButton(
                text: "ログイン",
                isEnabled: true,
                onClick: {
                    Task {
                        router.showLoading()
                        await viewModel.login()
                        router.hideLoading()
                    }
                },
                leadingIcon: AnyView(
                    Image(systemName: "person.fill.checkmark")
                )
            )
        }
    }
}

private struct LoginInformationField: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            Text("ログイン情報")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, Spacing.componentGrouping)
                .foregroundColor(.textForeground)
            NimliPlainTextField(
                text: $viewModel.email,
                title: "メールアドレス",
                placeHolder: "メールアドレス",
                placeHolderColor: .cardFillColorNormal
            )

            NimliPlainTextField(
                text: $viewModel.password,
                title: "パスワード",
                placeHolder: "パスワード",
                placeHolderColor: .cardFillColorNormal
            )
            .padding(
                EdgeInsets(
                    top: Spacing.relatedComponentDivider,
                    leading: Spacing.none,
                    bottom: Spacing.none,
                    trailing: Spacing.none
                )
            )
        }
    }
}

private struct OptionView: View {
    @ObservedObject var viewModel: LoginViewModel
    var body: some View {
        Text("オプション")
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, Spacing.unrelatedComponentDivider)
            .foregroundColor(.textForeground)
        NimliCheckboxView(
            isChecked: $viewModel.isStoreLoginInformation,
            title: "ログイン情報を保存する"
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
        
}

#Preview {
    LoginView().environmentObject(NimliAppRouter())
}
