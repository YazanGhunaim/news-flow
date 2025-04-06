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

    init() {
        Task { self.trendingArticles = await getTrendingArticles() }
    }

    func getArticlesforCategory(_ category: String) async {
        self.articles = await getArticleForKeyword(category)
    }

    private func getTrendingArticles() async -> [Article] {
        let params = ["page_size": "20"]
        let url = APIClient.shared.buildURL(base: "http://127.0.0.1:8000/articles/top-headlines", queryParams: params)

        let response: Result<NewsResponse, APIError> = await APIClient.shared.request(
            url: url!, method: .get
        )

        switch response {
        case .success(let newsResponse):
            return newsResponse.articles
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to fetch article categories: \(error)")
            return []
        }
    }

    private func getArticleForKeyword(_ keyword: String) async -> [Article] {
        let params = ["page_size": "20", "keyword": keyword]
        let url = APIClient.shared.buildURL(base: "http://127.0.0.1:8000/articles/everything", queryParams: params)

        NFLogger.shared.logger.debug("Fetching articles for keyword: \(keyword)")
        let response: Result<NewsResponse, APIError> = await APIClient.shared.request(
            url: url!, method: .get
        )

        switch response {
        case .success(let newsResponse):
            return newsResponse.articles
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to fetch article categories: \(error)")
            return []
        }
    }
}
