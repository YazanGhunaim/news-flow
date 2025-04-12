//
//  ArticleService.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/12/25.
//

import Foundation

class ArticleService {
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
