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
                NewsArticlesScrollView
            }
            .toolbar { ToolbarItem(placement: .topBarLeading) { navBarTitle } }
            .onChange(of: homeFiltersVM.selectedFilter) { oldValue, newValue in
                guard newValue.title != "trending" else { return }  // Dont fetch trending categories... already handled seperately

                viewmodel.articles.removeAll()
                Task { await viewmodel.getArticlesforCategory(newValue.title) }
            }
        }
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
