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
    
    /// ビューモデル（依存性注入で取得）
    @StateObject private var viewModel: PhoneVerificationViewModel
    
    /// アプリ全体のルーター
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
            Button("OK") { viewModel.isShowErrorDialog = false }
        } message: {
            Text(viewModel.errorDialogMessage)
        }
        // 成功ダイアログ
        .alert(L10n.Common.Dialog.Title.success, isPresented: $viewModel.isShowNotificationDialog) {
            Button("OK") {
                viewModel.isShowNotificationDialog = false
                router.navigate(to: .groupList)
            }
        } message: {
            Text(viewModel.notificationDialogMessage)
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
                
                // アクションセクション（ボタン + リンク）
                actionSection
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .onAppear {
            // 表示時のアニメーション開始
            withAnimation {
                formAppeared = true
            }
            // 認証番号フィールドに自動フォーカス
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isCodeFocused = true
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
            
            // タイトル（段階的フェードイン）
            Text(L10n.PhoneVerification.title)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                .padding(.top, Spacing.componentGrouping)
                .offset(y: formAppeared ? 0 : 20)
                .opacity(formAppeared ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.3), value: formAppeared)
            
            // 説明文（2段階のフェードイン）
            VStack(spacing: 6) {
                // 1行目の説明
                Text(L10n.PhoneVerification.Description.line1)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(Asset.Color.Application.foreground.swiftUIColor.opacity(0.85))
                    .offset(y: formAppeared ? 0 : 10)
                    .opacity(formAppeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.5), value: formAppeared)
                
                // 2行目の説明
                Text(L10n.PhoneVerification.Description.line2)
                    .font(.system(.callout, design: .rounded))
                    .foregroundColor(Asset.Color.Application.foreground.swiftUIColor.opacity(0.65))
                    .offset(y: formAppeared ? 0 : 10)
                    .opacity(formAppeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.7), value: formAppeared)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, Spacing.screenEdgePadding * 1.5)
        }
        .padding(.top, Spacing.screenEdgePadding * 2)
    }
    
    /// フォームセクション（入力フィールド）
    private var formSection: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            // 認証番号入力フィールド
            verificationCodeField
        }
        .padding(.top, Spacing.unrelatedComponentDivider)
        .padding(.horizontal, Spacing.screenEdgePadding)
        // 横からスライドインするアニメーション
        .offset(x: formAppeared ? 0 : -50)
        .opacity(formAppeared ? 1 : 0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.9), value: formAppeared)
    }
    
    /// 認証番号入力フィールド
    private var verificationCodeField: some View {
        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
            IlluMefyPlainTextField(
                text: $viewModel.verificationCode,
                placeHolder: L10n.PhoneVerification.Input.VerificationCode.textfield,
                label: L10n.PhoneVerification.Input.VerificationCode.label,
                isRequired: true
            )
            .keyboardType(.numberPad)
            .focused($isCodeFocused)
            // フォーカス時の拡大エフェクト
            .scaleEffect(isCodeFocused ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCodeFocused)
            .onChange(of: viewModel.verificationCode) { _, newValue in
                // 6桁制限
                if newValue.count > 6 {
                    viewModel.verificationCode = String(newValue.prefix(6))
                }
            }
        }
    }

    /// アクションセクション（ボタンとリンク）
    private var actionSection: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            // メインアクションボタン（アカウント登録完了）
            primaryActionButton
            
            // 認証番号再送信ボタン
            resendCodeButton
            
            // 戻るリンク
            backLink
        }
        .padding(.top, Spacing.unrelatedComponentDivider)
        .padding(.bottom, Spacing.screenEdgePadding * 2)
    }
    
    /// プライマリアクションボタン（パルスエフェクト付き）
    private var primaryActionButton: some View {
        ZStack {
            // ボタンが有効な時のパルスエフェクト
            if viewModel.isRegisterButtonEnabled {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor.opacity(0.3))
                    .frame(height: 56)
                    .padding(.horizontal, Spacing.screenEdgePadding)
                    .blur(radius: 20)
                    .scaleEffect(1.1)
                    .opacity(0.5)
                    .animation(
                        .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: viewModel.isRegisterButtonEnabled
                    )
            }
            
            // メインボタン
            IlluMefyButton(
                title: L10n.PhoneVerification.Button.register,
                isEnabled: viewModel.isRegisterButtonEnabled,
                action: {
                    // 触覚フィードバック（中程度の強さ）
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    Task {
                        await viewModel.registerAccount()
                    }
                }
            )
            .padding(.horizontal, Spacing.screenEdgePadding)
            // 条件付きシャドウ（有効時はより強く）
            .shadow(
                color: Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor.opacity(0.3),
                radius: viewModel.isRegisterButtonEnabled ? 15 : 10,
                y: viewModel.isRegisterButtonEnabled ? 8 : 5
            )
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.isRegisterButtonEnabled)
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
                        .foregroundColor(Asset.Color.Application.foreground.swiftUIColor.opacity(0.5))
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
    }
    
    /// 戻るリンク
    private var backLink: some View {
        Button(
            action: {
                router.navigateBack()
            },
            label: {
                Text(L10n.PhoneVerification.Link.back)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor)
            }
        )
        .padding(.top, Spacing.componentGrouping / 2)
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
