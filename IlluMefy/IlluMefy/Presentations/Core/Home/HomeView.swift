//
//  HomeView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//
import SwiftUI
import UIKit

struct HomeView: View {
    @StateObject private var viewModel =
    DependencyContainer.shared.resolve(HomeViewModel.self)!
    @EnvironmentObject private var router: IlluMefyAppRouter
    
    let onTagTapped: ((Tag) -> Void)?
    
    init(onTagTapped: ((Tag) -> Void)? = nil) {
        self.onTagTapped = onTagTapped
    }
    
    var body: some View {
        ZStack {
            // Netflix-style dark background
            Asset.Color.Application.Background.backgroundPrimary.swiftUIColor
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    // Featured/Hero Section
                    featuredSection
                        .padding(.bottom, Spacing.unrelatedComponentDivider)
                    
                    // Popular Tags Section
                    sectionHeader(title: L10n.Home.popularTags)
                    popularTagsSection
                        .padding(.bottom, Spacing.unrelatedComponentDivider)
                    
                    // Popular Creators Section
                    sectionHeader(title: L10n.Home.popularCreators)
                    popularCreatorsSection
                        .padding(.bottom, Spacing.unrelatedComponentDivider)
                    
                    // Recommended Creators Section
                    sectionHeader(title: L10n.Home.recommendedCreators)
                    recommendedCreatorsSection
                        .padding(.bottom, Spacing.unrelatedComponentDivider)
                    
                    // New Arrival Creators Section
                    sectionHeader(title: L10n.Home.recentlyAddedCreators)
                    newArrivalCreatorsSection
                        .padding(.bottom, Spacing.screenEdgePadding)
                }
            }
            .scrollIndicators(.hidden)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }

    // MARK: - Featured/Hero Section
    
    private var featuredSection: some View {
        Group {
            if let featuredCreator = viewModel.popularCreators.first {
                FeaturedCreatorView(creator: featuredCreator)
                    .frame(height: 400)
            } else {
                RoundedRectangle(cornerRadius: CornerRadius.button)
                    .fill(Asset.Color.FeaturedCreatorCard.featuredCreatorCardBackground.swiftUIColor)
                    .frame(height: 400)
                    .overlay(
                        VStack {
                            Image(systemName: "play.rectangle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(Asset.Color.FeaturedCreatorCard.featuredCreatorCardTitle.swiftUIColor)
                            Text(L10n.Home.featuredContent)
                                .font(.title2)
                                .foregroundColor(Asset.Color.FeaturedCreatorCard.featuredCreatorCardTitle.swiftUIColor)
                        }
                    )
                    .padding(.horizontal, Spacing.screenEdgePadding)
            }
        }
    }
    
    // MARK: - Section Header
    
    private func sectionHeader(title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: Typography.titleMedium, weight: .bold))
                .foregroundColor(Asset.Color.HomeSection.homeSectionTitle.swiftUIColor)
            
            Spacer()
        }
        .padding(.horizontal, Spacing.screenEdgePadding)
        .padding(.bottom, Spacing.componentGrouping)
    }
    
    // MARK: - Content Sections
    
    private var popularTagsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.componentGrouping) {
                ForEach(viewModel.popularTags) { tag in
                    FeaturedTagTile(tag: tag, onTapped: onTagTapped)
                }
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
        }
    }
    
    private var popularCreatorsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.componentGrouping) {
                ForEach(viewModel.popularCreators) { creator in
                    CreatorCard(creator: creator)
                }
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
        }
    }
    
    private var recommendedCreatorsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.componentGrouping) {
                ForEach(viewModel.recommendedCreators) { creator in
                    CreatorCard(creator: creator)
                }
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
        }
    }
    
    private var newArrivalCreatorsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.componentGrouping) {
                ForEach(viewModel.newArrivalCreators) { creator in
                    CreatorCard(creator: creator)
                }
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
        }
    }
}

// MARK: - Featured Creator Component

struct FeaturedCreatorView: View {
    let creator: Creator
    @EnvironmentObject private var router: IlluMefyAppRouter
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background image
            AsyncImage(url: URL(string: creator.thumbnailUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Asset.Color.FeaturedCreatorCard.featuredCreatorCardBackground.swiftUIColor)
                    .overlay(
                        ProgressView()
                            .tint(Asset.Color.FeaturedCreatorCard.featuredCreatorCardTitle.swiftUIColor)
                    )
            }
            .clipped()
            
