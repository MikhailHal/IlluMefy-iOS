//
//  CreatorDetailComponents.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/13.
//

import SwiftUI
import UIKit

// MARK: - Supporting Views

struct PlatformButton: View {
    let icon: String
    let url: URL
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            UIApplication.shared.open(url)
        }, label: {
            HStack(spacing: 12) {
                Spacer()
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.red)
                Text(L10n.CreatorDetail.openYouTube)
                    .font(.title2)
                    .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
                Image(systemName: "arrow.up.right")
                    .font(.title3)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal, Spacing.medium)
            .padding(.vertical, Spacing.relatedComponentDivider)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(.primary.opacity(Opacity.overlayMedium), lineWidth: BorderWidth.medium)
            )
            .scaleEffect(isPressed ? Effects.scalePressed : Effects.visibleOpacity)
            .animation(.easeInOut(duration: AnimationDuration.buttonPress), value: isPressed)
        })
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(.easeInOut(duration: AnimationDuration.buttonPress)) {
                isPressed = pressing
            }
        } perform: {}
    }
}

