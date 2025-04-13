//
//  AnalyticsEvents.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/13/25.
//

import Foundation

struct NFArticleSummarizedEvent: Codable {
    let userId: String
    let timestamp: Date

    init(timestamp: Date) {
        self.userId = UserDefaultsManager.shared.getString(forKey: .userID)!
        self.timestamp = timestamp
    }
}

struct NFFlowStartedEvent: Codable {
    let userId: String
    let timestamp: Date

    init(timestamp: Date) {
        self.userId = UserDefaultsManager.shared.getString(forKey: .userID)!
        self.timestamp = timestamp
    }
}
