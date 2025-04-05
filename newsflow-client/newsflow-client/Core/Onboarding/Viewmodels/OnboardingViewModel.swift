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
    func setCategoryPreferences(categories: [String]) async throws {
        let response: Result<EmptyEntity, APIError> = await APIClient.shared.request(
            url: "http://127.0.0.1:8000/users/preferences", method: .post, body: categories
        )

        switch response {
        case .success:
            NFLogger.shared.logger.info("Successfully set category preferences.")
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to set category preferences: \(error)")
            throw error
        }
    }
}
