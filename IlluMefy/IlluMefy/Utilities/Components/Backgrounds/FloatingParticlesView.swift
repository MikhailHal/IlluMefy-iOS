//
//  FloatingParticlesView.swift
//  IlluMefy
//
//  浮遊するパーティクルエフェクトコンポーネント
//

import SwiftUI

/// 浮遊するパーティクルを表示するビュー
/// 画面下部から上部へゆっくりと上昇する小さな円を表示
struct FloatingParticlesView: View {
    // MARK: - Properties
    
    /// パーティクルアニメーションの状態
    @State private var isAnimating = false
    
    // MARK: - Constants
    
    private enum Constants {
        /// パーティクルの数
        static let particleCount = Layout.particleCount
        
        /// パーティクルの最小サイズ
        static let minSize: CGFloat = Size.particleMin
        
        /// パーティクルの最大サイズ
        static let maxSize: CGFloat = Size.particleMax
        
        /// パーティクルの透明度
        static let opacity: Double = Opacity.particle
        
        /// アニメーションの最小時間（秒）
        static let minDuration: Double = AnimationDuration.particleMin
        
        /// アニメーションの最大時間（秒）
        static let maxDuration: Double = AnimationDuration.particleMax
        
        /// アニメーションの最大遅延（秒）
        static let maxDelay: Double = AnimationParameters.particleMaxDelay
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<Constants.particleCount, id: \.self) { index in
                // 各パーティクルを作成
                createParticle(
                    index: index,
                    geometrySize: geometry.size
                )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            // ビュー表示時にアニメーション開始
            isAnimating = true
        }
    }
    
    // MARK: - Private Methods
    
    /// 個別のパーティクルを作成
    /// - Parameters:
    ///   - index: パーティクルのインデックス（ランダム値生成用）
    ///   - geometrySize: 親ビューのサイズ
    /// - Returns: アニメーション付きのパーティクルビュー
    private func createParticle(index: Int, geometrySize: CGSize) -> some View {
        Circle()
            .fill(
                Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor
                    .opacity(Constants.opacity)
            )
            // ランダムなサイズを設定
            .frame(
                width: CGFloat.random(in: Constants.minSize...Constants.maxSize)
            )
            .position(
                // X座標：画面幅内でランダム
                x: CGFloat.random(in: 0...geometrySize.width),
                // Y座標：アニメーション前は画面下、アニメーション後は画面上
                y: isAnimating ? -Layout.particleOffsetY : geometrySize.height + Layout.particleOffsetY
            )
            .animation(
                // 各パーティクルに異なる速度と遅延を設定
                .easeInOut(
                    duration: Double.random(
                        in: Constants.minDuration...Constants.maxDuration
                    )
                )
                .repeatForever(autoreverses: false)
                .delay(
                    Double.random(in: 0...Constants.maxDelay)
                ),
                value: isAnimating
            )
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black
        FloatingParticlesView()
    }
}
