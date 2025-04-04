//
//  AuthViewModel.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import Foundation

@Observable
@MainActor
class AuthViewModel {
    func login(email: String, password: String) async throws {
        let loginRequest: UserLoginRequest = .init(email: email, password: password)

        let response: Result<AuthResponse, APIError> = await APIClient.shared.request(
            url: "http://127.0.0.1:8000/users/sign_in", method: .post, body: loginRequest
        )

        switch response {
        case .success(let authResponse):
            UserDefaults.standard.set(authResponse.session.accessToken, forKey: "accessToken")
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
            UserDefaults.standard.set(authResponse.session.accessToken, forKey: "accessToken")
        case .failure(let error):
            throw error
        }
    }

    // MARK: - helper utils
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
