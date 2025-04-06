//
//  HomeView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/4/25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewmodel = HomeViewModel()
    @State private var homeFiltersVM = HomeFiltersViewModel()
    @Namespace private var animation

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // MARK: Category selection
                categoryFilterScrollView

                Spacer()

                // MARK: News Articles
                if viewmodel.isLoading {
                    loadingView
                } else if let error = viewmodel.error {
                    errorView(error)
                } else if viewmodel.isEmpty {
                    emptyStateView
                } else {
                    NewsArticlesScrollView
                }
            }
            .toolbar { ToolbarItem(placement: .topBarLeading) { navBarTitle } }
            .onChange(of: homeFiltersVM.selectedFilter) { oldValue, newValue in
                handleFilterChange(from: oldValue, to: newValue)
            }
        }
    }

    // MARK: - Private Methods
    private func handleFilterChange(from oldValue: HomeFilter, to newValue: HomeFilter) {
        guard newValue.title != "trending" else { return }

        viewmodel.articles.removeAll()
        Task { await viewmodel.getArticlesforCategory(newValue.title) }
    }
}

extension HomeView {
    var navBarTitle: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Discover")
                .font(.system(size: 40, weight: .bold, design: .default))
            Text("News tailored for you")
                .font(.system(size: 20, weight: .light, design: .default))
                .foregroundStyle(.gray)
        }
        .safeAreaPadding(.top, 80)
    }

    var categoryFilterScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(homeFiltersVM.filters) { filter in
                    VStack {
                        Text(filter.title)
                            .font(.subheadline)
                            .foregroundColor(homeFiltersVM.selectedFilter.title == filter.title ? .NFPrimary : .gray)

                        if homeFiltersVM.selectedFilter.title == filter.title {
                            Capsule()
                                .foregroundStyle(Color.NFPrimary)
                                .frame(height: 3)
                                .matchedGeometryEffect(id: "filter", in: animation)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            homeFiltersVM.selectedFilter = filter
                        }
                    }
                    .containerRelativeFrame(.horizontal, count: 3, spacing: 2)
                }
            }
            .scrollTargetLayout()
            .padding(.top, 80)
        }
        .scrollTargetBehavior(.viewAligned)
        .overlay(Divider().offset(x: 0, y: 55))
    }

    var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading articles...")
                .foregroundColor(.gray)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func errorView(_ error: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)

            Text("Oops! Something went wrong")
                .font(.headline)

            Text(error)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                Task {
                    if homeFiltersVM.selectedFilter.title == "trending" {
                        await viewmodel.setTrendingArticles()
                    } else {
                        await viewmodel.getArticlesforCategory(homeFiltersVM.selectedFilter.title)
                    }
                }
            }) {
                Text("Try Again")
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.NFPrimary)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "newspaper")
                .font(.system(size: 50))
                .foregroundColor(.gray)

            Text("No Articles Found")
                .font(.headline)

            Text("We couldn't find any articles for this category. Try selecting a different category.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var NewsArticlesScrollView: some View {
        Group {
            switch homeFiltersVM.selectedFilter.title {
            case "trending":
                TrendingArticles
            default:
                KeywordArticles
            }
        }
    }

    var TrendingArticles: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewmodel.trendingArticles) { article in
                    VStack {
                        ArticleCell(article: article)
                            .onTapGesture {
                                // TODO: Navigate to article detail
                            }

                        Divider()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }
        }
    }

    var KeywordArticles: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewmodel.articles) { article in
                    VStack {
                        ArticleCell(article: article)
                            .onTapGesture {
                                // TODO: Navigate to article detail
                            }

                        Divider()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
