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
        // check if auth tokens exist
        if KeychainManager.shared.authTokensExist() {
            if (try? await refreshUserState()) != nil {
                userState = .loggedIn
            } else {
                userState = .loggedOut
            }
        } else {
            userState = .loggedOut
        }
    }

    private func refreshUserState() async throws {
        let response: Result<AuthResponse, APIError> = await APIClient.shared.request(
            url: "http://127.0.0.1:8000/users/set_session", method: .post,
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
            url: "http://127.0.0.1:8000/users/sign_in", method: .post, body: loginRequest
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
            url: "http://127.0.0.1:8000/users/sign_up", method: .post, body: userRegRequest
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
