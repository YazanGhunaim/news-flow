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
    var trendingArticles = [Article]()
    var articles = [String: [Article]]()

    var isLoading = false

    init(categories: [String]) { Task { await getArticles(forCategories: categories) } }

    func getArticles(forCategories categories: [String]) async {
        isLoading = true

        defer { isLoading = false }

        for category in categories {
            guard category != "trending" else {
                await getTrendingArticles()
                continue
            }

            //            articles[category] = try? await getArticleForKeyword(category) ?? []
        }
    }

    private func getTrendingArticles() async {
        let params = ["page_size": "20"]
        let url = EndpointManager.shared.url(for: .topHeadlines, parameters: params)
        let response: Result<NewsResponse, APIError> = await APIClient.shared.request(url: url, method: .get)

        switch response {
        case .success(let newsResponse):
            NFLogger.shared.logger.debug("Sucessfully fetched trending articles")
            self.trendingArticles = newsResponse.articles
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to fetch article categories: \(error)")
            self.trendingArticles = []
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
            NFLogger.shared.logger.debug("Failed to fetch articles for keyword: \(keyword)")
            return newsResponse.articles
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to fetch article categories: \(error)")
            throw error
        }
    }
}
