//
//  Article.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/5/25.
//

import Foundation

struct NewsResponse: Codable {
    let totalResults: Int
    let articles: [Article]

    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case articles
    }
}

struct Source: Codable, Hashable {
    let name: String
}

struct Article: Codable, Identifiable, Hashable {
    var id = UUID()

    let source: Source
    let author: String?
    let title: String
    let description: String
    let url: String
    let imageUrl: String?
    let content: String
    let summary: String?

    let dateString: String
    var date: Date? {
        dateString.toDate()
    }

    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case source
        case author
        case title
        case description
        case url
        case dateString = "date"
        case content
        case summary
    }

    init(
        id: UUID = UUID(), source: Source, author: String? = nil, title: String, description: String, url: String,
        imageUrl: String? = nil, content: String, summary: String? = nil, dateString: String
    ) {
        self.id = id
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.imageUrl = imageUrl
        self.content = content
        self.summary = summary
        self.dateString = dateString
    }

    init(fromArticle article: Article, withSummary summary: String) {
        self.id = article.id
        self.source = article.source
        self.author = article.author
        self.title = article.title
        self.description = article.description
        self.url = article.url
        self.imageUrl = article.imageUrl
        self.content = article.content
        self.dateString = article.dateString
        self.summary = summary
    }
}

struct ArticleSummary: Codable, Identifiable {
    var id = UUID()

    let url: String
    let summary: String

    enum CodingKeys: String, CodingKey {
        case url = "article_url"
        case summary
    }
}
