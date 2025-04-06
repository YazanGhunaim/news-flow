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

struct Source: Codable {
    let id: String?
    let name: String
}

struct Article: Codable, Identifiable {
    var id = UUID()

    let source: Source
    let author: String?
    let title: String
    let description: String
    let url: String
    let imageUrl: String?
    let content: String

    // Store date as a string initially
    let dateString: String

    var date: Date {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString)!
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
    }
}
