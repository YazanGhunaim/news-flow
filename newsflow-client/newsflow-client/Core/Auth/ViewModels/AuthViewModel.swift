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
final class AuthViewModel {
    let authService: AuthService
    let userService: UserService

    var userState: UserState?

    init(authService: AuthService, userService: UserService) {
        self.authService = authService
        self.userService = userService

        Task { await setUserState() }
    }

    private func syncUserPreferences() async {
        let preferences: [String] = (try? await userService.getUserCategoryPreferences()) ?? []
        UserDefaultsManager.shared.setStringArray(value: preferences, forKey: .userArticleCategoryPreferences)
    }

    // MARK: - Auth requests
    private func setUserState() async {
        NFLogger.shared.logger.debug("Setting user state")

        // check if auth tokens exist
        if KeychainManager.shared.authTokensExist() {
            NFLogger.shared.logger.debug("User tokens exist")

            if await refreshUserState() {
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

    // MARK: User Auth
    func refreshUserState() async -> Bool {
        guard let authResponse = try? await authService.setUserSession() else {
            return false
        }

        saveAuthTokens(authResponse: authResponse)
        return true
    }

    func login(email: String, password: String) async throws {
        let authResponse = try await authService.login(email: email, password: password)

        saveAuthTokens(authResponse: authResponse)
        // load user preferences locally
        await syncUserPreferences()
    }

    func register(name: String, username: String, email: String, password: String) async throws {
        let authResponse = try await authService.register(
            name: name, username: username, email: email, password: password
        )

        saveAuthTokens(authResponse: authResponse)
    }

    func logoutUser() async throws {
        try await authService.logoutUser()
        userState = .loggedOut
    }

    func deleteUserAccount() async throws {
        try await authService.deleteUserAccount()
        userState = .loggedOut
    }

    // MARK: - helper utils
    private func saveAuthTokens(authResponse: AuthResponse) {
        let _ = KeychainManager.shared.saveToken(authResponse.session.accessToken, forKey: .userAccessToken)
        let _ = KeychainManager.shared.saveToken(authResponse.session.refreshToken, forKey: .userRefreshToken)
        let _ = UserDefaultsManager.shared.setString(value: authResponse.session.user.id, forKey: .userID)
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
