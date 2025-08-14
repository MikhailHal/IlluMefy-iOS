//
//  HomeView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//
import SwiftUI
import UIKit
import Shimmer

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
            background
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
                    
                    // New Arrival Creators Section
                    sectionHeader(title: L10n.Home.recentlyAddedCreators)
                    newArrivalCreatorsSection
                        .padding(.bottom, Spacing.screenEdgePadding)
                    
                    // Recommended Creators Section
                    sectionHeader(title: L10n.Home.recommendedCreators)
                    recommendedCreatorsSection
                        .padding(.bottom, Spacing.unrelatedComponentDivider)
                }
            }
            .scrollIndicators(.hidden)
        }
        .onAppear {
            Task {
                await viewModel.loadInitialData()
            }
        }
    }

    /// 背景
    private var background: some View {
        ZStack {
            AnimatedGradientBackground()
            FloatingParticlesView()
        }
    }
    // MARK: - Featured/Hero Section
    
    private var featuredSection: some View {
        Group {
            if let featuredCreator = viewModel.popularCreators.first {
                FeaturedCreatorView(creator: featuredCreator)
                    .frame(height: 350)
            } else {
                RoundedRectangle(cornerRadius: CornerRadius.button)
                    .fill(Asset.Color.FeaturedCreatorCard.featuredCreatorCardBackground.swiftUIColor)
                    .frame(height: 350)
                    .padding(.horizontal, Spacing.screenEdgePadding)
                    .shimmering()
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
                if viewModel.isLoading {
                    ForEach(0..<6, id: \.self) { _ in
                        IlluMefyFeaturedTag(tag: nil, onTapped: onTagTapped)
                    }
                } else {
                    ForEach(viewModel.popularTags) { tag in
                        IlluMefyFeaturedTag(tag: tag, onTapped: onTagTapped)
                    }
                }
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
        }
    }
    
    private var popularCreatorsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.componentGrouping) {
                if viewModel.isLoading {
                    ForEach(0..<5, id: \.self) { _ in
                        CreatorTile(creator: nil)
                    }
                } else {
                    ForEach(viewModel.popularCreators) { creator in
                        CreatorTile(creator: creator)
                    }
                }
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
        }
    }
    
    private var recommendedCreatorsSection: some View {
        ScrollView {
            HStack(spacing: Spacing.componentGrouping) {
                ForEach(0..<5, id: \.self) { _ in
                    CreatorTile(creator: nil)
                }
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
        }
    }
    
    private var newArrivalCreatorsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.componentGrouping) {
                if viewModel.isLoading {
                    ForEach(0..<5, id: \.self) { _ in
                        CreatorTile(creator: nil)
                    }
                } else {
                    ForEach(viewModel.newArrivalCreators) { creator in
                        CreatorTile(creator: creator)
                    }
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
            AsyncImage(url: URL(string: creator.thumbnailUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(Opacity.glow))
                    .shimmering()
            }
            .clipped()
            .frame(maxHeight: 350)
            
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
                    Button(action: {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                        impactFeedback.impactOccurred()
                        router.navigate(to: .creatorDetail(creatorId: creator.id))
                    }, label: {
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
                    })
                }
            }
            .padding(Spacing.screenEdgePadding)
        }
        .cornerRadius(CornerRadius.button)
        .padding(.horizontal, Spacing.screenEdgePadding)
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
