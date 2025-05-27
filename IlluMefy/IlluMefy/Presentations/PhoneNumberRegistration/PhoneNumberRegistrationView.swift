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
    }
}

// Main form content view
struct SignUpFormView: View {
    @ObservedObject var viewModel: PhoneNumberRegistrationViewModel
    var router: IlluMefyAppRouter
    @State private var phoneNumber = ""
    @State private var isPrivacyPolicyAgreed = false

    var body: some View {
        VStack(spacing: 0) {
            // Top section with icon and title
            VStack(spacing: 24) {
                // IlluMefy icon
                Image(Asset.Assets.illuMefyIconMedium.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                
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
                .frame(height: 20)
            
            // Privacy policy checkbox
            IlluMefyCheckbox(
                isChecked: $isPrivacyPolicyAgreed,
                title: L10n.PhoneNumberRegistration.Checkbox.privacyPolicy
            )
            
            Spacer()
                .frame(height: 40)
            
            // Verification button
            IlluMefyButton(
                title: L10n.PhoneNumberRegistration.Button.verification,
                isEnabled: !phoneNumber.isEmpty && isPrivacyPolicyAgreed,
                action: {
                    // Handle verification
                }
            )
            
            Spacer()
            
            // Login link
            Button(action: {
                router.navigate(to: .login)
            }, label: {
                Text(L10n.PhoneNumberRegistration.Link.login)
                    .font(.body)
                    .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                    .underline()
            })
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    PhoneNumberRegistrationView().environmentObject(IlluMefyAppRouter())
}
