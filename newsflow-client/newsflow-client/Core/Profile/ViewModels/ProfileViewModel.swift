//
//  ProfileViewModel.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/11/25.
//

import Foundation

@Observable
@MainActor
class ProfileViewModel {
    var user: User?

    init() { Task { self.user = await getUser() } }

    func getUser() async -> User? {
        let response: Result<User, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.getEndpointURL(for: .getUser), method: .get
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
}
