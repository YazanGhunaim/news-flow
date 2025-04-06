//
//  EndpointManager.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/6/25.
//

import Foundation

class EndpointManager {
    let baseURL = "127.0.0.1:8000"

    static let shared = EndpointManager()

    private init() {}

    enum Endpoint: String {
        case topHeadlines = "/articles/top-headlines"
        case everyArticle = "/articles/everything"
        case bookmarkArticle = "/articles/bookmark"
        case summarizeArticle = "/articles/summary"

        case signUp = "/users/sign_up"
        case signIn = "/users/sign_in"
        case signOut = "/users/sign_out"
        case updateUser = "/users/update"
        case deleteUser = "/users/delete"
        case setUserSession = "/users/set_session"

        case userPreferences = "/users/preferences"
        case userBookmarks = "/users/bookmarks"

        case getArticleCategories = "/preferences/categories"
    }

    func getEndpointURL(for endpoint: Endpoint) -> String {
        "http://\(baseURL)\(endpoint.rawValue)"
    }

}
