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
        static let iconSize: CGFloat = 100
        
        /// グロー効果のサイズ
        static let glowSize: CGFloat = 120
        
        /// グロー効果のぼかし半径
        static let glowBlurRadius: CGFloat = 10
        
        /// シャドウの半径
        static let shadowRadius: CGFloat = 20
        
        /// シャドウのY方向オフセット
        static let shadowYOffset: CGFloat = 10
        
        /// シャドウの透明度
        static let shadowOpacity: Double = 0.4
        
        /// グロー効果の透明度
        static let glowOpacity: Double = 0.3
        
        /// 回転アニメーションの継続時間
        static let rotationDuration: Double = 0.5
        
        /// グローアニメーションの継続時間
        static let glowDuration: Double = 2.0
        
        /// 初期スケール（表示前）
        static let initialScale: CGFloat = 0.5
        
        /// 表示アニメーションの継続時間
        static let appearDuration: Double = 0.8
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
                dampingFraction: 0.6
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
                    startRadius: 20,
                    endRadius: 60
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
                perspective: 0.5
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
        glowScale = 1.1
    }
    
    /// タップ時の処理
    private func handleTap() {
        withAnimation(
            .spring(
                response: Constants.rotationDuration,
                dampingFraction: 0.6
            )
        ) {
            rotation += 360
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
