//
//  AnimatedGradientBackground.swift
//  IlluMefy
//
//  アニメーション付きグラデーション背景コンポーネント
//

import SwiftUI

/// アニメーション付きグラデーション背景
/// 画面全体の背景として使用し、ゆっくりと色が変化する効果を提供
struct AnimatedGradientBackground: View {
    // MARK: - Properties
    
    /// アニメーションの状態を管理
    @State private var isAnimating = false
    
    // MARK: - Constants
    
    private enum Constants {
        /// アニメーションの継続時間（秒）
        static let animationDuration: Double = AnimationDuration.gradient
        
        /// グラデーションの開始色の透明度
        static let startColorOpacity: Double = Opacity.gradientStart
        
        /// グラデーションの終了色の透明度
        static let endColorOpacity: Double = Opacity.gradientEnd
    }
    
    // MARK: - Body
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                // 開始色：プライマリカラーの薄い色
                Asset.Color.Application.Background.background.swiftUIColor,
                // 中間色：セカンダリカラーの薄い色
                Asset.Color.Application.Background.gradientStart.swiftUIColor
                    .opacity(Constants.startColorOpacity),
                // 終了色：背景色
                Asset.Color.Application.Background.gradientEnd.swiftUIColor
                    .opacity(Constants.endColorOpacity)
            ]),
            // アニメーションに合わせて開始点と終了点を入れ替える
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea() // セーフエリアを無視して全画面に表示
    }
}

// MARK: - Preview
#Preview {
    AnimatedGradientBackground()
}
