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
        .alert("アカウント登録失敗", isPresented: $viewModel.isShowErrorDialog) {
            Button("OK") { viewModel.isShowErrorDialog = false }
        } message: {
            Text(viewModel.errorDialogMessage)
        }
        // 成功ダイアログ
        .alert("アカウント登録成功", isPresented: $viewModel.isShowNotificationDialog) {
            Button("OK") {
                viewModel.isShowNotificationDialog = false
                router.navigate(to: .login)
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
    
    /// 電話番号入力値
    @State private var phoneNumber = ""
    
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
        .onChange(of: phoneNumber) { _, _ in
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
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                .padding(.top, Spacing.componentGrouping)
                .offset(y: formAppeared ? 0 : 20)
                .opacity(formAppeared ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.3), value: formAppeared)
            
            // 説明文（2段階のフェードイン）
            VStack(spacing: 6) {
                // 1行目の説明
                Text(L10n.PhoneNumberRegistration.Description.line1)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(Asset.Color.Application.foreground.swiftUIColor.opacity(0.85))
                    .offset(y: formAppeared ? 0 : 10)
                    .opacity(formAppeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.5), value: formAppeared)
                
                // 2行目の説明
                Text(L10n.PhoneNumberRegistration.Description.line2)
                    .font(.system(.callout, design: .rounded))
                    .foregroundColor(Asset.Color.Application.foreground.swiftUIColor.opacity(0.65))
                    .offset(y: formAppeared ? 0 : 10)
                    .opacity(formAppeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.7), value: formAppeared)
            }
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
        .offset(x: formAppeared ? 0 : -50)
        .opacity(formAppeared ? 1 : 0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.9), value: formAppeared)
    }
    
    /// 電話番号入力フィールド
    private var phoneNumberField: some View {
        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
            IlluMefyPlainTextField(
                text: $phoneNumber,
                placeHolder: L10n.PhoneNumberRegistration.Input.PhoneNumber.textfield,
                label: L10n.PhoneNumberRegistration.Input.PhoneNumber.label,
                isRequired: true
            )
            .keyboardType(.phonePad)
            .focused($isPhoneFocused)
            // フォーカス時の拡大エフェクト
            .scaleEffect(isPhoneFocused ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPhoneFocused)
        }
    }
    
    /// プライバシーポリシー同意チェックボックス
    private var privacyPolicyCheckbox: some View {
        IlluMefyCardNormal {
            IlluMefyCheckbox(
                isChecked: $isPrivacyPolicyAgreed,
                title: L10n.PhoneNumberRegistration.Checkbox.privacyPolicy
            )
            .padding(.vertical, Spacing.componentGrouping)
        }
        // チェック時の拡大とボーダーハイライト
        .scaleEffect(isPrivacyPolicyAgreed ? 1.02 : 1.0)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isPrivacyPolicyAgreed ? 
                    Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor : Color.clear,
                    lineWidth: 2
                )
                .animation(.easeInOut(duration: 0.3), value: isPrivacyPolicyAgreed)
        )
    }
                
    /// アクションセクション（ボタンとリンク）
    private var actionSection: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            // メインアクションボタン（認証へ進む）
            primaryActionButton
                    
            // ログインリンク
            loginLink
        }
        .padding(.top, Spacing.unrelatedComponentDivider)
        .padding(.bottom, Spacing.screenEdgePadding * 2)
    }
    
    /// プライマリアクションボタン（パルスエフェクト付き）
    private var primaryActionButton: some View {
        ZStack {
            // ボタンが有効な時のパルスエフェクト
            if !phoneNumber.isEmpty && isPrivacyPolicyAgreed {
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
                        value: isPrivacyPolicyAgreed
                    )
            }
            
            // メインボタン
            IlluMefyButton(
                title: L10n.PhoneNumberRegistration.Button.verification,
                isEnabled: !phoneNumber.isEmpty && isPrivacyPolicyAgreed,
                action: {
                    // 触覚フィードバック（中程度の強さ）
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    
                    // TODO: 認証処理を実装
                }
            )
            .padding(.horizontal, Spacing.screenEdgePadding)
            // 条件付きシャドウ（有効時はより強く）
            .shadow(
                color: Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor.opacity(0.3),
                radius: !phoneNumber.isEmpty && isPrivacyPolicyAgreed ? 15 : 10,
                y: !phoneNumber.isEmpty && isPrivacyPolicyAgreed ? 8 : 5
            )
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isPrivacyPolicyAgreed)
        }
    }
    
    /// ログインリンクセクション
    private var loginLink: some View {
        HStack {
            // プレフィックステキスト
            Text(L10n.PhoneNumberRegistration.Link.prefix)
                .font(.footnote)
                .foregroundColor(Asset.Color.Application.foreground.swiftUIColor.opacity(0.6))
            
            // ログインリンクボタン
            Button(
                action: {
                    router.navigate(to: .login)
                },
                label: {
                    Text(L10n.PhoneNumberRegistration.Link.login)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor)
                }
            )
        }
        .padding(.top, Spacing.componentGrouping)
    }
}

// MARK: - Preview

#Preview {
    PhoneNumberRegistrationView()
        .environmentObject(IlluMefyAppRouter())
}
