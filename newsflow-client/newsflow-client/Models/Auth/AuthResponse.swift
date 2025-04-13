//
//  AuthResponse.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/4/25.
//

import Foundation

struct UserSessionData: Codable {
    let id: String
}

struct UserTokens: Codable {
    let accessToken: String
    let refreshToken: String
    let user: UserSessionData

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case user
    }
}

struct AuthResponse: Codable {
    let session: UserTokens
}
