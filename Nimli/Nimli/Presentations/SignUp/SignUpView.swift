//
//  SignUpView.swift
//  Nimli
//
//  Created by Haruto K. on 2025/02/12.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel(
        registrationAccountUseCase: RegisterAccountUseCase(
            repository: AccountRegistrationRepository())
        )
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
        NavigationView {
            VStack {
                Text("STEP：1 / 3")
                    .foregroundColor(Color.textForeground)
                    .bold()
                    .font(.title)
                Text("Welcome to Nimli!!")
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
                    text: $viewModel.email,
                    title: "メールアドレス",
                    placeHolder: "メールアドレス"
                )
                .padding(
                    EdgeInsets(
                        top: Spacing.unrelatedComponentDivider,
                        leading: Spacing.none,
                        bottom: Spacing.none,
                        trailing: Spacing.none
                    )
                )
                .onChange(of: viewModel.email) {
                    viewModel.onEmailDidChange()
                }
                NimliPlainTextField(
                    text: $viewModel.password,
                    title: "パスワード",
                    placeHolder: "パスワード"
                )
                .onChange(of: viewModel.password) {
                    viewModel.onPasswordDidChange()
                }
                .padding(
                    EdgeInsets(
                        top: Spacing.relatedComponentDivider,
                        leading: Spacing.none,
                        bottom: Spacing.none,
                        trailing: Spacing.none
                    )
                )
                if viewModel.isErrorUpperCase {
                    Text("・大文字を入れてください")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.textForegroundError)
                        .font(.body)
                        .bold()
                        .padding(
                            EdgeInsets(
                                top: Spacing.componentGrouping,
                                leading: Spacing.none,
                                bottom: Spacing.none,
                                trailing: Spacing.none)
                        )
                }
                if viewModel.isErrorLowerCase {
                    Text("・小文字を入れてください")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.textForegroundError)
                        .font(.body)
                        .bold()
                }
                if viewModel.isErrorNumber {
                    Text("・数字を入れてください")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.textForegroundError)
                        .font(.body)
                        .bold()
                }
                if viewModel.isErrorLength {
                    Text("・6文字以上入力してください")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.textForegroundError)
                        .font(.body)
                        .bold()
                }
                NimliButton(
                    eventType: NimliButtonsOption.EventType.positive,
                    text: "アカウントを登録する",
                    isEnabled: viewModel.isEnableRegisterButton,
                    onClick: {
                        Task {
                            await viewModel.register()
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
        }
    }
}

#Preview {
    SignUpView()
}
