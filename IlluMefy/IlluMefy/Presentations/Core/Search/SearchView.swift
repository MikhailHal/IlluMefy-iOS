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
    
    var body: some View {
        ZStack {
            Asset.Color.Application.Background.backgroundPrimary.swiftUIColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                searchBarSection
                
                switch viewModel.state {
                case .initial:
                    loadingView
                case .editing(let suggestions):
                    ZStack {
                        hitListSection
                        Asset.Color.Application.Background.backgroundSecondary.swiftUIColor.opacity(0.7)
                            .ignoresSafeArea()
                            .transition(.opacity)
                        
                        suggestionsList(suggestions: suggestions)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                case .searching:
                    loadingView
                case .showingResults(let creators):
                    creatorResultsView(creators: creators)
                case .empty:
                    emptyStateView
                case .error(let title, let message):
                    errorView(title: title, message: message)
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.state)
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            Task {
                await viewModel.getPopularCreatorList()
            }
        }
    }
    
    // MARK: - View Components
    
    private var searchBarSection: some View {
        SearchBar(
            text: $viewModel.searchText,
            isEditing: $isEditing,
            searchBarStyle: SearchBarStyle(),
            onChange: { newValue in
                Task {
                    await viewModel.getSuggestions(query: newValue)
                }
            }
        )
        .padding(.horizontal, Spacing.screenEdgePadding)
        .padding(.top, Spacing.screenEdgePadding)
        .onChange(of: isEditing) { _, newValue in
            if !newValue && viewModel.searchText.isEmpty {
                // 編集終了かつテキストが空の場合はhitListを表示
                Task {
                    await viewModel.getSuggestions(query: "")
                }
            }
        }
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
                            .font(.caption)
                            .foregroundColor(Asset.Color.SearchTag.searchTagText.swiftUIColor)
                        
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
                    .padding(.horizontal, Spacing.componentGrouping)
                    .padding(.vertical, Spacing.relatedComponentDivider)
                    .background(Asset.Color.SearchTag.searchTagBackgroundSelected.swiftUIColor)
                    .cornerRadius(CornerRadius.tag)
                }
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
        }
        .frame(maxHeight: 40)
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
