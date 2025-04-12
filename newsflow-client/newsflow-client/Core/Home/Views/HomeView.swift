//
//  HomeView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/4/25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewmodel: HomeViewModel
    @State private var homeFiltersVM: HomeFiltersViewModel

    @Environment(Router.self) private var router
    @Namespace private var animation

    init(homeFiltersVM: HomeFiltersViewModel) {
        let filters = homeFiltersVM.filters.map { $0.title }
        _homeFiltersVM = State(initialValue: homeFiltersVM)
        _viewmodel = State(initialValue: HomeViewModel(articleService: ArticleService(), categories: filters))
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // MARK: Category selection
                categoryFilterScrollView

                Spacer()

                // MARK: News Articles
                if viewmodel.isLoading {
                    loadingView
                } else {
                    NewsArticlesScrollView
                }

            }
            .toolbar { ToolbarItem(placement: .topBarLeading) { navBarTitle } }
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

    var NewsArticlesScrollView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewmodel.articles[homeFiltersVM.selectedFilter.title] ?? []) { article in
                    VStack {
                        ArticleCell(article: article)
                            .onTapGesture { router.navigate(to: .articleView(article: article)) }

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
    HomeView(homeFiltersVM: HomeFiltersViewModel())
}
