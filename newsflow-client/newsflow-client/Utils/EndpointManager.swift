//
//  EndpointManager.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/6/25.
//

import Alamofire
import Foundation

class EndpointManager {
    static let shared = EndpointManager()
    private init() {}

    private let scheme = "https"
    private let host = "news-flow-backend-a9v9.onrender.com"
    //    private let port = 8000

    func url(for endpoint: Endpoint, parameters: [String: String]? = nil) -> String {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        //        components.port = port
        components.path = endpoint.rawValue

        if let params = parameters { components.queryItems = params.map { URLQueryItem(name: $0, value: $1) } }
        return components.string ?? ""
    }

    enum Endpoint: String {
        case topHeadlines = "/articles/top-headlines"
        case everyArticle = "/articles/everything"
        case bookmarkArticle = "/articles/bookmark"
        case summarizeArticle = "/articles/summary"

        case signUp = "/users/sign_up"
        case signIn = "/users/sign_in"
        case signOut = "/users/sign_out"
        case getUser = "/users/current"
        case updateUser = "/users/update"
        case deleteUser = "/users/delete"
        case setUserSession = "/users/set_session"

        case userPreferences = "/users/preferences"
        case userBookmarks = "/users/bookmarks"

        case getArticleCategories = "/preferences/categories"
    }
}
