//
//  CategoryService.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/11/25.
//

import Foundation

class CategoryService {
    func getCategories() async -> [String] {
        let response: Result<[String], APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .getArticleCategories), method: .get
        )

        switch response {
        case .success(let categories):
            return categories
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to fetch article categories: \(error)")
            return []
        }
    }
}
