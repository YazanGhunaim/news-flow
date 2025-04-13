//
//  AnalyticsManager.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/13/25.
//

import FirebaseAnalytics
import Foundation

enum AnalyticsEvent {
    case articleSummarized(NFArticleSummarizedEvent)
    case flowStarted(NFFlowStartedEvent)

    var eventName: String {
        switch self {
        case .articleSummarized:
            return "article_summarized"
        case .flowStarted:
            return "flow_started"
        }
    }
}

final class AnalyticsManager {
    static let shared = AnalyticsManager()

    private init() {}

    private func eventToDictionary(_ event: Codable) -> [String: Any] {
        var parameters: [String: Any] = [:]

        do {
            let data = try JSONEncoder().encode(event)
            let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
            parameters = dict
            return parameters
        } catch {
            return parameters
        }
    }

    func logEvent(_ eventName: AnalyticsEvent) {
        var parameters: [String: Any] = [:]

        switch eventName {
        case .articleSummarized(let event):
            parameters = eventToDictionary(event)

        case .flowStarted(let event):
            parameters = eventToDictionary(event)
        }

        Analytics.logEvent(eventName.eventName, parameters: parameters)
    }
}
