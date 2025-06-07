//
//  LoginView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/02.
//

import SwiftUI

// ボタンスタイルの定義
struct IlluMefyLoginButtonStyle: ButtonStyle {
    let isValid: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(isValid ? 1.0 : 0.6)
            .shadow(
                color: Color("Base/Main").opacity(configuration.isPressed ? 0.1 : 0.2),
                radius: configuration.isPressed ? 4 : 8,
                y: configuration.isPressed ? 2 : 4
            )
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}

struct LoginView: View {
    @StateObject private var viewModel = DependencyContainer.shared.resolve(LoginViewModel.self)!
    @EnvironmentObject var router: IlluMefyAppRouter
    
    var body: some View {
        ScrollView {
            VStack {
                // Welcome Section
                VStack(spacing: Spacing.componentGrouping) {
                    Image("IlluMefyIconMedium")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                    
                    Text(L10n.Login.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                    
                    VStack(spacing: 4) {
                        Text(L10n.Login.Subtitle.line1)
                            .font(.body)
                            .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                        Text(L10n.Login.Subtitle.line2)
                            .font(.body)
                            .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                    }
                }
                .padding(.top, Spacing.screenEdgePadding)
                .padding(.bottom, Spacing.unrelatedComponentDivider)
                
                // Login Form
                VStack(spacing: Spacing.relatedComponentDivider) {
                    LoginForm(viewModel: viewModel)
                        .padding(.horizontal, Spacing.screenEdgePadding)
                
                    // Login Button
                    IlluMefyButton(
                        title: L10n.Login.Button.login,
                        isEnabled: viewModel.isValid,
                        action: {
                            Task {
                                router.showLoading()
                                await viewModel.login()
                                router.hideLoading()
                            }
                        }
                    )
                    .padding(.horizontal, Spacing.screenEdgePadding)
                    .padding(.vertical, Spacing.relatedComponentDivider)
                    
                    // Register Link
                    Button(
                        action: {
                            router.navigate(to: .phoneNumberRegistration)
                        },
                        label: {
                            Text(L10n.Login.Link.register)
                                .font(.body)
                                .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                                .underline()
                        }
                    )
                    .padding(.top, Spacing.relatedComponentDivider)
                }
                
                Spacer()
            }
        }
        .background(Asset.Color.Application.Background.background.swiftUIColor)
        .alert("ログイン失敗", isPresented: $viewModel.isShowErrorDialog) {
            Button("OK") { viewModel.isShowErrorDialog = false }
        } message: {
            Text(viewModel.errorDialogMessage)
        }
        .alert("ログイン成功", isPresented: $viewModel.isShowNotificationDialog) {
            Button("OK") {
                viewModel.isShowNotificationDialog = false
                router.navigate(to: .groupList)
            }
        } message: {
            Text(viewModel.notificationDialogMessage)
        }
        .onAppear {
            Task {
                await viewModel.initializeStoredLoginAccountData()
            }
        }
    }
}

struct LoginForm: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var isPhoneNumberFocused = false
    @State private var isPasswordFocused = false
    
    var body: some View {
        // Phone Number Field
        IlluMefyPlainTextField(
            text: $viewModel.phoneNumber,
            placeHolder: L10n.Login.Input.PhoneNumber.textfield,
            label: L10n.Login.Input.PhoneNumber.label,
            isRequired: true
        )
        .keyboardType(.phonePad)
    }
}

#Preview {
    LoginView()
        .environmentObject(IlluMefyAppRouter())
}
