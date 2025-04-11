//
//  UserService.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/11/25.
//

import Foundation

class UserService {
    func setCategoryPreferences(categories: [String]) async throws {
        let response: Result<EmptyEntity, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.getEndpointURL(for: .userPreferences), method: .post, body: categories
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
            url: EndpointManager.shared.getEndpointURL(for: .userPreferences), method: .put, body: categories
        )

        switch response {
        case .success:
            NFLogger.shared.logger.info("Successfully updated category preferences.")
            // update preferences locally
            UserDefaultsManager.shared.updateStringArray(value: categories, forKey: .userArticleCategoryPreferences)
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to set category preferences: \(error)")
            throw error
        }
    }
}
