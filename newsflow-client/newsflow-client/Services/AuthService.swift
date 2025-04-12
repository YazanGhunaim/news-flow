//
//  AuthService.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/12/25.
//

import Foundation

class AuthService {
    func setUserSession() async throws -> AuthResponse {
        let response: Result<AuthResponse, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .setUserSession), method: .post,
            withRefreshToken: true
        )

        switch response {
        case .success(let authResponse):
            return authResponse
        case .failure(let error):
            throw error
        }
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        let loginRequest: UserLoginRequest = .init(email: email, password: password)

        let response: Result<AuthResponse, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .signIn), method: .post, body: loginRequest
        )

        switch response {
        case .success(let authResponse):
            return authResponse
        case .failure(let error):
            throw error
        }
    }

    func register(name: String, username: String, email: String, password: String) async throws -> AuthResponse {
        let userRegRequest: UserRegisterRequest = .init(
            email: email, password: password, options: .init(data: .init(username: username, name: name))
        )

        let response: Result<AuthResponse, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .signUp), method: .post, body: userRegRequest
        )

        switch response {
        case .success(let authResponse):
            return authResponse
        case .failure(let error):
            throw error
        }
    }

    func deleteUserAccount() async throws {
        let response: Result<EmptyEntity, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .deleteUser), method: .delete
        )

        switch response {
        case .success(_):
            NFLogger.shared.logger.info("User account deleted successfully")
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to delete user account: \(error)")
            throw error
        }
    }

    func logoutUser() async throws {
        let response: Result<EmptyEntity, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .signOut), method: .post
        )

        switch response {
        case .success(_):
            NFLogger.shared.logger.info("User account logged out successfully")
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to log out user account: \(error)")
            throw error
        }
    }
}
