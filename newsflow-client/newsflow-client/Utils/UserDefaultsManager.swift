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

    enum UserDefaultsKeys: String, CaseIterable {
        case userArticleCategoryPreferences = "user_article_category_preferences"
        case userBookmarkUrls = "user_article_bookmarks_urls"
    }

    private init() {}

    func setStringArray(value: [String], forKey key: UserDefaultsKeys) {
        NFLogger.shared.logger.debug("Setting value for \(key.rawValue) in UserDefaults")
        defualts.set(value, forKey: key.rawValue)
    }

    func getStringArray(forKey key: UserDefaultsKeys) -> [String]? {
        NFLogger.shared.logger.debug("Getting \(key.rawValue) from UserDefaults")
        return defualts.stringArray(forKey: key.rawValue)
    }

    func delete(forKey key: UserDefaultsKeys) {
        NFLogger.shared.logger.debug("Deleting \(key.rawValue) from UserDefaults")
        defualts.removeObject(forKey: key.rawValue)
    }

    func deleteAll() {
        for key in UserDefaultsKeys.allCases {
            self.delete(forKey: key)
        }
    }
}