            // Gradient overlay
            LinearGradient(
                colors: [
                    .clear,
                    Asset.Color.FeaturedCreatorCard.featuredCreatorCardOverlay.swiftUIColor.opacity(0.3),
                    Asset.Color.FeaturedCreatorCard.featuredCreatorCardOverlay.swiftUIColor.opacity(0.8)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Content overlay
            VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
                Text(creator.name)
                    .font(.system(size: Typography.titleLarge, weight: .bold))
                    .foregroundColor(Asset.Color.FeaturedCreatorCard.featuredCreatorCardTitle.swiftUIColor)
                    .lineLimit(2)
                
                if let description = creator.description {
                    Text(description)
                        .font(.system(size: Typography.bodyRegular))
                        .foregroundColor(Asset.Color.FeaturedCreatorCard.featuredCreatorCardSubtitle.swiftUIColor)
                        .lineLimit(3)
                }
                
                HStack(spacing: Spacing.componentGrouping) {
                    // Play button
                    Button(action: {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                        impactFeedback.impactOccurred()
                        router.navigate(to: .creatorDetail(creatorId: creator.id))
                    }) {
                        HStack(spacing: Spacing.relatedComponentDivider) {
                            Image(systemName: "play.fill")
                                .font(.system(size: Typography.bodyRegular, weight: .bold))
                            Text(L10n.Home.viewProfile)
                                .font(.system(size: Typography.bodyRegular, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, Spacing.medium)
                        .padding(.vertical, Spacing.componentGrouping)
                        .background(.white)
                        .cornerRadius(CornerRadius.button)
                    }
                }
            }
            .padding(Spacing.screenEdgePadding)
        }
        .cornerRadius(CornerRadius.button)
        .padding(.horizontal, Spacing.screenEdgePadding)
    }
}

// MARK: - Creator Card Component

struct CreatorCard: View {
    let creator: Creator
    @State private var isHovered = false
    @EnvironmentObject private var router: IlluMefyAppRouter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image section
            AsyncImage(url: URL(string: creator.thumbnailUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(16/9, contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Asset.Color.CreatorCard.creatorCardBackground.swiftUIColor)
                    .aspectRatio(16/9, contentMode: .fit)
                    .overlay(
                        ProgressView()
                            .tint(Asset.Color.CreatorCard.creatorCardTitle.swiftUIColor)
                    )
            }
            .clipped()
            
            // Info section
            VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
                Text(creator.name)
                    .font(.system(size: Typography.bodyRegular, weight: .semibold))
                    .foregroundColor(Asset.Color.CreatorCard.creatorCardTitle.swiftUIColor)
                    .lineLimit(1)
                
                HStack {
                    // Platform icon
                    let platform = creator.mainPlatform().0
                    if platform == .youtube {
                        Image(systemName: platform.icon)
                            .font(.system(size: Typography.captionSmall))
                            .foregroundColor(.red)
                    } else {
                        Image(platform.icon)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(Asset.Color.Application.accent.swiftUIColor)
                    }
                    
                    Text(formatViewCount(creator.viewCount))
                        .font(.system(size: Typography.captionSmall))
                        .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor)
                    
                    Spacer()
                }
            }
            .padding(Spacing.componentGrouping)
            .background(Asset.Color.CreatorCard.creatorCardBackground.swiftUIColor)
        }
        .frame(width: 200)
        .cornerRadius(CornerRadius.button)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.button)
                .stroke(Asset.Color.CreatorCard.creatorCardBorder.swiftUIColor, lineWidth: 1)
        )
        .shadow(
            color: Asset.Color.CreatorCard.creatorCardShadow.swiftUIColor,
            radius: isHovered ? 12 : 4,
            x: 0,
            y: isHovered ? 8 : 2
        )
        .scaleEffect(isHovered ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            router.navigate(to: .creatorDetail(creatorId: creator.id))
        }
        .onHover { hovering in
            isHovered = hovering
        }
    }
    
    private func formatViewCount(_ count: Int) -> String {
        if count >= 1000000 {
            return L10n.Common.viewCountMillion(String(format: "%.1f", Double(count) / 1000000))
        } else if count >= 1000 {
            return L10n.Common.viewCountThousand(String(format: "%.1f", Double(count) / 1000))
        } else {
            return L10n.Common.viewCount(count)
        }
    }
}

// MARK: - Featured Tag Tile Component

struct FeaturedTagTile: View {
    let tag: Tag
    let onTapped: ((Tag) -> Void)?
    @State private var isPressed = false
    
    var body: some View {
        Text("#\(tag.displayName)")
            .font(.system(size: Typography.bodyRegular, weight: .medium))
            .foregroundColor(Asset.Color.Tag.tagText.swiftUIColor)
            .padding(.horizontal, Spacing.medium)
            .padding(.vertical, Spacing.componentGrouping)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.tag)
                    .fill(isPressed ? Asset.Color.Tag.tagBackgroundSelected.swiftUIColor : Asset.Color.Tag.tagBackground.swiftUIColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.tag)
                    .stroke(Asset.Color.Tag.tagBorder.swiftUIColor, lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .onTapGesture {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                onTapped?(tag)
            }
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
                isPressed = pressing
            } perform: {}
    }
}

extension View {
    func sectionScrollTransition() -> some View {
        self.scrollTransition { content, phase in
            content
                .opacity(phase.isIdentity ? Effects.visibleOpacity : Effects.dimmedOpacity)
                .scaleEffect(phase.isIdentity ? Effects.visibleOpacity : Effects.scaledDown)
        }
    }
}

#Preview {
    HomeView()
}
