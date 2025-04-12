//
//  HomeViewModel.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/6/25.
//

import Foundation

@Observable
@MainActor
class HomeViewModel {
    let articleService: ArticleService
    let apiCategories: Set<String> = [
        "business", "entertainment", "general", "health", "science", "sports", "technology",
    ]

    var articles = [String: [Article]]()
    var isLoading = false

    init(articleService: ArticleService, categories: [String]) {
        self.articleService = articleService
        Task { await getArticles(forCategories: categories) }
    }

    func getArticles(forCategories categories: [String]) async {
        isLoading = true

        defer { isLoading = false }

        for category in categories {
            if apiCategories.contains(category) {
                articles[category] =
                    (try? await articleService.getTopHeadlines(forCategory: category, pageSize: 20)) ?? []
            } else {
                articles[category] =
                    (try? await articleService.getArticles(forKeyword: category, pageSize: 20)) ?? []
            }
        }
    }
}
