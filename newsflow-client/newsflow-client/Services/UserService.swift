//
//  UserService.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/11/25.
//

import Foundation

class UserService {
    func getUser() async -> User? {
        let response: Result<User, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .getUser), method: .get
        )

        switch response {
        case .success(let user):
            NFLogger.shared.logger.info("Successfully retrieved user data")
            return user
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to retrieve user data with error: \(error)")
            return nil
        }
    }

    func setCategoryPreferences(categories: [String]) async throws {
        let response: Result<EmptyEntity, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .userPreferences), method: .post, body: categories
        )

        switch response {
        case .success:
            NFLogger.shared.logger.info("Successfully set category preferences.")
            // save preferences locally
            UserDefaultsManager.shared.setStringArray(value: categories, forKey: .userArticleCategoryPreferences)
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to set category preferences: \(error)")
            throw error
        }
    }

    func updateCategoryPreferences(categories: [String]) async throws {
        let response: Result<EmptyEntity, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .userPreferences), method: .put, body: categories
        )

        switch response {
        case .success:
            NFLogger.shared.logger.info("Successfully updated category preferences.")
            // update preferences locally
            UserDefaultsManager.shared.setStringArray(value: categories, forKey: .userArticleCategoryPreferences)
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to set category preferences: \(error)")
            throw error
        }
    }

    func getUserBookmarks() async -> [Article]? {
        let response: Result<[Article], APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .userBookmarks), method: .get
        )

        switch response {
        case .success(let articles):
            NFLogger.shared.logger.info("Successfully retrieved user bookmarks")
            return articles
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to retrieve user bookmarks with error: \(error)")
            return nil
        }
    }
}
