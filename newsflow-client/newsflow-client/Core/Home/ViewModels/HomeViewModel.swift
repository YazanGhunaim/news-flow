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
    var articles = [Article]()
    var isLoading = false
    var error: String?
    var isEmpty = false

    private var cachedArticles = [String: [Article]]()  // in mem cache

    init() {
        Task { await setTrendingArticles() }
    }

    func getArticlesforCategory(_ category: String) async {
        isLoading = true
        error = nil
        isEmpty = false

        // check cache
        if let cached = cachedArticles[category] {
            self.articles = cached
            self.isEmpty = cached.isEmpty
            isLoading = false
            return
        }

        do {
            self.articles = try await getArticleForKeyword(category)
            self.isEmpty = articles.isEmpty
            cachedArticles[category] = self.articles
        } catch {
            self.error = error.localizedDescription
            self.articles = []
        }

        isLoading = false
    }

    func setTrendingArticles() async {
        isLoading = true
        error = nil
        isEmpty = false

        let params = ["page_size": "20"]
        let url = APIClient.shared.buildURL(
            base: EndpointManager.shared.getEndpointURL(for: .topHeadlines), queryParams: params)

        let response: Result<NewsResponse, APIError> = await APIClient.shared.request(
            url: url!, method: .get
        )

        switch response {
        case .success(let newsResponse):
            self.trendingArticles = newsResponse.articles
            self.isEmpty = newsResponse.articles.isEmpty
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to fetch article categories: \(error)")
            self.error = error.localizedDescription
            self.trendingArticles = []
        }

        isLoading = false
    }

    private func getArticleForKeyword(_ keyword: String) async throws -> [Article] {
        let params = ["page_size": "20", "keyword": keyword]
        let url = APIClient.shared.buildURL(
            base: EndpointManager.shared.getEndpointURL(for: .everyArticle), queryParams: params)

        NFLogger.shared.logger.debug("Fetching articles for keyword: \(keyword)")
        let response: Result<NewsResponse, APIError> = await APIClient.shared.request(
            url: url!, method: .get
        )

        switch response {
        case .success(let newsResponse):
            return newsResponse.articles
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to fetch article categories: \(error)")
            throw error
        }
    }
}
