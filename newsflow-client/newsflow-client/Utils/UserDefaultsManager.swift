//
//  UserDefaultsManager.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/6/25.
//

import Foundation

class UserDefaultsManager {
    let defualts = UserDefaults.standard

    static let shared = UserDefaultsManager()

    enum UserDefaultsKeys: String {
        case userArticleCategoryPreferences = "user_article_category_preferences"
        case userBookmarkUrls = "user_article_bookmarks_urls"
    }

    private init() {}

    func setStringArray(value: [String], forKey key: UserDefaultsKeys) {
        defualts.set(value, forKey: key.rawValue)
    }

    func getStringArray(forKey key: UserDefaultsKeys) -> [String]? {
        return defualts.stringArray(forKey: key.rawValue)
    }
}
