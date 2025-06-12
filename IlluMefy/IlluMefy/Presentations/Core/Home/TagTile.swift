//
//  TagTile.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/11.
//

import SwiftUI

struct TagTile: View {
    let tag: Tag
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Tag name with popularity pulse
            Text("#\(tag.displayName)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
                .scaleEffect(isPopular ? (isAnimating ? 1.05 : 1.0) : 1.0)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
            
            // Click count with number animation
            HStack(spacing: 4) {
                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.8))
                
                Text(formatClickCount(tag.clickedCount))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .contentTransition(.numericText())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .onAppear {
            if isPopular {
                isAnimating = true
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var isPopular: Bool {
        tag.clickedCount > 500 // 人気閾値
    }
    
    private var gradientColors: [Color] {
        if isPopular {
            return [.orange, .red] // 人気タグは暖色
        } else {
            return [.blue.opacity(0.8), .purple.opacity(0.8)] // 通常は寒色
        }
    }
    
    // MARK: - Helper Functions
    
    private func formatClickCount(_ count: Int) -> String {
        if count >= 1000000 {
            return String(format: "%.1fM", Double(count) / 1000000)
        } else if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000)
        } else {
            return "\(count)"
        }
    }
}

#Preview {
    HStack {
        TagTile(tag: Tag(
            id: "1",
            displayName: "FPS",
            tagName: "fps",
            clickedCount: 1200,
            createdAt: Date(),
            updatedAt: Date(),
            parentTagId: nil,
            childTagIds: []
        ))
        
        TagTile(tag: Tag(
            id: "2",
            displayName: "VTuber",
            tagName: "vtuber",
            clickedCount: 890,
            createdAt: Date(),
            updatedAt: Date(),
            parentTagId: nil,
            childTagIds: []
        ))
        
        TagTile(tag: Tag(
            id: "3",
            displayName: "Minecraft",
            tagName: "minecraft",
            clickedCount: 250,
            createdAt: Date(),
            updatedAt: Date(),
            parentTagId: nil,
            childTagIds: []
        ))
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
