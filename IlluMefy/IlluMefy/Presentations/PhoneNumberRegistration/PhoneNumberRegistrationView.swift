//
//  PhoneNumberRegistrationView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/02/12.

import SwiftUI

struct PhoneNumberRegistrationView: View {
    @StateObject private var viewModel = DependencyContainer.shared.resolve(PhoneNumberRegistrationViewModel.self)!
    @EnvironmentObject var router: IlluMefyAppRouter

    var body: some View {
        ZStack {
            SignUpFormView(viewModel: viewModel, router: router)
                .padding(Spacing.screenEdgePadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Asset.Color.Application.background.swiftUIColor)
                .ignoresSafeArea(.keyboard, edges: .all)
        }
        .alert("アカウント登録失敗", isPresented: $viewModel.isShowErrorDialog) {
            Button("OK") { viewModel.isShowErrorDialog = false }
        } message: {
            Text(viewModel.errorDialogMessage)
        }
        .alert("アカウント登録成功", isPresented: $viewModel.isShowNotificationDialog) {
            Button("OK") {
                viewModel.isShowNotificationDialog = false
                router.navigate(to: .login)
            }
        } message: {
            Text(viewModel.notificationDialogMessage)
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
    @ObservedObject var viewModel: PhoneNumberRegistrationViewModel
    var router: IlluMefyAppRouter
    @State private var phoneNumber = ""

    var body: some View {
        VStack(spacing: 0) {
            // Top section with icon and title
            VStack(spacing: 24) {
                // IlluMefy icon
                Image(Asset.Assets.illuMefyIconMedium.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .padding(.top, 40)
                
                // Title with emoji
                Text(L10n.PhoneNumberRegistration.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                
                // Description
                VStack(spacing: 4) {
                    Text(L10n.PhoneNumberRegistration.Description.line1)
                        .font(.body)
                        .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                    Text(L10n.PhoneNumberRegistration.Description.line2)
                        .font(.body)
                        .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                }
                .multilineTextAlignment(.center)
            }
            
            Spacer()
                .frame(height: 60)
            
            // Phone number input section
            IlluMefyPlainTextField(
                text: $phoneNumber,
                placeHolder: L10n.PhoneNumberRegistration.Input.PhoneNumber.textfield,
                label: L10n.PhoneNumberRegistration.Input.PhoneNumber.label,
                isRequired: true
            )
            .keyboardType(.phonePad)
            
            Spacer()
                .frame(height: 40)
            
            // Verification button
            IlluMefyButton(
                title: L10n.PhoneNumberRegistration.Button.verification,
                isEnabled: !phoneNumber.isEmpty,
                action: {
                    // Handle verification
                }
            )
            
            Spacer()
            
            // Login link
            Button(action: {
                router.navigate(to: .login)
            }) {
                Text(L10n.PhoneNumberRegistration.Link.login)
                    .font(.body)
                    .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                    .underline()
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 20)
    }
}

///
/// Terms-of-service and Privacy-Policy
///
struct TermsAndPolicyView: View {
    @ObservedObject var viewModel: PhoneNumberRegistrationViewModel

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 4, height: 40)
                //.foregroundColor(.viewForegroundPositive)
                .padding(.trailing, 8)
            
            Text("アカウントを作成することで、[利用規約](termsOfService)および[プライバシーポリシー](privacyPolicy)に同意し、ニムリーを使用することに同意したものとみなします。")
                //.foregroundColor(Color.textForeground)
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
        //.background(Color.cardFillColorNormal)
        .cornerRadius(10)
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
                    Text("IlluMefy 利用規約")
                        .font(.headline)
                    Text("1. サービスの利用")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .font(.title2)
                    Text("IlluMefy(ニムリー)は食材管理と家族・グループ間での情報共有を目的としたアプリです。ユーザーは個人利用の範囲でサービスを利用することができます。")
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
                    Text("IlluMefy(ニムリー)は食材の消費期限などの情報管理をサポートするものですが、提供される情報の正確性を保証するものではありません。最終的な判断はユーザー自身の責任で行ってください。")
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
            /*IlluMefyButton(
                text: "利用規約の詳細を確認する",
                isEnabled: true,
                onClick: {
                    openURL(URL(string: "https://github.com/aoi-stella/IlluMefy-iOS/blob/main/terms-of-service-full.md")!)
                }
            ).padding()*/
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
                    Text("IlluMefy プライバシーポリシー")
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
            /*IlluMefyButton(
                text: "プライバシーポリシーの詳細を確認する",
                isEnabled: true,
                onClick: {
                    openURL(URL(string: "https://github.com/aoi-stella/IlluMefy-iOS/blob/main/privacy-policy.md")!)
                }
            ).padding()*/
        }
        .padding()
    }
}

#Preview {
    PhoneNumberRegistrationView().environmentObject(IlluMefyAppRouter())
}
