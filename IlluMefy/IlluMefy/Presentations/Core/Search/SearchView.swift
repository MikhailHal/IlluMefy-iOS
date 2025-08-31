//
//  SearchView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import SwiftUI
import UIKit

struct SearchView: View {
    @EnvironmentObject private var router: IlluMefyAppRouter
    @State private var viewModel: SearchViewModel =
    DependencyContainer.shared.resolve(SearchViewModel.self)!
    @State private var isEditing = false
    
    private let initialTag: Tag?
    
    init(initialTag: Tag? = nil) {
        self.initialTag = initialTag
    }
    
    var body: some View {
        ZStack {
            background.ignoresSafeArea()
            
            VStack(spacing: Spacing.relatedComponentDivider) {
                searchBarSection
                
                switch viewModel.state {
                case .initial:
                    initialStateView
                case .editing(let suggestions):
                    editingStateView(suggestions: suggestions)
                case .searching:
                    searchingStateView
                case .showingResults(let creators):
                    resultsStateView(creators: creators)
                case .empty:
                    emptyStateViewContent
                case .error(let title, let message):
                    errorStateView(title: title, message: message)
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            viewModel.initialize(with: initialTag)
        }
    }
    
    // MARK: - View Components
    
    private var background: some View {
        ZStack {
            AnimatedGradientBackground()
            FloatingParticlesView()
        }
    }
    
    private var searchBarSection: some View {
        SearchBar(
            text: $viewModel.searchText,
            isEditing: $isEditing,
            searchBarStyle: SearchBarStyle(),
            onSubmit: {
                // Enterキー押下時は何もしない（タグ選択を強制）
            },
            onChange: { newValue in
                Task {
                    if newValue.isEmpty {
                        if viewModel.selectedTags.isEmpty {
                            // テキストもタグも空なら人気クリエイター取得
                            let popularCreators = await viewModel.getPopularCreatorList()
                            viewModel.state = .showingResults(creators: popularCreators)
                        } else {
                            // タグが選択されている場合はhitListを表示
                            viewModel.state = .showingResults(creators: viewModel.hitList)
                        }
                    } else {
                        await viewModel.getSuggestions(query: newValue)
                    }
                }
            }
        )
        .padding(.horizontal, Spacing.screenEdgePadding)
        .padding(.top, Spacing.screenEdgePadding)
    }
    
    private func suggestionsList(suggestions: [TagSuggestion]) -> some View {
        if suggestions.isEmpty {
            return AnyView(EmptyView())
        }
        return AnyView(List(suggestions) { suggestion in
            SuggestionRow(
                suggestion: suggestion,
                onSelection: { tag in
                    viewModel.onTappedSuggestion(tag: tag)
                }
            )
        }.listStyle(.plain))
    }
    
    private var searchHistorySection: some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            HStack {
                Text(L10n.Search.recentSearches)
                    .font(.caption)
                    .foregroundColor(Asset.Color.SearchResult.searchResultSubtitle.swiftUIColor)
                
                Spacer()
                
                if !viewModel.searchHistory.isEmpty {
                    Button(L10n.Search.clearHistory) {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        Task {
                            await viewModel.clearHistory()
                        }
                    }
                    .font(.caption)
                    .foregroundColor(Asset.Color.Application.accent.swiftUIColor)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.componentGrouping) {
                    ForEach(viewModel.searchHistory, id: \.self) { query in
                        Button(action: {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            //viewModel.addTagsFromHistory(query)
                        }, label: {
                            Text(query)
                                .font(.caption)
                                .padding(.horizontal, Spacing.componentGrouping)
                                .padding(.vertical, Spacing.relatedComponentDivider)
                                .background(Asset.Color.SearchTag.searchTagBackground.swiftUIColor)
                                .foregroundColor(Asset.Color.SearchTag.searchTagText.swiftUIColor)
                                .cornerRadius(CornerRadius.tag)
                        })
                    }
                }
                .padding(.horizontal, Spacing.screenEdgePadding)
            }
        }
    }
    
    private var hitListSection: some View {
        Group {
            // editing状態では表示されないためEmptyViewでOK
            EmptyView()
        }.padding(.top, Spacing.unrelatedComponentDivider)
    }
    
