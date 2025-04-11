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
    let apiCategories: Set<String> = [
        "business", "entertainment", "general", "health", "science", "sports", "technology",
    ]

    var articles = [String: [Article]]()
    var isLoading = false

    init(categories: [String]) { Task { await getArticles(forCategories: categories) } }

    func getArticles(forCategories categories: [String]) async {
        isLoading = true

        defer { isLoading = false }

        for category in categories {
            if apiCategories.contains(category) {
                articles[category] = try? await getTrendingArticles(forCategory: category) ?? []
            } else {
                articles[category] = try? await getArticleForKeyword(category) ?? []
            }
        }
    }

    private func getTrendingArticles(forCategory category: String) async throws -> [Article]? {
        let params = ["category": category, "page_size": "20"]
        let url = EndpointManager.shared.url(for: .topHeadlines, parameters: params)
        let response: Result<NewsResponse, APIError> = await APIClient.shared.request(url: url, method: .get)

        switch response {
        case .success(let newsResponse):
            NFLogger.shared.logger.debug("Sucessfully fetched trending articles for category: \(category)")
            return newsResponse.articles
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to fetch article categories: \(error)")
            throw error
        }
    }

    private func getArticleForKeyword(_ keyword: String) async throws -> [Article]? {
        let params = ["page_size": "20", "keyword": keyword]
        let url = EndpointManager.shared.url(for: .everyArticle, parameters: params)
        let response: Result<NewsResponse, APIError> = await APIClient.shared.request(
            url: url, method: .get
        )

        switch response {
        case .success(let newsResponse):
            NFLogger.shared.logger.debug("Successfully fetched articles for keyword: \(keyword)")
            return newsResponse.articles
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to fetch article categories: \(error)")
            throw error
        }
    }
}
