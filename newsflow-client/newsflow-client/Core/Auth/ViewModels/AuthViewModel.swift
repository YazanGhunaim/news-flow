//
//  AuthViewModel.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import Foundation

enum UserState {
    case loggedOut
    case loggedIn
}

@Observable
@MainActor
class AuthViewModel {
    var userState: UserState?

    init() { Task { await setUserState() } }

    // MARK: - Auth requests
    private func setUserState() async {
        NFLogger.shared.logger.debug("Setting user state")
        // check if auth tokens exist
        if KeychainManager.shared.authTokensExist() {
            NFLogger.shared.logger.debug("User tokens exist")
            if (try? await refreshUserState()) != nil {
                NFLogger.shared.logger.debug("Setting user state to logged in")
                userState = .loggedIn
            } else {
                NFLogger.shared.logger.debug("Setting user state to logged out")
                userState = .loggedOut
            }
        } else {
            NFLogger.shared.logger.debug("Setting user state to logged out")
            userState = .loggedOut
        }
    }

    private func refreshUserState() async throws {
        let response: Result<AuthResponse, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.getEndpointURL(for: .setUserSession), method: .post,
            withRefreshToken: true
        )

        switch response {
        case .success(let authResponse):
            saveAuthTokens(authResponse: authResponse)
        case .failure(let error):
            throw error
        }
    }

    func login(email: String, password: String) async throws {
        let loginRequest: UserLoginRequest = .init(email: email, password: password)

        let response: Result<AuthResponse, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.getEndpointURL(for: .signIn), method: .post, body: loginRequest
        )

        switch response {
        case .success(let authResponse):
            saveAuthTokens(authResponse: authResponse)
        case .failure(let error):
            throw error
        }
    }

    func register(name: String, username: String, email: String, password: String) async throws {
        let userRegRequest: UserRegisterRequest = .init(
            email: email, password: password, options: .init(data: .init(username: username, name: name))
        )

        let response: Result<AuthResponse, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.getEndpointURL(for: .signUp), method: .post, body: userRegRequest
        )

        switch response {
        case .success(let authResponse):
            saveAuthTokens(authResponse: authResponse)
        case .failure(let error):
            throw error
        }
    }

    // MARK: - helper utils
    private func saveAuthTokens(authResponse: AuthResponse) {
        let _ = KeychainManager.shared.saveToken(authResponse.session.accessToken, forKey: .userAccessToken)
        let _ = KeychainManager.shared.saveToken(authResponse.session.refreshToken, forKey: .userRefreshToken)
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
