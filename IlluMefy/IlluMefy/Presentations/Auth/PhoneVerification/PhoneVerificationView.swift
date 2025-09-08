//
//  PhoneVerificationView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//
//  電話番号認証画面
//  送信された認証番号を入力してアカウント登録を完了する画面
//

import SwiftUI

/// 電話番号認証画面のメインビュー
struct PhoneVerificationView: View {
    // MARK: - Properties
    @StateObject private var viewModel: PhoneVerificationViewModel
    @EnvironmentObject var router: IlluMefyAppRouter
    
    /// Firebase認証用のverificationID
    private let verificationID: String
    
    /// 電話番号
    private let phoneNumber: String
    
    // MARK: - Initialization
    
    init(verificationID: String, phoneNumber: String) {
        self.verificationID = verificationID
        self.phoneNumber = phoneNumber
        
        // ViewModelの初期化
        let verifyPhoneAuthCodeUseCase = DependencyContainer.shared.resolve(VerifyPhoneAuthCodeUseCase.self)!
        let sendPhoneUseCase = DependencyContainer.shared.resolve(SendPhoneVerificationUseCase.self)!
        
        _viewModel = StateObject(wrappedValue: PhoneVerificationViewModel(
            verificationID: verificationID,
            phoneNumber: phoneNumber,
            verifyPhoneAuthCodeUseCase: verifyPhoneAuthCodeUseCase,
            sendPhoneVerificationUseCase: sendPhoneUseCase
        ))
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // 背景レイヤー
            backgroundLayer
            
            // メインコンテンツ
            VerificationFormView(viewModel: viewModel, router: router)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            
            // ローディングインジケータ
            if viewModel.isLoading {
                IlluMefyLoadingDialog(isLoading: true, message: nil)
            }
        }
        // エラーダイアログ
        .alert(L10n.Common.Dialog.Title.error, isPresented: $viewModel.isShowErrorDialog) {
            Button(L10n.Common.ok) { viewModel.isShowErrorDialog = false }
        } message: {
            Text(viewModel.errorDialogMessage)
        }
        // 成功ダイアログ
        .alert(L10n.Common.Dialog.Title.success, isPresented: $viewModel.isShowNotificationDialog) {
            Button(L10n.Common.ok) {
                viewModel.isShowNotificationDialog = false
                router.navigate(to: .home)
            }
        } message: {
            Text(L10n.PhoneVerification.Message.accountCreated)
        }
    }
    
    // MARK: - Subviews
    
    /// 背景レイヤー（グラデーション + パーティクル）
    private var backgroundLayer: some View {
        ZStack {
            // アニメーション付きグラデーション背景
            AnimatedGradientBackground()
            
            // 浮遊パーティクルエフェクト
            FloatingParticlesView()
        }
    }
}

// MARK: - VerificationFormView

/// 認証フォームのコンテンツビュー
struct VerificationFormView: View {
    // MARK: - Properties
    
    /// 親ビューから渡されるビューモデル
    @ObservedObject var viewModel: PhoneVerificationViewModel
    
    /// アプリルーター
    var router: IlluMefyAppRouter
    
    // MARK: - State
    
    /// フォーム表示アニメーション状態
    @State private var formAppeared = false
    
    /// 認証番号フィールドのフォーカス状態
    @FocusState private var isCodeFocused: Bool

    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // ヘッダーセクション（アイコン + タイトル + 説明）
                headerSection
                
