//
//  SignUpView.swift
//  Nimli
//
//  Created by Haruto K. on 2025/02/12.

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = DependencyContainer.shared.resolve(SignUpViewModel.self)!
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
            SignUpFormView(viewModel: viewModel, router: router)
                .padding(Spacing.screenEdgePadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.screenBackground)
                .navigationTitle("会員登録")
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea(.keyboard, edges: .all)
        }
        .alert("アカウント登録失敗", isPresented: $viewModel.isShowErrorDialog) {
            Button("OK") { viewModel.isShowErrorDialog = false }
        } message: {
            Text(viewModel.errorMessage)
        }
        .alert("アカウント登録成功", isPresented: $viewModel.isShowNotificationDialog) {
            Button("OK") {
                viewModel.isShowNotificationDialog = false
                router.navigate(to: .emailVerification)
            }
        } message: {
            Text("新規アカウントの仮登録に成功しました。\n次画面にてメールアドレスの認証をしてください。")
        }
        .sheet(isPresented: $viewModel.isShowTermsOfServiceBottomSheet) {
            TermsOfServiceBottomSheetContent()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $viewModel.isShowPrivacyPolicyBottomSheet) {
            PrivacyPolicyBottomSheetContent()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

// Main form content view
struct SignUpFormView: View {
    @ObservedObject var viewModel: SignUpViewModel
    var router: NimliAppRouter

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                LogoHeaderView()
                    .padding(.bottom, 10)
                
                VStack(spacing: 16) {
                    Text("アカウント情報")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                        .foregroundColor(.textForeground)
                    
                    // Input fields
                    InputFieldsView(viewModel: viewModel)
                    
                    // Password validation messages
                    PasswordValidationView(viewModel: viewModel)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.cardFillColorNormal)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                )
                
                // Terms and policy card
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundColor(Color.imageForegroundPositive)
                        Text("利用規約とプライバシー")
                            .font(.headline)
                            .foregroundColor(Color.textForeground)
                        Spacer()
                    }
                    
                    TermsAndPolicyView(viewModel: viewModel)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.cardFillColorNormal)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                )
                
                // Register button
                NimliButton(
                    text: "アカウントを登録する",
                    isEnabled: viewModel.isEnableRegisterButton,
                    onClick: {
                        Task {
                            router.showLoading()
                            await viewModel.register()
                            router.hideLoading()
                        }
                    },
                    leadingIcon: AnyView(
                        Image(systemName: "person.crop.circle.badge.plus")
                    )
                )
                
                // Login option
                LoginOptionView(router: router)
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding(.vertical, 20)
        }
    }
}

// Logo and welcome header
struct LogoHeaderView: View {
    var body: some View {
        VStack {
            // Only include the Image if you have this asset
            if let _ = UIImage(named: "nimli-logo") {
                Image("nimli-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding(.bottom, 10)
            } else {
                // Fallback icon if logo is not available
                Image(systemName: "apps.iphone")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                    .padding(.bottom, 10)
            }

            Text("Welcome to Nimli!!")
                .foregroundColor(Color.textForeground)
                .font(.title2)
                .bold()
                .padding(.bottom, 5)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

// Input fields section
struct InputFieldsView: View {
    @ObservedObject var viewModel: SignUpViewModel

    var body: some View {
        VStack {
            // Email field
            NimliPlainTextField(
                text: $viewModel.email,
                title: "メールアドレス",
                placeHolder: "メールアドレス",
                placeHolderColor: .cardFillColorNormal
            )
            .frame(height: 50)
            .onChange(of: viewModel.email) {
                viewModel.onEmailDidChange()
            }

            // Password field
            NimliPlainTextField(
                text: $viewModel.password,
                title: "パスワード",
                placeHolder: "パスワード",
                placeHolderColor: .cardFillColorNormal
            )
            .frame(height: 50)  // 明示的な高さを指定
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
        }
    }
}

// Password validation messages
struct PasswordValidationView: View {
    @ObservedObject var viewModel: SignUpViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("パスワード要件:")
                .font(.caption)
                .foregroundColor(.textForeground)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 5)
            
            Group {
                ValidationRow(
                    isValid: !viewModel.isErrorUpperCase,
                    text: "大文字を含む"
                )
                
                ValidationRow(
                    isValid: !viewModel.isErrorLowerCase,
                    text: "小文字を含む"
                )
                
                ValidationRow(
                    isValid: !viewModel.isErrorNumber,
                    text: "数字を含む"
                )
                
                ValidationRow(
                    isValid: !viewModel.isErrorLength,
                    text: "6文字以上"
                )
            }
        }
        .padding(.top, 5)
    }
}

struct ValidationRow: View {
    var isValid: Bool
    var text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isValid ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isValid ? .green : .gray)
                .font(.system(size: 14))
            
            Text(text)
                .font(.caption)
                .foregroundColor(isValid ? .green : .gray)
            
            Spacer()
        }
    }
}

