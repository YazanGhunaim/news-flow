//
//  KeychainManager.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/5/25.
//

import Foundation
import SimpleKeychain

class KeychainManager {
    // singleton
    static let shared = KeychainManager()
    private let keychainService = SimpleKeychain()

    enum KeychainKey: String {
        case userAccessToken = "user-access-token"
        case userRefreshToken = "user-refresh-token"
    }

    private init() {}

    // save and update token
    func saveToken(_ token: String, forKey key: KeychainKey) -> Bool {
        if (try? keychainService.set(token, forKey: key.rawValue)) != nil {
            NFLogger.shared.logger.info("Saved token to keychain successfully!")
            return true
        }
        NFLogger.shared.logger.error("Error saving token to keychain!")
        return false
    }

    // load token
    func getToken(forKey key: KeychainKey) -> String? {
        if let token = try? keychainService.string(forKey: key.rawValue) {
            return token
        }
        return nil
    }

    // delete token
    func deleteToken(forKey key: KeychainKey) -> Bool {
        if (try? keychainService.deleteItem(forKey: key.rawValue)) != nil {
            NFLogger.shared.logger.info("Successfully deleted token from keychain!")
            return true
        }
        NFLogger.shared.logger.error("Error deleting token from keychain!")
        return false
    }

    // delete all
    func deleteAllTokens() -> Bool {
        if (try? keychainService.deleteAll()) != nil {
            NFLogger.shared.logger.info("Successfully deleted all tokens from keychain!")
            return true
        }
        NFLogger.shared.logger.error("Error deleting all tokens from keychain!")
        return false
    }

    // MARK: - helper methods
    func getAllTokens() -> [String]? {
        try? keychainService.keys()
    }

    func authTokensExist() -> Bool {
        do {
            let hasAccessToken = try keychainService.hasItem(forKey: KeychainKey.userAccessToken.rawValue)
            let hasRefreshToken = try keychainService.hasItem(forKey: KeychainKey.userRefreshToken.rawValue)
            return hasAccessToken && hasRefreshToken
        } catch {
            return false
        }
    }
}
