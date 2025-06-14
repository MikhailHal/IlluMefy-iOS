//
//  CreatorDetailView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/13.
//

import SwiftUI

struct CreatorDetailView: View {
    @StateObject private var viewModel: CreatorDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var currentCreatorId: String
    @State private var selectedCreatorId: String?
    @State private var showingCreatorDetail = false
    @State private var showingTagApplication = false
    @State private var tagApplicationType: TagApplicationRequest.ApplicationType = .add
    
    init(creatorId: String) {
        let container = DependencyContainer.shared
        guard let viewModel = container.container.resolve(CreatorDetailViewModel.self, argument: creatorId) else {
            fatalError("Failed to resolve CreatorDetailViewModel for creatorId: \(creatorId)")
        }
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._currentCreatorId = State(initialValue: creatorId)
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                loadingView
            case .loaded(let creator, let similarCreators):
                contentView(creator: creator, similarCreators: similarCreators)
            case .error(let title, let message):
                errorView(title: title, message: message)
            }
        }
        .background(Asset.Color.Application.Background.background.swiftUIColor)
        .navigationBarHidden(true)
        .sheet(isPresented: $showingCreatorDetail) {
            if let selectedCreatorId = selectedCreatorId {
                NavigationStack {
                    CreatorDetailView(creatorId: selectedCreatorId)
                }
            }
        }
        .sheet(isPresented: $showingTagApplication) {
            if case .loaded(let creator, _) = viewModel.state {
                TagApplicationView(creator: creator, applicationType: tagApplicationType)
            }
        }
        .task {
            await viewModel.loadCreatorDetail()
        }
    }
    
    // MARK: - State Views
    
    private var loadingView: some View {
        VStack(spacing: Spacing.unrelatedComponentDivider) {
            headerSection
            Spacer()
            ProgressView()
                .scaleEffect(Effects.scaleIcon)
            Text("読み込み中...")
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(Spacing.screenEdgePadding)
    }
    
    private func errorView(title: String, message: String) -> some View {
        VStack(spacing: Spacing.unrelatedComponentDivider) {
            headerSection
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: Typography.titleExtraLarge))
                .foregroundColor(.red)
            Text(title)
                .font(.title2)
                .bold()
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Button("再試行") {
                Task {
                    await viewModel.loadCreatorDetail()
                }
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding(Spacing.screenEdgePadding)
    }
    
    private func contentView(creator: Creator, similarCreators: [Creator]) -> some View {
        ScrollView {
            VStack(spacing: Spacing.unrelatedComponentDivider) {
                // Header section with close button
                headerSection
                
                // Creator profile section
                creatorProfileSection(creator: creator)
                
                // Platform buttons section
                platformButtonsSection(creator: creator)
                
                // Tags section
                tagsSection(creator: creator)
                
                // Tag registration section
                tagRegistrationSection
                
                // Information correction section
                informationCorrectionSection
                
                // Stats section
                statsSection(creator: creator)
                
                // Similar creators section
                similarCreatorsSection(similarCreators: similarCreators)
            }
            .padding(Spacing.screenEdgePadding)
        }
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
                    .foregroundColor(.primary.opacity(Opacity.placeholder))
            })
        }
    }
    
    private func creatorProfileSection(creator: Creator) -> some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            // Creator image
            AsyncImage(url: URL(string: creator.thumbnailUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(Opacity.glow))
                    .overlay(
                        ProgressView()
                    )
            }
            .frame(width: Size.creatorImageSize, height: Size.creatorImageSize)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(Opacity.glow), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: BorderWidth.extraThick + BorderWidth.thin
                    )
            )
            .shadow(color: .black.opacity(Opacity.overlayMedium), radius: Shadow.radiusMedium, x: 0, y: Shadow.offsetYMedium)
            
            // Creator name with favorite button
            HStack(spacing: 12) {
                Text(creator.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: AnimationDuration.heartBeat)) {
                        viewModel.toggleFavorite()
                    }
                }, label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(viewModel.isFavorite ? .red : .primary.opacity(Opacity.overlayHeavy))
                        .scaleEffect(viewModel.isFavorite ? Effects.scaleHeart : Effects.visibleOpacity)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.isFavorite)
                })
            }
            
            // Main platform indicator
            HStack {
                let (platform, _) = creator.mainPlatform()
                if platform == .youtube {
                    Image(systemName: platform.icon)
                        .font(.system(size: Typography.bodyRegular))
                        .foregroundColor(.red)
                } else {
                    Image(platform.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Size.smallIconSize, height: Size.smallIconSize)
                }
                Text(L10n.CreatorDetail.mainPlatform)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func platformButtonsSection(creator: Creator) -> some View {
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
    
    private func tagsSection(creator: Creator) -> some View {
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
                    tagApplicationType = .remove
                    showingTagApplication = true
                }, label: {
                    HStack {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: Typography.bodyRegular))
                        Text(L10n.CreatorDetail.tagDeleteApplication)
                            .font(.system(size: Typography.checkmark, weight: .medium))
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
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
                })
                
                Button(action: {
                    tagApplicationType = .add
                    showingTagApplication = true
                }, label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: Typography.bodyRegular))
                        Text(L10n.CreatorDetail.tagAddApplication)
                            .font(.system(size: Typography.checkmark, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, Spacing.medium)
                    .padding(.vertical, Spacing.relatedComponentDivider)
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
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
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
    
    private func statsSection(creator: Creator) -> some View {
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
    
    private func similarCreatorsSection(similarCreators: [Creator]) -> some View {
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
                    ForEach(similarCreators) { similarCreator in
                        SimilarCreatorCard(creator: similarCreator) {
                            selectedCreatorId = similarCreator.id
                            showingCreatorDetail = true
                        }
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
}

#Preview("正常表示") {
    NavigationStack {
        CreatorDetailView(creatorId: "creator_001")
    }
}

#Preview("ローディング中") {
    struct MockLoadingView: View {
        @StateObject private var viewModel = MockCreatorDetailViewModel()
        
        var body: some View {
            Group {
                switch viewModel.state {
                case .loading:
                    Text("ローディング中...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Asset.Color.Application.Background.background.swiftUIColor)
                default:
                    Text("ローディング状態")
                }
            }
            .onAppear {
                viewModel.state = .loading
            }
        }
    }
    
    return MockLoadingView()
}

#Preview("エラー表示") {
    struct MockErrorView: View {
        @StateObject private var viewModel = MockCreatorDetailViewModel.mockError()
        
        var body: some View {
            Group {
                switch viewModel.state {
                case .error(let title, let message):
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: Typography.titleExtraLarge))
                            .foregroundColor(.red)
                        Text(title)
                            .font(.title2)
                            .bold()
                        Text(message)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button("再試行") {
                            // Dummy action
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Asset.Color.Application.Background.background.swiftUIColor)
                default:
                    Text("エラー状態")
                }
            }
        }
    }
    
    return MockErrorView()
}

#Preview("ナビゲーションテスト") {
    struct NavigationTestView: View {
        @State private var selectedCreator: String?
        @State private var showingDetail = false
        
        var body: some View {
            NavigationStack {
                VStack {
                    Text("ナビゲーションテスト")
                        .font(.title)
                    
                    Button("クリエイター詳細を開く") {
                        selectedCreator = "creator_001"
                        showingDetail = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                .sheet(isPresented: $showingDetail) {
                    if let creatorId = selectedCreator {
                        NavigationStack {
                            CreatorDetailView(creatorId: creatorId)
                        }
                    }
                }
            }
        }
    }
    
    return NavigationTestView()
}