///
/// Terms-of-service and Privacy-Policy
///
struct TermsAndPolicyView: View {
    @ObservedObject var viewModel: SignUpViewModel

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 4, height: 40)
                .foregroundColor(.viewForegroundPositive)
                .padding(.trailing, 8)
            
            Text("アカウントを作成することで、[利用規約](termsOfService)および[プライバシーポリシー](privacyPolicy)に同意し、ニムリーを使用することに同意したものとみなします。")
                .foregroundColor(Color.textForeground)
                .font(.caption)
                .lineSpacing(4)
                .environment(\.openURL, OpenURLAction { specifiedParam in
                    switch specifiedParam.description {
                    case "termsOfService":
                        viewModel.isShowTermsOfServiceBottomSheet = true
                    case "privacyPolicy":
                        viewModel.isShowPrivacyPolicyBottomSheet = true
                    default:
                        Void()
                    }
                    return .handled
                })
        }
        .padding(20)
        .background(Color.cardFillColorNormal)
        .cornerRadius(10)
    }
}

///
/// Navigate to login screen
///
struct LoginOptionView: View {
    var router: NimliAppRouter

    var body: some View {
        HStack(spacing: 4) {
            Text("すでにアカウントをお持ちですか？")
                .foregroundColor(Color.textForeground.opacity(0.8))
                .font(.caption)

            Button("ログイン") {
                // Navigate to login screen
                // Uncomment if you have this route:
                // router.navigate(to: .login)
            }
            .foregroundColor(Color.blue)
            .font(.caption.bold())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

///
/// Terms-of-service bottom sheet
///
struct TermsOfServiceBottomSheetContent: View {
    @Environment(\.openURL) var openURL
    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Nimli 利用規約")
                        .font(.headline)
                    Text("1. サービスの利用")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(.title2)
                    Text("Nimli(ニムリー)は食材管理と家族・グループ間での情報共有を目的としたアプリです。ユーザーは個人利用の範囲でサービスを利用することができます。")
                        .multilineTextAlignment(.leading)
                        .bold()
                        .font(.body)
                    Text("2. ユーザーの責任")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(.title2)
                    Text("ユーザーは情報の安全管理に責任を持ち、不正アクセスが発生した場合は速やかに報告する必要があります。また、他のユーザーのプライバシーを尊重し、共有された情報を適切に扱ってください。")
                        .multilineTextAlignment(.leading)
                        .bold()
                        .font(.body)
                    Text("3. コンテンツの所有権")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(.title2)
                    Text("ユーザーが投稿した食材情報などのコンテンツの所有権はユーザーに帰属します。ただし、サービス提供のために必要な範囲でこれらの情報を使用する権利を当社に許諾するものとします。")
                        .multilineTextAlignment(.leading)
                        .bold()
                        .font(.body)
                    Text("4. 免責事項")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(.title2)
                    Text("Nimli(ニムリー)は食材の消費期限などの情報管理をサポートするものですが、提供される情報の正確性を保証するものではありません。最終的な判断はユーザー自身の責任で行ってください。")
                        .multilineTextAlignment(.leading)
                        .bold()
                        .font(.body)
                    Text("5. サービスの変更・終了")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(.title2)
                    Text("予告なくサービス内容の変更や終了を行う場合があります。その際に生じた損害について、当社は責任を負いません。")
                        .multilineTextAlignment(.leading)
                        .bold()
                        .font(.body)
                    Text("6. 規約の変更")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(.title2)
                    Text("本規約は予告なく変更される場合があります。変更後も継続して利用された場合、変更後の規約に同意したものとみなします。")
                        .multilineTextAlignment(.leading)
                        .bold()
                        .font(.body)
                    Text("7. 準拠法")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(.title2)
                    Text("本規約は日本法に準拠し、解釈されるものとします。")
                        .multilineTextAlignment(.leading)
                        .bold()
                        .font(.body)
                }
            }
            NimliButton(
                text: "利用規約の詳細を確認する",
                isEnabled: true,
                onClick: {
                    openURL(URL(string: "https://github.com/aoi-stella/Nimli-iOS/blob/main/terms-of-service-full.md")!)
                }
            ).padding()
        }
        .padding()
    }
}

///
/// privacy-policy bottom sheet
///
struct PrivacyPolicyBottomSheetContent: View {
    @Environment(\.openURL) var openURL
    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Nimli プライバシーポリシー")
                        .font(.headline)
                    Text("1. 収集する情報")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(.title2)
                    Text("当アプリは食材管理とグループ共有のために必要な情報のみを収集します。これには、アカウント情報（メールアドレスやパスワード）、登録された食材情報、および共有グループ情報が含まれます。")
                        .multilineTextAlignment(.leading)
                        .bold()
                        .font(.body)
                    Text("2. 情報の利用方法")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(.title2)
                    Text("収集した情報は、アプリの基本機能の提供、サービス改善、および技術的な問題の解決のみに使用されます。")
                        .multilineTextAlignment(.leading)
                        .bold()
                        .font(.body)
                    Text("3. 情報の共有")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(.title2)
                    Text("ユーザーが明示的に許可した場合を除き、個人情報を第三者と共有することはありません。食材情報はユーザーが指定したグループメンバーとのみ共有されます。")
                        .multilineTextAlignment(.leading)
                        .bold()
                        .font(.body)
                }
            }
            NimliButton(
                text: "プライバシーポリシーの詳細を確認する",
                isEnabled: true,
                onClick: {
                    openURL(URL(string: "https://github.com/aoi-stella/Nimli-iOS/blob/main/privacy-policy.md")!)
                }
            ).padding()
        }
        .padding()
    }
}

#Preview {
    SignUpView().environmentObject(NimliAppRouter())
}
