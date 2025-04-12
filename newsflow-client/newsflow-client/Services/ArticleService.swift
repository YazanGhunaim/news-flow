//
//  ArticleService.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/12/25.
//

import Foundation

class ArticleService {
	func getTopHeadlines(forCategory category: String = "general", pageSize: Int = 5) async throws -> [Article] {
        let params = ["category": category, "page_size": String(pageSize)]
        let url = EndpointManager.shared.url(for: .topHeadlines, parameters: params)
        let response: Result<NewsResponse, APIError> = await APIClient.shared.request(url: url, method: .get)

        switch response {
        case .success(let newsResponse):
            NFLogger.shared.logger.debug("Sucessfully fetched top articles for category: \(category).")
            return newsResponse.articles
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to fetch to articles for today with error: \(error)")
            throw error
        }
    }

    func bookmarkArticle(_ article: Article) async throws {
        let response: Result<EmptyEntity, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .bookmarkArticle), method: .post, body: article,
        )

        switch response {
        case .success(_):
            NFLogger.shared.logger.info("Bookmarked article \(article.url)")
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to bookmark article \(article.url): \(error)")
            throw error
        }
    }

    func unbookmarkArticle(_ article: Article) async throws {
        let params = ["article_url": article.url]
        let response: Result<EmptyEntity, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .bookmarkArticle, parameters: params), method: .delete
        )

        switch response {
        case .success(_):
            NFLogger.shared.logger.info("Successfully unbookmarked article \(article.url)")
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to unbookmark article \(article.url): \(error)")
        }
    }

    func summarizeArticle(_ article: Article) async throws -> String {
        let response: Result<ArticleSummary, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .summarizeArticle), method: .post, body: article,
        )

        switch response {
        case .success(let article):
            NFLogger.shared.logger.info("Retrieved summary for \(article.url)")
            return article.summary
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to retrieve summary for \(article.url): \(error)")
            throw error
        }
    }
}
