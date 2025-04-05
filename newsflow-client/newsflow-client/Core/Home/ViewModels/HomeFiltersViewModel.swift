//
//  HomeFiltersViewModel.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/6/25.
//

import Foundation

// TODO: Get from user preferences
enum HomeFiltersViewModel: Int, CaseIterable {
    case trending
    case technology
    case entertainment
    case health
    case science
    case sports

    var title: String {
        switch self {
        case .trending:
            return "Trending"
        case .technology:
            return "Technology"
        case .entertainment:
            return "Entertainment"
        case .health:
            return "Health"
        case .science:
            return "Science"
        case .sports:
            return "Sports"
        }
    }
}
