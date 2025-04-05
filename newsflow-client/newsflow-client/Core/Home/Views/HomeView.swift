//
//  HomeView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/4/25.
//

import SwiftUI

struct HomeView: View {
    // TODO: get from api
    let articles: [Article] = [
        Article(
            imageURL: "https://cdn.mlbtraderumors.com/files/2025/03/USATSI_22887705-1024x683.jpg",
            title: "Breaking News: SwiftUI Makes Beautiful UIs Easy"
        ),
        Article(
            imageURL: "https://variety.com/wp-content/uploads/2025/03/GettyImages-2204767080.jpg?w=1000",
            title: "Breaking News: SwiftUI Makes Beautiful UIs Easy"
        ),
        Article(
            imageURL: "https://cdn.mlbtraderumors.com/files/2025/03/USATSI_22887705-1024x683.jpg",
            title: "Breaking News: SwiftUI Makes Beautiful UIs Easy"
        ),
        Article(
            imageURL: "https://variety.com/wp-content/uploads/2025/03/GettyImages-2204767080.jpg?w=1000",
            title: "Breaking News: SwiftUI Makes Beautiful UIs Easy"
        ),
        Article(
            imageURL: "https://variety.com/wp-content/uploads/2025/03/GettyImages-2204767080.jpg?w=1000",
            title: "Breaking News: SwiftUI Makes Beautiful UIs Easy"
        ),
        Article(
            imageURL: "https://variety.com/wp-content/uploads/2025/03/GettyImages-2204767080.jpg?w=1000",
            title: "Breaking News: SwiftUI Makes Beautiful UIs Easy"
        ),
        Article(
            imageURL: "https://variety.com/wp-content/uploads/2025/03/GettyImages-2204767080.jpg?w=1000",
            title: "Breaking News: SwiftUI Makes Beautiful UIs Easy"
        ),
    ]
    @State private var selectedFilter: HomeFiltersViewModel = .trending

    @Namespace private var animation

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // MARK: Category selection
                categoryFilterScrollView

                Spacer()

                // MARK: News Articles
                // TODO: Display based on selected filter
                NewsArticlesScrollView
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
                ForEach(HomeFiltersViewModel.allCases, id: \.rawValue) { item in
                    VStack {
                        Text(item.title)
                            .font(.subheadline)

                        if selectedFilter == item {
                            Capsule()
                                .foregroundStyle(Color.NFPrimary)
                                .frame(height: 3)
                                .matchedGeometryEffect(id: "filter", in: animation)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selectedFilter = item
                        }
                    }
                    .containerRelativeFrame(.horizontal, count: 4, spacing: 4)
                }
            }

            .scrollTargetLayout()
            .padding(.top, 80)
        }
        .scrollTargetBehavior(.viewAligned)
        .overlay(Divider().offset(x: 0, y: 55))
    }

    var NewsArticlesScrollView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(articles) { article in
                    VStack {
                        ArticleCell(article: article)

                        Divider()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
