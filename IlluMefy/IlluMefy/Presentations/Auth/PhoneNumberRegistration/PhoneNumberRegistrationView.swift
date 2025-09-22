//
//  PhoneNumberRegistrationView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/02/12.
//
//  電話番号登録画面
//  新規ユーザーが電話番号を入力してアカウント登録を開始する画面
//

import SwiftUI

/// 電話番号登録画面のメインビュー
struct PhoneNumberRegistrationView: View {
    // MARK: - Properties
    
    /// ビューモデル（依存性注入で取得）
    @StateObject private var viewModel = DependencyContainer.shared.resolve(PhoneNumberRegistrationViewModel.self)!
    
    /// アプリ全体のルーター
    @EnvironmentObject var router: IlluMefyAppRouter
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // 背景レイヤー
            backgroundLayer
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                   to: nil, from: nil, for: nil)
                }

            // メインコンテンツ
            SignUpFormView(viewModel: viewModel, router: router)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                   to: nil, from: nil, for: nil)
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
                // 認証番号入力画面へ遷移
                if let verificationID = viewModel.verificationID {
                    router.navigate(to: .phoneVerification(
                        verificationID: verificationID,
                        phoneNumber: viewModel.phoneNumber
                    ))
                }
            }
        } message: {
            if viewModel.phoneNumber.isEmpty {
                Text(L10n.PhoneNumberRegistration.Message.trialTapped)
            } else {
                Text(viewModel.notificationDialogMessage)
            }
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

// MARK: - SignUpFormView

/// 登録フォームのコンテンツビュー
/// アイコン、タイトル、入力フィールド、ボタンなどを含む
struct SignUpFormView: View {
    // MARK: - Properties
    
    /// 親ビューから渡されるビューモデル
    @ObservedObject var viewModel: PhoneNumberRegistrationViewModel
    
    /// アプリルーター
    var router: IlluMefyAppRouter
    
    // MARK: - State
    
    /// プライバシーポリシー同意状態
    @State private var isPrivacyPolicyAgreed = false
    
    /// フォーム表示アニメーション状態
    @State private var formAppeared = false
    
    /// 電話番号フィールドのフォーカス状態
    @FocusState private var isPhoneFocused: Bool

    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // ヘッダーセクション（アイコン + タイトル + 説明）
                headerSection

                // フォームセクション（入力フィールド + チェックボックス）
                formSection

                // アクションセクション（ボタン + リンク）
                actionSection

                // トライアルセクション
                trialSection
                    .padding(.top, Spacing.unrelatedComponentDivider)
            }
            .onTapGesture {  // VStack全体をタップでキーボードを閉じる
                isPhoneFocused = false
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .onAppear {
            // 表示時のアニメーション開始
            withAnimation {
                formAppeared = true
            }
        }
        .onChange(of: viewModel.phoneNumber) { _, _ in
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
            Text(L10n.PhoneNumberRegistration.title)
                .font(.system(size: Typography.titleLarge, weight: .bold, design: .rounded))
                .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
                .padding(.top, Spacing.componentGrouping)
                .opacity(formAppeared ? 1 : 0)
                .animation(.easeOut(duration: AnimationDuration.medium).delay(AnimationParameters.delayMedium), value: formAppeared)
            
            // 説明文
            Text(L10n.PhoneNumberRegistration.Description.line1)
                .font(.system(.body, design: .rounded))
                .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor.opacity(Opacity.secondaryText))
                .opacity(formAppeared ? 1 : 0)
                .animation(.easeOut(duration: AnimationDuration.medium).delay(AnimationParameters.delayLong), value: formAppeared)
            .multilineTextAlignment(.center)
            .padding(.horizontal, Spacing.screenEdgePadding)
        }
        .padding(.top, Spacing.screenEdgePadding * 2)
    }
    
    /// フォームセクション（入力フィールド）
    private var formSection: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            // 電話番号入力フィールド
            phoneNumberField
            
            // プライバシーポリシー同意チェックボックス
            privacyPolicyCheckbox
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
    
    /// 電話番号入力フィールド
    private var phoneNumberField: some View {
        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
            IlluMefyPlainTextField(
                text: $viewModel.phoneNumber,
                placeHolder: L10n.PhoneNumberRegistration.Input.PhoneNumber.textfield,
                label: L10n.PhoneNumberRegistration.Input.PhoneNumber.label,
                isRequired: true,
                keyboardType: .phonePad
            )
            .focused($isPhoneFocused)
            // フォーカス時の拡大エフェクト
            .scaleEffect(isPhoneFocused ? Effects.focusScale : 1.0)
            .animation(.spring(
                response: AnimationParameters.springResponse,
                dampingFraction: AnimationParameters.springDampingMedium),
                       value: isPhoneFocused
            )
            .onChange(of: viewModel.phoneNumber) {
                let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedback.impactOccurred()
            }
        }
    }
    
    /// プライバシーポリシー同意チェックボックス
    private var privacyPolicyCheckbox: some View {
        HStack(spacing: Spacing.componentGrouping) {
            Spacer()
            // チェックボックス部分
            Button(action: {
                isPrivacyPolicyAgreed.toggle()
            }, label: {
                Image(systemName: isPrivacyPolicyAgreed ? "checkmark.square.fill" : "square")
                    .foregroundColor(isPrivacyPolicyAgreed ?
                        Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor :
                        Asset.Color.Application.textPrimary.swiftUIColor.opacity(Opacity.disabledText))
                    .font(.title2)
            })
            
            // プライバシーポリシーテキスト
            Button(action: {
                openPrivacyPolicy()
            }, label: {
                Text(L10n.PhoneNumberRegistration.Checkbox.privacyPolicy)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor)
                    .underline()
                    .multilineTextAlignment(.leading)
            })
            
            Spacer()
        }
        .padding(.vertical, Spacing.componentGrouping)
        .background(Color.clear)
    }
                
    /// アクションセクション（ボタンとリンク）
    private var actionSection: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            // メインアクションボタン（認証へ進む）
            primaryActionButton
        }
        .padding(.top, Spacing.unrelatedComponentDivider)
        .padding(.bottom, Spacing.screenEdgePadding * 2)
    }
    
    /// プライマリアクションボタン（パルスエフェクト付き）
    private var primaryActionButton: some View {
        ZStack {
            // ボタンが有効な時のパルスエフェクト
            if !viewModel.phoneNumber.isEmpty && isPrivacyPolicyAgreed {
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .fill(Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor.opacity(Opacity.disabledText))
                    .frame(height: Layout.pulseFrameHeight)
                    .padding(.horizontal, Spacing.screenEdgePadding)
                    .blur(radius: Effects.blurRadiusLarge)
                    .scaleEffect(Effects.glowScale)
                    .opacity(Opacity.pulseEffect)
                    .animation(
                        .easeInOut(duration: AnimationDuration.verySlow)
                            .repeatForever(autoreverses: true),
                        value: isPrivacyPolicyAgreed
                    )
            }
            
            // メインボタン
            IlluMefyButton(
                title: L10n.PhoneNumberRegistration.Button.verification,
                isEnabled: !viewModel.phoneNumber.isEmpty && isPrivacyPolicyAgreed,
                action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                    impactFeedback.impactOccurred()
                    router.isShowingLoadingIndicator = true
                    Task {
                        await viewModel.sendAuthenticationCode(phoneNumber: nil)
                        router.isShowingLoadingIndicator = false
                    }
                }
            )
            .padding(.horizontal, Spacing.screenEdgePadding)
            // 条件付きシャドウ（有効時はより強く）
            .shadow(
                color: Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor.opacity(Opacity.buttonShadow),
                radius: !viewModel.phoneNumber.isEmpty && isPrivacyPolicyAgreed ? Shadow.radiusLarge : Shadow.radiusMedium,
                y: !viewModel.phoneNumber.isEmpty && isPrivacyPolicyAgreed ? Shadow.offsetYLarge : Shadow.offsetYMedium
            )
            .animation(
                .spring(
                    response: AnimationParameters.springResponseMedium,
                    dampingFraction: AnimationParameters.springDampingMedium),
                value: isPrivacyPolicyAgreed
            )
        }
    }
    
    private var trialSection: some View {
        HStack {
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedback.impactOccurred()
                router.isShowingLoadingIndicator = true
                Task {
                    await viewModel.sendAuthenticationCode(phoneNumber: "08012345678")
                    router.isShowingLoadingIndicator = false
                }
            }, label: {
                Text(L10n.PhoneNumberRegistration.Button.trial)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
                    .bold()
                    .underline()
                    .multilineTextAlignment(.leading)
            })
            .opacity(formAppeared ? 1 : 0)
            .animation(
                .easeOut(
                    duration: AnimationDuration.medium).delay(AnimationParameters.delayLong),
                value: formAppeared
            )
        }
    }
    
    // MARK: - Private Methods
    
    /// プライバシーポリシーページを開く
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://lying-rate-213.notion.site/IlluMefy-1fee5e0485cb80208497c1f1cca7e10b") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Previews

#Preview {
    PhoneNumberRegistrationView()
        .environmentObject(IlluMefyAppRouter())
}
