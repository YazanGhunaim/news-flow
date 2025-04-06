//
//  HomeFiltersViewModel.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/6/25.
//

import Foundation

struct HomeFilter: Identifiable, Equatable {
    let id = UUID()
    let title: String
}

@Observable
@MainActor
class HomeFiltersViewModel {
    var filters = [HomeFilter]()
    var selectedFilter: HomeFilter = .init(title: "trending")

    init() {
        loadUserCategoryPreferences()
    }

    func loadUserCategoryPreferences() {
        var saved = UserDefaultsManager.shared.getStringArray(forKey: .userArticleCategoryPreferences) ?? []

        // every user should get trending tab at beginning
        saved.insert("trending", at: 0)

        self.filters = saved.map { HomeFilter(title: $0) }
    }
}
