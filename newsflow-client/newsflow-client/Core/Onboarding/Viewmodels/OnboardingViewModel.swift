//
//  OnboardingViewModel.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import Foundation

@Observable
@MainActor
class OnboardingViewModel {
    var categories = [String]()

    init() {
        Task { self.categories = await self.getCategories() }
    }

    func getCategories() async -> [String] {
        let response: Result<[String], APIError> = await APIClient.shared.request(
            url: "http://127.0.0.1:8000/preferences/categories", method: .get
        )

        switch response {
        case .success(let categories):
            return categories
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to fetch article categories: \(error)")
            return []
        }
    }

    func setCategoryPreferences(categories: [String]) async throws {
        let response: Result<EmptyEntity, APIError> = await APIClient.shared.request(
            url: "http://127.0.0.1:8000/users/preferences", method: .post, body: categories
        )

        switch response {
        case .success:
            NFLogger.shared.logger.info("Successfully set category preferences.")
            // save preferences locally
            UserDefaults.standard.set(categories, forKey: "user_article_category_preferences")
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to set category preferences: \(error)")
            throw error
        }
    }
}
