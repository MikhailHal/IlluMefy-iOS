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
            
            // メインコンテンツ
            SignUpFormView(viewModel: viewModel, router: router)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.keyboard, edges: .bottom)
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
                .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                .padding(.top, Spacing.componentGrouping)
                .offset(y: formAppeared ? 0 : Layout.titleOffsetY)
                .opacity(formAppeared ? 1 : 0)
                .animation(.easeOut(duration: AnimationDuration.medium).delay(AnimationParameters.delayMedium), value: formAppeared)
            
            // 説明文
            Text(L10n.PhoneNumberRegistration.Description.line1)
                .font(.system(.body, design: .rounded))
                .foregroundColor(Asset.Color.Application.foreground.swiftUIColor.opacity(Opacity.secondaryText))
                .offset(y: formAppeared ? 0 : Layout.subtitleOffsetY)
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
        // 横からスライドインするアニメーション
        .offset(x: formAppeared ? 0 : Layout.formOffset)
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
                isRequired: true
            )
            .keyboardType(.phonePad)
            .focused($isPhoneFocused)
            // フォーカス時の拡大エフェクト
            .scaleEffect(isPhoneFocused ? Effects.focusScale : 1.0)
            .animation(.spring(
                response: AnimationParameters.springResponse,
                dampingFraction: AnimationParameters.springDampingMedium),
                       value: isPhoneFocused
            )
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
                        Asset.Color.Application.foreground.swiftUIColor.opacity(Opacity.disabledText))
                    .font(.title2)
            })
            
            // プライバシーポリシーテキスト（タップでWebページを開く）
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
        // チェック時の拡大とボーダーハイライト
        .scaleEffect(isPrivacyPolicyAgreed ? Effects.focusScale : 1.0)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(
                    isPrivacyPolicyAgreed ? 
                    Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor : Color.clear,
                    lineWidth: BorderWidth.extraThick
                )
                .animation(.easeInOut(duration: AnimationDuration.fast), value: isPrivacyPolicyAgreed)
        )
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
                    // 触覚フィードバック（中程度の強さ）
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    Task {
                        await viewModel.sendAuthenticationCode()
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
