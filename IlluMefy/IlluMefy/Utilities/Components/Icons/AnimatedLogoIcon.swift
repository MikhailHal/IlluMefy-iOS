//
//  AnimatedLogoIcon.swift
//  IlluMefy
//
//  アニメーション付きロゴアイコンコンポーネント
//

import SwiftUI

/// アニメーション付きのロゴアイコン
/// タップで回転、グロー効果付き
struct AnimatedLogoIcon: View {
    // MARK: - Properties
    
    /// アイコンの回転角度
    @State private var rotation: Double = 0
    
    /// グロー効果のスケール
    @State private var glowScale: CGFloat = 1.0
    
    /// 表示アニメーションの状態
    @Binding var isAppeared: Bool
    
    // MARK: - Constants
    
    private enum Constants {
        /// アイコンのサイズ
        static let iconSize: CGFloat = Size.iconLarge
        
        /// グロー効果のサイズ
        static let glowSize: CGFloat = Size.iconGlow
        
        /// グロー効果のぼかし半径
        static let glowBlurRadius: CGFloat = Effects.blurRadius
        
        /// シャドウの半径
        static let shadowRadius: CGFloat = Shadow.radiusXLarge
        
        /// シャドウのY方向オフセット
        static let shadowYOffset: CGFloat = Shadow.offsetYXLarge
        
        /// シャドウの透明度
        static let shadowOpacity: Double = Opacity.shadow
        
        /// グロー効果の透明度
        static let glowOpacity: Double = Opacity.glow
        
        /// 回転アニメーションの継続時間
        static let rotationDuration: Double = AnimationDuration.normal
        
        /// グローアニメーションの継続時間
        static let glowDuration: Double = AnimationDuration.glow
        
        /// 初期スケール（表示前）
        static let initialScale: CGFloat = Effects.initialScale
        
        /// 表示アニメーションの継続時間
        static let appearDuration: Double = AnimationDuration.slow
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // グロー効果（背景の光）
            glowEffect
            
            // メインアイコン
            mainIcon
        }
        // 表示アニメーション用のスケールとフェード
        .scaleEffect(isAppeared ? 1 : Constants.initialScale)
        .opacity(isAppeared ? 1 : 0)
        .animation(
            .spring(
                response: Constants.appearDuration,
                dampingFraction: AnimationParameters.springDamping
            ),
            value: isAppeared
        )
        .onAppear {
            // グローアニメーション開始
            startGlowAnimation()
        }
    }
    
    // MARK: - Subviews
    
    /// グロー効果のビュー
    private var glowEffect: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor
                            .opacity(Constants.glowOpacity),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: Layout.gradientStartRadius,
                    endRadius: Layout.gradientEndRadius
                )
            )
            .frame(
                width: Constants.glowSize,
                height: Constants.glowSize
            )
            .blur(radius: Constants.glowBlurRadius)
            .scaleEffect(glowScale)
            .animation(
                .easeInOut(duration: Constants.glowDuration)
                    .repeatForever(autoreverses: true),
                value: glowScale
            )
    }
    
    /// メインアイコンのビュー
    private var mainIcon: some View {
        Image(Asset.Assets.illuMefyIconMedium.name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(
                width: Constants.iconSize,
                height: Constants.iconSize
            )
            // 3D回転エフェクト
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 0, y: 1, z: 0),
                perspective: Effects.perspective
            )
            // シャドウ効果
            .shadow(
                color: Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor
                    .opacity(Constants.shadowOpacity),
                radius: Constants.shadowRadius,
                y: Constants.shadowYOffset
            )
            // タップジェスチャー
            .onTapGesture {
                handleTap()
            }
    }
    
    // MARK: - Private Methods
    
    /// グローアニメーションを開始
    private func startGlowAnimation() {
        glowScale = Effects.glowScale
    }
    
    /// タップ時の処理
    private func handleTap() {
        withAnimation(
            .spring(
                response: Constants.rotationDuration,
                dampingFraction: AnimationParameters.springDamping
            )
        ) {
            rotation += Effects.rotation360
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var isAppeared = true
    
    return AnimatedLogoIcon(isAppeared: $isAppeared)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
}
