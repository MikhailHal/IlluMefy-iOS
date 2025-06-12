//
//  CreatorDetailView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/13.
//

import SwiftUI

struct CreatorDetailView: View {
    let creator: Creator
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorite = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.unrelatedComponentDivider) {
                // Header section with close button
                headerSection
                
                // Creator profile section
                creatorProfileSection
                
                // Platform buttons section
                platformButtonsSection
                
                // Tags section
                tagsSection
                
                // Tag registration section
                tagRegistrationSection
                
                // Information correction section
                informationCorrectionSection
                
                // Stats section
                statsSection
                
                // Similar creators section
                similarCreatorsSection
            }
            .padding(Spacing.screenEdgePadding)
        }
        .background(Asset.Color.Application.Background.background.swiftUIColor)
        .navigationBarHidden(true)
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        HStack {
            Spacer()
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.primary.opacity(0.6))
            })
        }
    }
    
    private var creatorProfileSection: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            // Creator image
            AsyncImage(url: URL(string: creator.thumbnailUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        ProgressView()
                    )
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
            )
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // Creator name with favorite button
            HStack(spacing: 12) {
                Text(creator.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isFavorite.toggle()
                    }
                }, label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(isFavorite ? .red : .primary.opacity(0.7))
                        .scaleEffect(isFavorite ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isFavorite)
                })
            }
            
            // Main platform indicator
            HStack {
                let (platform, _) = creator.mainPlatform()
                if platform == .youtube {
                    Image(systemName: platform.icon)
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                } else {
                    Image(platform.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                }
                Text(L10n.CreatorDetail.mainPlatform)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var platformButtonsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.snsLinks)
                .font(.headline)
                .bold()
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.relatedComponentDivider) {
                ForEach(Array(creator.platform.keys), id: \.self) { platform in
                    if let url = creator.platform[platform] {
                        PlatformButton(platform: platform, url: url)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.relatedTags)
                .font(.headline)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(creator.relatedTag, id: \.self) { tag in
                        TagChip(tagName: tag, isEditing: false) {
                            // タグ削除アクション
                        }
                    }
                }
                .padding(.trailing, Spacing.screenEdgePadding)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var tagRegistrationSection: some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.tagApplication)
                .font(.headline)
                .bold()
            
            Text(L10n.CreatorDetail.tagApplicationDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: Spacing.relatedComponentDivider) {
                Button(action: {
                    // タグ削除申請画面への遷移
                }, label: {
                    HStack {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 16))
                        Text(L10n.CreatorDetail.tagDeleteApplication)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.primary.opacity(0.2), lineWidth: 1)
                    )
                })
                
                Button(action: {
                    // タグ申請画面への遷移
                }, label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16))
                        Text(L10n.CreatorDetail.tagAddApplication)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [
                                Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor,
                                Asset.Color.Button.buttonBackgroundGradationEnd.swiftUIColor
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                })
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var informationCorrectionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.informationCorrection)
                .font(.headline)
                .bold()
            
            Text(L10n.CreatorDetail.informationCorrectionDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                InfoCorrectionButton(
                    title: L10n.InformationCorrection.profileCorrection,
                    description: L10n.InformationCorrection.profileCorrectionDescription,
                    icon: "person.circle",
                    action: {
                        // プロフィール修正画面への遷移
                    }
                )
                
                InfoCorrectionButton(
                    title: L10n.InformationCorrection.snsLinksCorrection,
                    description: L10n.InformationCorrection.snsLinksCorrectionDescription,
                    icon: "link.circle",
                    action: {
                        // SNSリンク修正画面への遷移
                    }
                )
                
                InfoCorrectionButton(
                    title: L10n.InformationCorrection.activityStatusReport,
                    description: L10n.InformationCorrection.activityStatusReportDescription,
                    icon: "exclamationmark.circle",
                    action: {
                        // 活動状況報告画面への遷移
                    }
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var statsSection: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.statistics)
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: Spacing.unrelatedComponentDivider) {
                StatCard(
                    title: L10n.CreatorDetail.totalViews,
                    value: formatViewCount(creator.viewCount),
                    icon: "eye.fill"
                )
                
                StatCard(
                    title: L10n.CreatorDetail.snsClicks,
                    value: formatViewCount(creator.socialLinkClickCount),
                    icon: "link"
                )
                
                StatCard(
                    title: L10n.CreatorDetail.platforms,
                    value: "\(creator.platform.count)",
                    icon: "square.grid.2x2"
                )
            }
        }
    }
    
    private var similarCreatorsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.similarCreators)
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(L10n.CreatorDetail.similarCreatorsDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.relatedComponentDivider) {
                    ForEach(getSimilarCreators()) { similarCreator in
                        SimilarCreatorCard(creator: similarCreator)
                    }
                }
                .padding(.trailing, Spacing.screenEdgePadding)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func formatViewCount(_ count: Int) -> String {
        if count >= 1000000 {
            return String(format: "%.1fM", Double(count) / 1000000)
        } else if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000)
        } else {
            return "\(count)"
        }
    }
    
    private func getSimilarCreators() -> [Creator] {
        // Mock similar creators based on common tags
        return [
            createSimilarCreator1(),
            createSimilarCreator2(),
            createSimilarCreator3()
        ]
    }
    
    private func createSimilarCreator1() -> Creator {
        return Creator(
            id: "similar_001",
            name: "類似ゲーマーA",
            thumbnailUrl: "https://picsum.photos/200/200?random=10",
            viewCount: 8500,
            socialLinkClickCount: 1200,
            platformClickRatio: [.youtube: 0.6, .twitch: 0.4],
            relatedTag: creator.relatedTag.prefix(2) + ["gaming"],
            description: "同じジャンルで活動中",
            platform: [
                .youtube: "https://youtube.com/@similarA",
                .twitch: "https://twitch.tv/similarA"
            ],
            createdAt: Date().addingTimeInterval(-86400 * 20),
            updatedAt: Date().addingTimeInterval(-3600 * 2),
            isActive: true
        )
    }
    
    private func createSimilarCreator2() -> Creator {
        return Creator(
            id: "similar_002",
            name: "類似配信者B",
            thumbnailUrl: "https://picsum.photos/200/200?random=11",
            viewCount: 6200,
            socialLinkClickCount: 900,
            platformClickRatio: [.twitch: 0.7, .youtube: 0.3],
            relatedTag: creator.relatedTag.suffix(2) + ["streaming"],
            description: "人気配信者",
            platform: [
                .twitch: "https://twitch.tv/similarB",
                .youtube: "https://youtube.com/@similarB"
            ],
            createdAt: Date().addingTimeInterval(-86400 * 40),
            updatedAt: Date().addingTimeInterval(-3600 * 5),
            isActive: true
        )
    }
    
    private func createSimilarCreator3() -> Creator {
        return Creator(
            id: "similar_003",
            name: "類似VTuberC",
            thumbnailUrl: "https://picsum.photos/200/200?random=12",
            viewCount: 9800,
            socialLinkClickCount: 1800,
            platformClickRatio: [.youtube: 0.8, .x: 0.2],
            relatedTag: creator.relatedTag.randomElement().map { [$0, "entertainment"] } ?? ["entertainment"],
            description: "エンターテイメント系",
            platform: [
                .youtube: "https://youtube.com/@similarC",
                .x: "https://twitter.com/similarC"
            ],
            createdAt: Date().addingTimeInterval(-86400 * 25),
            updatedAt: Date().addingTimeInterval(-3600 * 1),
            isActive: true
        )
    }
}

#Preview {
    CreatorDetailView(creator: Creator(
        id: "creator_001",
        name: "ゲーム実況者A",
        thumbnailUrl: "https://picsum.photos/200/200?random=1",
        viewCount: 5000,
        socialLinkClickCount: 1500,
        platformClickRatio: [
            .niconico: 0.6,
            .youtube: 0.3,
            .x: 0.1
        ],
        relatedTag: ["fps", "apex-legends", "valorant", "gaming", "gaming", "gaming", "gaming", "gaming"],
        description: "FPSゲームをメインに実況しています。毎日20時から配信！初心者から上級者まで楽しめるコンテンツを心がけています。",
        platform: [
            .niconico: "https://www.nicovideo.jp/user/12345678",
            .youtube: "https://youtube.com/@gameplayerA",
            .twitch: "https://twitch.tv/gameplayerA",
            .x: "https://twitter.com/gameplayerA",
            .instagram: "https://instagram.com/gameplayerA",
            .tiktok: "https://tiktok.com/@gameplayerA"
        ],
        createdAt: Date().addingTimeInterval(-86400 * 30),
        updatedAt: Date().addingTimeInterval(-3600),
        isActive: true
    ))
}