    private var loadingView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0)
            ], spacing: 0) {
                ForEach(0..<20) { _ in
                    SearchResultCreatorCardSkeleton()
                }
            }
            .padding(0)
        }
    }
    
    // MARK: - Helper Views
    
    private func selectedTagsView(
        tags: [Tag],
        onRemove: @escaping (Tag) -> Void
    ) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.componentGrouping) {
                ForEach(tags, id: \.id) { tag in
                    HStack(spacing: Spacing.componentGrouping / 2) {
                        Text(tag.displayName)
                            .font(.system(size: Typography.bodyRegular, weight: .medium))
                            .foregroundColor(Asset.Color.Tag.tagText.swiftUIColor)
                        
                        Button(action: {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            onRemove(tag)
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(Asset.Color.SearchTag.searchTagRemove.swiftUIColor)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                    .background(Asset.Color.SearchTag.searchTagBackgroundSelected.swiftUIColor)
                    .cornerRadius(CornerRadius.tag)
                }
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
        }
        .frame(height: 50)
    }
    
    private func creatorResultsView(creators: [Creator]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // 検索結果の件数表示
            HStack {
                if viewModel.totalCount > creators.count {
                    Text(L10n.Search.resultsCountWithTotal(viewModel.totalCount, creators.count))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Asset.Color.SearchResult.searchResultTitle.swiftUIColor)
                } else {
                    Text(L10n.Search.resultsCount(creators.count))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Asset.Color.SearchResult.searchResultTitle.swiftUIColor)
                }
                
                Spacer()
                
                if viewModel.hasMore {
                    Text(L10n.Search.loadMore)
                        .font(.caption)
                        .foregroundColor(Asset.Color.Application.accent.swiftUIColor)
                }
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
            .padding(.vertical, Spacing.componentGrouping)
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 0),
                    GridItem(.flexible(), spacing: 0),
                    GridItem(.flexible(), spacing: 0)
                ], spacing: 0) {
                    ForEach(creators) { creator in
                        SearchResultCreatorCard(creator: creator, onTap: {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                            impactFeedback.impactOccurred()
                            router.navigate(to: .creatorDetail(creator: creator))
                        })
                    }
                    
                    // Load More Indicator
                    if viewModel.hasMore {
                        VStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text(L10n.Common.loading)
                                .font(.caption)
                                .foregroundColor(Asset.Color.SearchResult.searchResultMetrics.swiftUIColor)
                        }
                        .frame(maxWidth: .infinity)
                        .gridCellColumns(3) // 3列すべてを占有
                        .onAppear {
                            Task {
                                await viewModel.loadMore()
                            }
                        }
                    }
                }
                .padding(0)
            }
            .refreshable {
                await viewModel.search()
            }
        }
    }
    
}

extension SearchView {
    
    // MARK: - State Views
    
    private var initialStateView: some View {
        loadingView
    }
    
    private func editingStateView(suggestions: [TagSuggestion]) -> some View {
        ZStack {
            hitListSection
            Asset.Color.Application.Background.backgroundSecondary.swiftUIColor.opacity(0.7)
                .ignoresSafeArea()
            
            suggestionsList(suggestions: suggestions)
        }
    }
    
    private var searchingStateView: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            if !viewModel.selectedTags.isEmpty {
                selectedTagsView(tags: viewModel.selectedTags, onRemove: { tag in
                    viewModel.onTappedTagForDeletion(tag: tag)
                })
            }
            
            if viewModel.totalCount > 0 {
                HStack {
                    Text(L10n.Search.resultsCount(viewModel.totalCount))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Asset.Color.SearchResult.searchResultTitle.swiftUIColor)
                    Spacer()
                }
                .padding(.horizontal, Spacing.screenEdgePadding)
            }
            
            loadingView
        }
    }
    
    private func resultsStateView(creators: [Creator]) -> some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            if !viewModel.selectedTags.isEmpty {
                selectedTagsView(tags: viewModel.selectedTags, onRemove: { tag in
                    viewModel.onTappedTagForDeletion(tag: tag)
                })
            }
            creatorResultsView(creators: creators)
        }
    }
    
    private var emptyStateViewContent: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            if !viewModel.selectedTags.isEmpty {
                selectedTagsView(tags: viewModel.selectedTags, onRemove: { tag in
                    viewModel.onTappedTagForDeletion(tag: tag)
                })
            }
            
            emptyStateView
        }
    }
    
    private func errorStateView(title: String, message: String) -> some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            if !viewModel.selectedTags.isEmpty {
                selectedTagsView(tags: viewModel.selectedTags, onRemove: { tag in
                    viewModel.onTappedTagForDeletion(tag: tag)
                })
            }
            
            errorView(title: title, message: message)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.unrelatedComponentDivider) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: Typography.titleExtraLarge))
                .foregroundColor(Asset.Color.SearchEmpty.searchEmptyIcon.swiftUIColor)
            Text(L10n.Search.noResults)
                .font(.headline)
                .foregroundColor(Asset.Color.SearchEmpty.searchEmptyTitle.swiftUIColor)
            Text(L10n.Search.noResultsMessage)
                .font(.subheadline)
                .foregroundColor(Asset.Color.SearchEmpty.searchEmptyMessage.swiftUIColor)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(Spacing.screenEdgePadding)
    }
    
    private func errorView(title: String, message: String) -> some View {
        VStack(spacing: Spacing.unrelatedComponentDivider) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: Typography.titleExtraLarge))
                .foregroundColor(Asset.Color.WarningText.warningLabelForground.swiftUIColor)
            Text(title)
                .font(.headline)
                .bold()
            Text(message)
                .font(.subheadline)
                .foregroundColor(Asset.Color.SearchEmpty.searchEmptyMessage.swiftUIColor)
                .multilineTextAlignment(.center)
            Button(L10n.Common.retry) {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                Task {
                    await viewModel.search()
                }
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding(Spacing.screenEdgePadding)
    }
    
    // MARK: - Helper Methods
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SearchView()
}
