//
//  IlluMefyButtonStyle.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import SwiftUI

/// IlluMefy標準ボタンスタイル
/// グラデーション背景とアニメーション効果を提供
struct IlluMefyButtonStyle: ButtonStyle {
    
    // MARK: - Properties
    
    /// ボタンの有効/無効状態
    let isEnabled: Bool
    
    /// ボタンのサイズタイプ
    enum Size {
        case regular
        case small
        
        var verticalPadding: CGFloat {
            switch self {
            case .regular:
                return Spacing.relatedComponentDivider
            case .small:
                return Spacing.componentGrouping
            }
        }
    }
    
    let size: Size
    
    // MARK: - Initializer
    
    init(isEnabled: Bool = true, size: Size = .regular) {
        self.isEnabled = isEnabled
        self.size = size
    }
    
    // MARK: - ButtonStyle Implementation
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: Typography.bodyRegular, weight: .medium))
            .foregroundColor(
                isEnabled ?
                    Asset.Color.Button.buttonForeground.swiftUIColor :
                    Asset.Color.Button.buttonForegroundForDisabled.swiftUIColor
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, size.verticalPadding)
            .background(buttonBackground)
            .cornerRadius(CornerRadius.button)
            .scaleEffect(
                configuration.isPressed && isEnabled ?
                    Effects.scalePressed :
                    Effects.visibleOpacity
            )
            .animation(
                .easeInOut(duration: AnimationDuration.buttonPress),
                value: configuration.isPressed
            )
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private var buttonBackground: some View {
        if isEnabled {
            LinearGradient(
                colors: [
                    Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor,
                    Asset.Color.Button.buttonBackgroundGradationEnd.swiftUIColor
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            Asset.Color.Button.buttonBackgroundDisable.swiftUIColor
        }
    }
}

// MARK: - View Extension

extension View {
    /// IlluMefyButtonStyleを適用
    /// - Parameters:
    ///   - isEnabled: ボタンの有効/無効状態
    ///   - size: ボタンのサイズ
    func illuMefyButtonStyle(
        isEnabled: Bool = true,
        size: IlluMefyButtonStyle.Size = .regular
    ) -> some View {
        self.buttonStyle(IlluMefyButtonStyle(isEnabled: isEnabled, size: size))
    }
}

// MARK: - Preview

#Preview("Enabled State") {
    VStack(spacing: Spacing.unrelatedComponentDivider) {
        Button("有効なボタン") {
            print("Tapped")
        }
        .illuMefyButtonStyle(isEnabled: true)
        .padding(.horizontal, Spacing.screenEdgePadding)
        
        Button("小さいボタン") {
            print("Tapped")
        }
        .illuMefyButtonStyle(isEnabled: true, size: .small)
        .padding(.horizontal, Spacing.screenEdgePadding)
    }
    .background(Asset.Color.Application.Background.backgroundPrimary.swiftUIColor)
}

#Preview("Disabled State") {
    Button("無効なボタン") {
        print("Tapped")
    }
    .illuMefyButtonStyle(isEnabled: false)
    .disabled(true)
    .padding(.horizontal, Spacing.screenEdgePadding)
    .background(Asset.Color.Application.Background.backgroundPrimary.swiftUIColor)
}