                // フォームセクション（入力フィールド）
                formSection
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .onAppear {
            // 表示時のアニメーション開始
            withAnimation {
                formAppeared = true
            }
            
            // 電話番号が空で本画面に来るときはテストアカウントの時のみ
            if viewModel.phoneNumber == "" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    viewModel.verificationCode = "000000"
                    Task {
                        await viewModel.registerAccount()
                    }
                }
            } else {
                // 通常モードでは認証番号フィールドに自動フォーカス
                DispatchQueue.main.asyncAfter(deadline: .now() + AnimationParameters.autoFocusDelay) {
                    isCodeFocused = true
                }
            }
        }
        .onChange(of: viewModel.verificationCode) { _, _ in
            // 文字入力時の触覚フィードバック
            let selectionFeedback = UISelectionFeedbackGenerator()
            selectionFeedback.selectionChanged()
        }
    }
    
    // MARK: - Subviews
    
    /// ヘッダーセクション（アイコン、タイトル、説明文）
    private var headerSection: some View {
        VStack(spacing: Spacing.componentGrouping) {
            // アニメーション付きロゴアイコン
            AnimatedLogoIcon(isAppeared: $formAppeared)
            
            // タイトル
            Text(L10n.PhoneVerification.title)
                .font(.system(size: Typography.titleMedium, weight: .bold, design: .rounded))
                .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
                .padding(.top, Spacing.componentGrouping)
                .opacity(formAppeared ? 1 : 0)
                .animation(.easeOut(duration: AnimationDuration.medium).delay(AnimationParameters.delayMedium), value: formAppeared)
            
            VStack(spacing: Layout.descriptionSpacing) {
                Text(L10n.PhoneVerification.Description.line1)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor.opacity(Opacity.secondaryText))
                    .opacity(formAppeared ? 1 : 0)
                    .animation(.easeOut(duration: AnimationDuration.medium).delay(AnimationParameters.delayLong), value: formAppeared)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, Spacing.screenEdgePadding * 1.5)
        }
        .padding(.top, Spacing.screenEdgePadding * 2)
    }
    
    /// フォームセクション（入力フィールド）
    private var formSection: some View {
        VStack(spacing: Spacing.unrelatedComponentDivider) {
            // 認証番号入力フィールド
            verificationCodeField
            // 再送信ボタン
            resendCodeButton
        }
        .padding(.top, Spacing.unrelatedComponentDivider)
        .padding(.horizontal, Spacing.screenEdgePadding)
        .opacity(formAppeared ? 1 : 0)
        .animation(
            .spring(
                response: AnimationParameters.springResponseSlow,
                dampingFraction: AnimationParameters.springDampingHigh).delay(AnimationParameters.delayVeryLong),
            value: formAppeared
        )
    }
    
    /// 認証番号入力フィールド
    private var verificationCodeField: some View {
        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
            IlluMefyPlainTextField(
                text: $viewModel.verificationCode,
                placeHolder: L10n.PhoneVerification.Input.VerificationCode.textfield,
                label: L10n.PhoneVerification.Input.VerificationCode.label,
                isRequired: true,
                keyboardType: .numberPad
            )
            .focused($isCodeFocused)
            .scaleEffect(isCodeFocused ? Effects.focusScale : 1.0)
            .animation(
                .spring(
                    response: AnimationParameters.springResponse,
                    dampingFraction: AnimationParameters.springDampingMedium),
                value: isCodeFocused
            )
            .onChange(of: viewModel.verificationCode) { _, newValue in
                let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedback.impactOccurred()
                if newValue.count == 6 {
                    Task { await viewModel.registerAccount()}
                }
            }
        }
    }
    
    /// 認証番号再送信ボタン
    private var resendCodeButton: some View {
        Button(
            action: {
                Task {
                    await viewModel.resendVerificationCode()
                }
            },
            label: {
                if viewModel.resendCooldownSeconds > 0 {
                    Text("\(L10n.PhoneVerification.Button.resendCode) (\(viewModel.resendCooldownSeconds)秒)")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor.opacity(Opacity.disabledText))
                } else {
                    Text(L10n.PhoneVerification.Button.resendCode)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor)
                }
            }
        )
        .disabled(!viewModel.isResendButtonEnabled)
        .padding(.top, Spacing.componentGrouping)
        .opacity(formAppeared ? 1 : 0)
        .animation(.easeOut(duration: AnimationDuration.medium).delay(AnimationParameters.delayMedium), value: formAppeared)
    }
}

// MARK: - Preview

#Preview {
    PhoneVerificationView(
        verificationID: "test-verification-id",
        phoneNumber: "09012345678"
    )
    .environmentObject(IlluMefyAppRouter())
}
